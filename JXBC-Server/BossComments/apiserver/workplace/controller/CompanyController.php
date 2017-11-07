<?php

namespace app\workplace\controller;

use app\common\controllers\CompanyApiController;
use app\workplace\models\Message;
use app\workplace\services\ConsoleService;
use think\Request;
use app\workplace\models\Company;
use app\workplace\models\EmployeArchive;
use app\workplace\models\CompanyMember;
use app\workplace\services\AuditService;
use app\appbase\models\Wallet;
use app\workplace\models\MemberRole;
use app\workplace\services\CompanyService;
use app\workplace\models\CompanyBankCard;
use app\workplace\models\CompanyAuditRequest;
use app\common\modules\PaymentEngine;

use app\workplace\models\InvitedRegister;
use app\common\modules\DbHelper;
use think\Config;
use app\common\models\Result;
use app\common\models\ErrorCode;
use app\common\modules\DictionaryPool;
use app\common\modules\ServerVisitManager;

class CompanyController extends  CompanyApiController {
 
	/**
	 * @SWG\POST(
	 * path="/workplace/Company/RequestCompanyAudit",
	 * summary="企业申请认证",
	 * description="实现备注:Wait",
	 * tags={"Company"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/CompanyAuditRequest"),
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="Wait",
	 * @SWG\Schema(ref="#/definitions/Result"),
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
	public function RequestCompanyAudit(Request $request) {
		$companyAuditRequest = $request->put ();
		if ($companyAuditRequest) { 
			// 验证手机验证码是否正确 
			$get_url =Config('site_root_api').'/appbase/Account/checkValidationCode?phone='.$companyAuditRequest ['MobilePhone'].'&code='.$companyAuditRequest['ValidationCode'];
			$ValidationCode = ServerVisitManager::ServerVisitGet($get_url);
			if($ValidationCode=="false"){
				return Result::error(ErrorCode::ValidationCode, '验证码输入错误');
			}
			$companyAuditRequest ['ApplicantId'] = $this->PassportId;
			if (empty($companyAuditRequest ['Region'])){
                $companyAuditRequest ['Region']='beijing';
            }
            AuditService::AuditRequest ( $companyAuditRequest );
			return Result::success();
		}
	}
 
	public function RequestCompanyAuditOnWeb(Request $request) {
    $CompanyId = $request->get('CompanyId');
    $companyAuditRequest = $request->post();
    if ($companyAuditRequest&&$CompanyId) {
        $companyAuditRequest['Company']['CompanyName']=$companyAuditRequest['CompanyName'];
        $companyAuditRequest['Company']['CompanyId']=$CompanyId;
        $companyAuditRequest['Company']['CompanyAbbr']=$companyAuditRequest['CompanyAbbr'];
        $companyAuditRequest['Company']['Industry']=$companyAuditRequest['Industry'];
        $companyAuditRequest['Company']['CompanySize']=$companyAuditRequest['CompanySize'];
        $companyAuditRequest['Company']['Region']=$companyAuditRequest['Region'];
        $companyAuditRequest['Company']['LegalName']=$companyAuditRequest['LegalName'];
        $companyAuditRequest['Licence']= base64_encode(request()->file('Licence'));
        foreach(request()->file('Images') as $file){
            $Images[]=base64_encode($file);
        }
        $companyAuditRequest['Images']= $Images;
        $companyAuditRequest ['ApplicantId'] = $this->PassportId;
        // $companyAuditRequest ['ApplicantId'] = $this->PassportId;
        $success = AuditService::AuditRequest ($companyAuditRequest );
        return $success;
    }
}

    /**
	 * @SWG\GET(
	 * path="/workplace/Company/myAuditInfo",
	 * summary="获取已提交认证信息",
	 * description="实现备注:CompanyId",
	 * tags={"Company"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="string"
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="Wait",
	 * @SWG\Schema(ref="#/definitions/CompanyAuditRequest"),
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
	public function myAuditInfo(Request $request)
	{
		$CompanyId = $request->param ( 'CompanyId' );
		if($CompanyId){
			$Info=CompanyAuditRequest::where('CompanyId',$CompanyId)->find();
			$Info['Company']=Company::get($CompanyId);
            $Info['Company']['CompanySizeText']=DictionaryPool::getEntryNames('CompanySize',$Info['Company']['CompanySize']);
            $Info['Company']['RegionText']=DictionaryPool::getEntryNames('city',$Info['Company']['Region']);
			return $Info;
		}
	} 
	/**
	 * @SWG\POST(
	 * path="/workplace/Company/update",
	 * summary="修改企业信息",
	 * description="公司LOGO、简称、行业，规模、城市可以修改，其余均不能修改",
	 * tags={"Company"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/Company"),
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="Wait",
	 * @SWG\Schema(type="boolean")
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
	public function update(Request $request) {
		// 获取JSON数据
		$request = $request->put ();
		if ($request) {
			$request ['ModifiedId'] = $this->PassportId;
			$update = CompanyService::CompanyUpdate( $request);
			return $update;
		}
	}

    /**
     * @SWG\GET(
     * path="/workplace/Company/summary",
     * summary="企业工作台",
     * description="实现备注:CompanyId",
     * tags={"Company"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="string"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/CompanySummary"
     * )
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
    public function summary(Request $request) {
        $CompanyId = $request->param ( 'CompanyId' );
        $Console=ConsoleService::Console($CompanyId,$this->PassportId);
        //字典信息
        $Console['CompanySizeText']=DictionaryPool::getEntryNames('CompanySize',$Console['CompanySize']);
        $Console['RegionText']=DictionaryPool::getEntryNames('city',$Console['Region']);
        return $Console;
    }
	
	/**
	 * @SWG\GET(
	 * path="/workplace/Company/mine",
	 * summary="我的",
	 * description="实现备注:CompanyId",
	 * tags={"Company"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="string"
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="",
	 * @SWG\Schema(
	 * ref="#/definitions/CompanySummary"
	 * )
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
	public function mine(Request $request) {
        $CompanyId = $request->param ( 'CompanyId' );
        $Console=ConsoleService::Console($CompanyId,$this->PassportId);
        //字典信息
        $Console['CompanySizeText']=DictionaryPool::getEntryNames('CompanySize',$Console['CompanySize']);
        $Console['RegionText']=DictionaryPool::getEntryNames('city',$Console['Region']);
        $Console['myCompanys'] = CompanyMember::where(['PassportId' => $this->PassportId])->count();
        return $Console;
    }
	
	/**
	 * @SWG\GET(
	 * path="/workplace/Company/InviteRegister",
	 * summary="企业成员邀请码",
	 * description="实现备注:CompanyId",
	 * tags={"Company"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="string"
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="",
	 * @SWG\Schema(
	 * ref="#/definitions/InvitedRegister"
	 * )
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
	public function InviteRegister(Request $request) {
		$companyId = $request->param ( 'CompanyId' );
		if($companyId){
			 $findcode=InvitedRegister::where(['CompanyId'=>$companyId,'PassportId'=>$this->PassportId])->find();
			 if ($findcode){
			 	$InviterCode=$findcode['InviterCode'];
			 }
			 else{
			 	$createcode=InvitedRegister::create([
			 			'CompanyId'=>$companyId,
			 			'PassportId'=>$this->PassportId,
			 			'InviterCode'=>createCode($this->PassportId,$companyId),
			 			'ExpirationTime'=>DbHelper::getMaxDbDate()
			 	]);
			 	$InviterCode=$createcode['InviterCode'];
			 }
			$InviteRegister=InvitedRegister::where(['CompanyId'=>$companyId,'PassportId'=>$this->PassportId])->find();
			$InviteRegister['InvitePremium']=(string)PaymentEngine::GetCompanyInviteRegisterPrice($companyId);
			$InviteRegister['InviteRegisterUrl']=Config('site_root_www')."/m/Account/register?InviteCode=".$InviterCode;
    		$InviteRegister['InviteRegisterQrcode']='http://www.kuaizhan.com/common/encode-png?large=true&data='.urlencode($InviteRegister['InviteRegisterUrl']);
			Config::set('default_return_type',"html");
    		return json_encode($InviteRegister,JSON_UNESCAPED_SLASHES);
		} 
	} 
}