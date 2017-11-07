<?php
namespace app\workplace\services;

use app\appbase\models\BizSources;
use app\appbase\models\PayWays;
use app\workplace\models\CompanyBankCard;
use app\workplace\models\DrawMoneyRequest;
use app\appbase\models\TradeType;
use app\appbase\models\Wallet;
use app\common\models\Result;
use app\common\models\ErrorCode;
use app\common\modules\ServerVisitManager;
use think\Cache;

class DrawMoneyRequestService{
	
	
	/**
	 * 提现申请
	 * @access public
	 * @param string $Archive
	 *        	数据JSON
	 * @return integer
	 */
	public static function DrawMoneyRequestCreate($Request) {
		if (empty ( $Request )  || empty ( $Request ["BankCard"]) || empty ( $Request ["PresenterId"] )) {
			exception ( '非法请求-0', 412 );
		}

        $wallet = null;
        if($Request ["CompanyId"] && $Request ["CompanyId"] > 0){
            $wallet = Wallet::GetOrganizationWallet($Request ["CompanyId"]);
            $TradeType=TradeType::OrganizationToOrganization;
        }else{
            $wallet = Wallet::GetPrivatenessWallet($Request ["PresenterId"]);
            $TradeType=TradeType::OrganizationToPersonal;
        }
 		if(empty($wallet) ||$wallet["CanWithdrawBalance"] < $Request['MoneyNumber']){
 			return Result::error(ErrorCode::DrawMoneyRequest_CanWithdrawBalance, '提现金额不能大于可提现金额');
 		} 

 		//访问#c，扣钱，产生交易记录
        $post_url = Config('site_root_api').'/appbase/PaymentService/Withdraw';
        $post_data ['OwnerId'] =  $wallet["OwnerId"];
        $post_data ['TradeType'] =  $TradeType;
        $post_data ['PayWay'] =  PayWays::Wallet;
        $post_data ['TotalFee'] =  $Request['MoneyNumber'];
        $post_data ['CommoditySubject'] =  '提现';
        $post_data ['BizSource']=BizSources::Withdraw;
        $post_data ['BuyerId'] =  $Request ["PresenterId"];
        $DrawMoneyRequest =ServerVisitManager::ServerVisitPost($post_url, $post_data, 1 );
        if($DrawMoneyRequest['Success']==false){
            return Result::error(ErrorCode::Withdraw_Failed, '提现失败');
        }

         // 添加公司提现记录
        $SaveDrawMoneyRequest = DrawMoneyRequest::create ( $Request );
		
		// 返回提现ID
		$ApplyId = $SaveDrawMoneyRequest ['ApplyId']; 
		
		//查询有没有此银行卡
		if($Request ["CompanyId"]){
			$CompanyId=$Request ["CompanyId"];
		}else{
			$CompanyId=0;//个人公司填写为0
		}
		$FindBankCard=CompanyBankCard::where(['BankCard'=>$Request['BankCard'],'BankName'=>$Request['BankName'],'CompanyId'=>$CompanyId,'PresenterId'=>$Request['PresenterId']])->find();
 		if(empty($FindBankCard)){ 
			//公司添加此银行卡
			unset($Request['MoneyNumber']);unset($Request['AuditStatus']);unset($Request['ApplyId']);
			$Request['UseTime']=date('Y-m-d H:i:s',time());
	    	$SaveDrawMoneyRequest = CompanyBankCard::create ( $Request );
            $BankCard=[];
	    	//删除银行卡缓存，只有false时删除
            if ($CompanyId!=0){
                //企业查询缓存
                $ExistBankCard=CompanyBankCard::ExistBankCard($CompanyId,1);
                if ($ExistBankCard['ExistBankCard']===false){
                    $BankCard['ExistBankCard']=true;
                    $bankcard_key = CompanyBankCard::CacheName . '-' . $CompanyId  . '-Company';
                    Cache::set($bankcard_key, $BankCard, CompanyBankCard::CacheExpire);
                }
            }else{
                //个人查询缓存
                $ExistBankCard=CompanyBankCard::ExistBankCard($Request['PresenterId'],2);
                if ($ExistBankCard['ExistBankCard']===false){
                    $BankCard['ExistBankCard']=true;
                    $bankcard_key = CompanyBankCard::CacheName . '-' . $Request['PresenterId']  . '-Personal';
                    Cache::set($bankcard_key, $BankCard, CompanyBankCard::CacheExpire);
                }
            }

		}
		else{
			//更新卡号使用时间为当前
			CompanyBankCard::where(['AccountId'=>$FindBankCard['AccountId']])->update(['UseTime' => date('Y-m-d H:i:s')]);
		}


		return Result::success($ApplyId); 
	}

    /**
     * 提现审核列表
     */
    public static function findDrawMoneyByQuery($companyQuery, $pagination) {
        //$pagination = Pagination::Create($userQuery['Page'], $userQuery['Size']);
        $buildQueryFunc = function() use ($companyQuery) {
            $query = null;
            if (!isset($companyQuery['AuditStatus']) || strlen($companyQuery['AuditStatus'])==0) {
                $query = new DrawMoneyRequest;
            } else {
                $query = new DrawMoneyRequest;
                if($companyQuery['AuditStatus'] == '2') {
                    $query = $query->where('AuditStatus',2);
                } else {
                    $query = $query->where('AuditStatus',1);
                }
            }
            if (!empty($companyQuery['CompanyName'])) {
                $query = $query->where('CompanyName', 'like','%'.$companyQuery['CompanyName'].'%');
            }
            if( !empty($companyQuery['MaxSignedUpTime'])){
                $companyQuery['MaxSignedUpTime'] = date('Y-m-d',strtotime('+1 day',strtotime($companyQuery['MaxSignedUpTime'])));
            }else{
                $companyQuery['MaxSignedUpTime'] =   date('Y-m-d',strtotime('+1 day'));
            }
            if (!empty($companyQuery['MinSignedUpTime'])) {
                $query = $query->where('CreatedTime', 'between time', [$companyQuery['MinSignedUpTime'],$companyQuery['MaxSignedUpTime']]);
            }
            return $query;
        };
        $pagination->TotalCount =  $buildQueryFunc($companyQuery)->count();
        return $buildQueryFunc()->order ( 'CreatedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
    }
}