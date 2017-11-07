<?php
namespace app\www\controller;
use app\workplace\models\CompanyMember;
use think\Config;
use think\Request;
use think\Controller;
use app\workplace\models\Company;
use app\workplace\models\CompanyAuditRequest;
use app\appbase\AccountController;
use app\workplace\services\AuditService;
use app\common\modules\DictionaryPool;
use app\workplace\services\CompanyService;
use app\workplace\models\AuditStatus;
use app\workplace\models\DictionaryEntry;


class CompanyAuditController extends CompanyBaseController
{
    /**
     * 企业认证第一步  第二步
     * User: hank.
     * Date: 2017/1/16
     * Time: 15:23
     */
    public function AuditStepFirst(Request $request)
    {
          //获取公司Id
          $CompanyId =  $request->get('CompanyId');
          $Company = Company::where('CompanyId', $CompanyId)->find();
          $AuditRequest= CompanyAuditRequest::where('CompanyId', $CompanyId)->find();
          //字典
          $CompanySizeDictionary = DictionaryPool::getDictionaries('CompanySize', '');
          $Company['RegionText'] = DictionaryPool::getEntryNames('city',$Company['Region']);
       //return  json_encode($Company);
          //传值
          $this->assign('CompanySizeDictionary', $CompanySizeDictionary);
          $this->assign('Company', $Company);
          $this->assign('AuditRequest', $AuditRequest);

         //判断审核状态
            if($AuditRequest['AuditStatus']==AuditStatus::Submited){
                return $this->fetch('AuditGoing');
            }elseif($AuditRequest['AuditStatus']==AuditStatus::AuditPassed){
                //成功进入工作台
                return $this->fetch('/Home/console');
            }elseif($AuditRequest['AuditStatus']==AuditStatus::AuditRejected) {
                //拒绝或者未提交
                return $this->fetch('AuditStepFirst');
            }else{
                return $this->fetch('AuditStepFirst');
            }

    }

    public function AuditGoing()
    {
          return $this->fetch();
    }


    /**
     * 认证企业信息
     *
     * @param Request $request
     * @return mixed
     */
    public function RequestCompanyAudit(Request $request) {
        $companyAuditRequest = $request->post();
        if ($companyAuditRequest) {
            $companyAuditRequest['Company']['CompanyName']=$companyAuditRequest['CompanyName'];
            $companyAuditRequest['Company']['CompanyId']=$companyAuditRequest['CompanyId'];
            $companyAuditRequest['Company']['CompanyAbbr']=$companyAuditRequest['CompanyAbbr'];
            $companyAuditRequest['Company']['Industry']=$companyAuditRequest['Industry'];
            $companyAuditRequest['Company']['CompanySize']=$companyAuditRequest['CompanySize'];
            $companyAuditRequest['Company']['Region']=$companyAuditRequest['Region'];
            $companyAuditRequest['Company']['LegalName']=$companyAuditRequest['LegalName'];
           // $companyAuditRequest['Licence']=  base64EncodeImage($_FILES["Licence"]);
            $companyAuditRequest['Licence']= empty($_FILES["Licence"]['tmp_name']) ? $companyAuditRequest['Licence1']: base64EncodeImage($_FILES["Licence"]);
            /*$ImagesZ= empty($_FILES["ImagesZ"]['tmp_name']) ? $companyAuditRequest['ImagesZ1'] : base64EncodeImage($_FILES["ImagesZ"]);
            $ImagesF= empty($_FILES["ImagesF"]['tmp_name']) ? $companyAuditRequest['ImagesF1'] : base64EncodeImage($_FILES["ImagesF"]);*/
            unset($companyAuditRequest['Licence1']);
           /* unset($companyAuditRequest['ImagesZ1']);
            unset($companyAuditRequest['ImagesF1']);
            $companyAuditRequest['Images']=array($ImagesZ,$ImagesF);*/
            $companyAuditRequest['Images'] =[];
            $companyAuditRequest ['ApplicantId'] =$this->PassportId;
            $success = AuditService::AuditRequest ($companyAuditRequest );
            if($success){
                $post = "/CompanyAudit/AuditStepFirst?CompanyId=".$companyAuditRequest['CompanyId'];
                header ( "location:$post" );
            }
        }else{
            return $this->fetch('AuditGoing');
        }
    }

}


