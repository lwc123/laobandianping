<?php

namespace app\m\controller;
use app\Admin\controller\UserController;
use app\appbase\models\UserPassport;
use app\common\controllers\PageController;
use app\workplace\models\ActivityType;
use app\workplace\models\Company;
use app\workplace\models\CompanyMember;
use app\workplace\models\InvitedRegister;
use app\workplace\services\PriceStrategyService;
use think\Request;
use app\admin\models\Channel;
  
class AccountController extends PageController {
    public function register(Request $request) {
        $inviter = $request->param ();
        $inviteCode = $request->get("InviteCode");
        if(empty($inviteCode)) $inviteCode = $request->get("InviterCode");

        $inviteName = null;
        $invitePersonInfo = null;
        $Avatar='/mobile/img/pic.png';
        //查看是否为渠道用户
        if(isset($inviter['channel_code'])){
            $inviteCode=$inviter['channel_code'];
            $fundchannel=Channel::where(['ChannelName'=>$inviter['channel_name'],'ChannelCode'=>$inviter['channel_code']])->find();
            if(empty($fundchannel)){
                Channel::create([
                        'ChannelName'=>$inviter['channel_name'],
                        'ChannelCode'=>$inviter['channel_code']
                    ]
                );
            }
            $inviteName=$inviter['channel_name'];
        }
        //查看是否为自主注册用户

        if(empty($inviteName) && !empty($inviteCode)){
            $FundInviterCode=InvitedRegister::where('InviterCode',$inviteCode)->find();
            if ($FundInviterCode['CompanyId']>0){
                $inviteName=Company::where('CompanyId',$FundInviterCode['CompanyId'])->value('CompanyName');
                $invitePersonInfo=CompanyMember::getPassportRoleByCompanyId($FundInviterCode['CompanyId'],$FundInviterCode['PassportId']);
            }else{
                $inviteName='您的好友（'.UserPassport::load($FundInviterCode['PassportId'])['MobilePhone'].' )';
            }
            if(UserPassport::load($FundInviterCode['PassportId'])['UserProfile']['Avatar']){
                $Avatar=UserPassport::load($FundInviterCode['PassportId'])['UserProfile']['Avatar'];
            }
        }
        $baseName = urlencode(base64_encode($inviteName));
        $this->view->assign ( 'InviteCode', $inviteCode );
        $this->view->assign ( 'InviteName', $inviteName );
        $this->view->assign ( 'InvitePersonInfo', $invitePersonInfo );
        $this->view->assign ( 'Avatar', $Avatar );
        $this->view->assign ( 'BaseName', $baseName );
        if ($request->isMobile())
            return $this->fetch ();
        else
            return $this->redirect(sprintf("/account/register?InviteCode=%s&InviteName=%s",$inviteCode,$baseName));
    }
	public function signUp(Request $request) {
        $inviteCode = $request->get("InviteCode");
        if(empty($inviteCode)) $inviteCode = $request->get("InviterCode");
        $inviteName = $request->get("InviteName");
        if(!empty($inviteName)) {
            $inviteName = base64_decode($inviteName);
        }
        $this->view->assign ( 'InviteCode', $inviteCode );
        $this->view->assign ( 'InviteName', $inviteName );
		return $this->fetch ();
	}

	//开户页面,查询当前活动
    public function paydetail(Request $request)
    {
        $CurrentActivity['ActivityType']=ActivityType::CompanyOpen;
        $CurrentActivityOpen = PriceStrategyService::CurrentActivity($CurrentActivity);


        $this->view->assign ( 'CurrentPrice', $CurrentActivityOpen['AndroidPreferentialPrice'] );

        $this->view->assign ( 'CurrentActivityOpen', $CurrentActivityOpen );
        return $this->fetch();
    }

    //开户页面,查询当前活动
    public function pay(Request $request)
    {
        $CurrentActivity['ActivityType']=ActivityType::CompanyOpen;
        $CurrentActivityOpen = PriceStrategyService::CurrentActivity($CurrentActivity);

        $this->view->assign ( 'CurrentPrice', $CurrentActivityOpen['AndroidPreferentialPrice'] );
        return $this->fetch();
    }

    //下载页面
    public function share(Request $request){
	    //下载链接
        $userAgent = strtolower($request->header('user-agent'));
        if( strpos($userAgent, "ios") !== false  || strpos($userAgent, "iphone") !== false || strpos($userAgent, "mac os x") !== false) {
            $this->view->assign ( 'download', Config('app_download_ios') );
        }elseif (strpos($userAgent, "micromessenger") !== false){
            $this->view->assign ( 'download', Config('app_download_wechat') );
        }else{
            $this->view->assign ( 'download', Config('app_download_apk') );
        }

        //开户企业名称
        $CompanyId=$request->get('CompanyId');
        if ($CompanyId){
            $this->view->assign ( 'CompanyName', Company::where('CompanyId',$CompanyId)->value('CompanyName') );
        }else{
            $this->view->assign ( 'CompanyName', $request->get('CompanyName'));
        }

        return $this->fetch();
    }


    public function fastLogin()
    {
        return $this->fetch();
    }

    public function _empty()
    {
        return $this->fetch();
    }

}


