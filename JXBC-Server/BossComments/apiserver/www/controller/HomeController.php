<?php
namespace app\www\controller;

use app\common\controllers\CompanyApiController;
use app\common\modules\DbHelper;
use app\workplace\models\InvitedRegister;
use app\common\modules\PaymentEngine;
use app\workplace\services\ConsoleService;
use think\Request;
use think\Config;

class HomeController extends CompanyBaseController
{
    /**企业工作台
     * @param Request $request
     * @return mixed|null
     */
    public function console(Request $request)
    {
        return $this->fetch();
    }

    /**企业 邀请注册
     * @param Request $request
     * @return mixed|null
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
           // $InviteRegister = json_encode($InviteRegister,JSON_UNESCAPED_SLASHES);
            $this->assign('InviteRegister',$InviteRegister);
            return $this->fetch();
        }
    }
}


