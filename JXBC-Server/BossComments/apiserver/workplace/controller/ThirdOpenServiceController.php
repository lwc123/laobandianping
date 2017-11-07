<?php
namespace app\workplace\controller;
use app\common\Controllers\MicroServiceApiController;
use think\Request;
use think\Db;
use app\workplace\models\Company;
use app\common\models\Result;
use app\workplace\models\MemberRole;
use app\workplace\models\CompanyMember;
use app\common\modules\DbHelper;
use app\workplace\models\CompanyAsset;
use app\workplace\models\ServiceContract;
use app\admin\models\Channel;
use app\common\modules\ServerVisitManager;

class ThirdOpenServiceController extends MicroServiceApiController
{
	/**
	 * @SWG\POST(
	 * path="/workplace/ThirdOpenService/index",
	 * summary="渠道邀请企业注册开通服务",
	 * description="",
	 * tags={"ThirdOpenService"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/ThirdOpenService")
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="Wait",
	 * @SWG\Schema(type="integer",format="int64")
	 * ),
	 * @SWG\Response(
	 * response="412",
	 * description="参数不符合要求",
	 * @SWG\Schema(
	 * ref="#/definitions/Error"
	 * )
	 * )
	 * )
	 */
	public function index(Request $request) {
		// 获取档案评价JSON数据 
		$registerandopenservice = $request->put (); 
		if ($registerandopenservice) { 
			$MobilePhone=$registerandopenservice ["mobile_phone"];
			$CompanyName=$registerandopenservice ["company_name"];
			$RealName=$registerandopenservice ["real_name"];
			$JobTitle=$registerandopenservice ["job_title"];
			$ChannelCode=$registerandopenservice ["channel_code"];
			$ChannelName=$registerandopenservice ["channel_name"];
			
			$ExistCompanyName=Company::where('CompanyName',$CompanyName)->find();
			if ($ExistCompanyName){ 
				//返回实体
				$ThirdReturn=[
						'Success'=>false,
						'ErrorCode'=>1101,
						'ErrorMsg'=>'company_exists' 
				];
				return $ThirdReturn;
			}
			
			$ExistPassportId = Db::connect ( 'db_passports' )->table ( 'user_passport' )->where ( 'MobilePhone',$MobilePhone )->value ( 'PassportId' );
			if($ExistPassportId){
				//用户存在
				$ExistMobilePhone =true;
				$password='';
				$PassportId=$ExistPassportId;
			}
			else{
				//用户不存在
				$ExistMobilePhone=false;
				$password=rand('100000','999999');
				// 增加新用户
                $post_url = Config('site_root_api').'/appbase/Account/signup';
				$post_data ['MobilePhone'] = $MobilePhone;
				$post_data ['Password'] = $password;
				$post_data ['ValidationCode'] = '112233';
				$post_data ['SelectedProfileType'] = 2;
                $result = ServerVisitManager::ServerVisitPost($post_url, $post_data, 1);
				$PassportId = $result ['Account'] ['PassportId']; 
			}
			
			//创建企业信息 
			$company = Company::create([ 
            'CompanyName' => $CompanyName,
            'PassportId' => $PassportId,
			'ChannelCode' => $ChannelCode,
			'ContractStatus' => 2 ]);
			  
			// 添加管理员
			$companyMember = new CompanyMember ( [
					'CompanyId' => $company ["CompanyId"],
					'Role' => MemberRole::Manager, // admin
					'PassportId' => $PassportId,
					'RealName' => $RealName,
					'JobTitle' => $JobTitle,
					'MobilePhone' => $MobilePhone
			] );
			$companyMember->allowField ( true )->save ();
				
			// 添加企业资产
			$companyAsset = new CompanyAsset ( [
					'CompanyId' => $company ["CompanyId"],
					'AssetType' => 1,
					'AssetNum' => - 1
			] );
			$companyAsset->allowField ( true )->save ();
				
			// 添加企业合同
			$serviceContract = new ServiceContract ( [
					'CompanyId' => $company ["CompanyId"],
					'PassportId' => $PassportId,
					'ContractStatus' => 2,
					'ServiceBeginTime' => date ( "Y-m-d H:i:s" ),
					'ServiceEndTime' => DbHelper::getMaxDbDate (),
					'AdditionalInfo' => '渠道注册'
					//'TotalFee' => $registerandopenservice ["TotalFee"]
			] );
			$serviceContract->allowField ( true )->save ();
			
			//保存渠道来源
			$fundchannel=Channel::where(['ChannelName'=>$ChannelName,
					'ChannelCode'=>$ChannelCode])->find();
			if(empty($fundchannel)){
				$addchannel=Channel::create([
						'ChannelName'=>$ChannelName,
						'ChannelCode'=>$ChannelCode
				]
				);
			}
			 
			//返回实体
			$ThirdReturn=[
					'Success'=>true,
					'CompanyId'=>$company ["CompanyId"],
					'MobilePhone'=>$MobilePhone,
					'Password'=>$password,
					'ExistMobilePhone'=>$ExistMobilePhone
			]; 
			return $ThirdReturn; 
		}
	}
	
}