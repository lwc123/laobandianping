<?php
namespace app\www\controller;
use think\Config;
use think\Request;
use think\Controller;
use app\appbase\models\UserPassport;
use app\workplace\models\InvitedRegister;
use app\admin\models\Channel;

class AccountController extends Controller
{
    public function _empty()
    {
        return $this->fetch();
    }

    public function register(Request $request) {
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

    /**退出登录
     * @param Request $request
     * @return mixed|null
     */
    public function signout()
    {
        setcookie("JX-TOKEN", "", time() - 3600, "/");
        $post = "/Account/login";
        header ( "location:$post" );
    }
}


