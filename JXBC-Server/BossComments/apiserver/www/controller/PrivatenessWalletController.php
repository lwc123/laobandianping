<?php
namespace app\www\controller;
use app\appbase\models\TradeMode;
use app\appbase\models\TradeJournal;
use app\common\modules\DbHelper;
use think\Config;
use think\Request;
use think\Controller;
use app\www\services\PaginationServices;
use app\common\modules\PaymentEngine;

use app\workplace\models\InvitedRegister;

class PrivatenessWalletController extends PrivatenessBaseController
{
    public function Index(Request $request)
    {
        $mode = $request->get("mode");
        if(!isset ($mode)) {
            $mode = TradeMode::All;
        }
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $urlQuery = "mode=$mode";

        $tradeHistroy = TradeJournal::FindPersonalTradeHistory($this->PassportId, $mode, $pagination);
        if(!empty($tradeHistroy)) {
            $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery, $request->action());
            $this->view->assign('PageNavigation', $pageNavigation);
        }

        $this->view->assign('TradeMode', $mode);
        $this->view->assign('TradeHistroy', $tradeHistroy);
        $this->view->assign('Pagination', $pagination);

        return $this->fetch();
    }

    /**
     * 个人端邀请
     * @return string
     */
    public function InviteRegister() {
        $PassportId = $this->PassportId;
        if($PassportId){
            $findcode=InvitedRegister::where(['CompanyId'=>0,'PassportId'=>$PassportId])->find();
            if ($findcode){
                $InviterCode=$findcode['InviterCode'];
            }
            else{
                $createcode=InvitedRegister::create([
                    'CompanyId'=>0,
                    'PassportId'=>$PassportId,
                    'InviterCode'=>createCode($this->PassportId,0),
                    'ExpirationTime'=>DbHelper::getMaxDbDate()
                ]);
                $InviterCode=$createcode['InviterCode'];
            }
            $InviteRegister=InvitedRegister::where(['CompanyId'=>0,'PassportId'=>$this->PassportId])->find();

            $InviteRegister['InvitePremium']=(string)PaymentEngine::GetPrivatenessInviteRegisterPrice($PassportId);
            $InviteRegister['InviteRegisterUrl']=Config('site_root_www')."/m/Account/register?InviteCode=".$InviterCode;
            $InviteRegister['InviteRegisterQrcode']='http://www.kuaizhan.com/common/encode-png?large=true&data='.urlencode($InviteRegister['InviteRegisterUrl']);
            Config::set('default_return_type',"html");
            $this->assign('InviteRegister',$InviteRegister);
            return $this->fetch();
        }
    }
}


