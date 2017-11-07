<?php
namespace app\www\controller;

use app\appbase\models\Wallet;
use app\common\controllers\AuthenticatedController;
use app\workplace\models\Message;
use app\workplace\models\PrivatenessServiceContract;
use think\Request;
use app\workplace\models\CompanyMember;

class PrivatenessBaseController extends AuthenticatedController
{
    static function assignConsoleSummary($controller, $passportId,$UserPassport)
    {
        //我的用户ID
        $controller->view->assign('PassportId', $passportId);
        $controller->view->assign('MyMobilePhone', $UserPassport['MobilePhone']);

        //我的基本信息
        $controller->view->assign('PrivatenessInfo', $UserPassport);

        //我的小金库
        $MyWallet = Wallet::GetPrivatenessWallet($passportId);
        $controller->view->assign('MyWallet', $MyWallet);

        //我的未读消息
        $MyUnreadMessageNum = Message::where(['ToPassportId' => $passportId, 'IsRead' => 0])->count();
        $controller->view->assign('MyUnreadMessageNum', $MyUnreadMessageNum);
        //我的公司数
        $myCompanys = CompanyMember::where(['PassportId' =>$passportId])->count();
        $controller->view->assign('myCompanys', $myCompanys);

    }

    /**构造，工作台左侧
     * @param Request $request
     * @return mixed|null
     */
    public function __construct(Request $request)
    {
        parent::__construct();
        $this->UserPassport=parent::GetPassport();
        $this->MyMobilePhone=$this->UserPassport['MobilePhone'];
        self::assignConsoleSummary($this, $this->PassportId,$this->UserPassport);
    }
}


