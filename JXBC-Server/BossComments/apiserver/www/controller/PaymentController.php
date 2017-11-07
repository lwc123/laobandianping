<?php
namespace app\www\controller;
use think\Config;
use think\Request;
use think\Controller;
use app\appbase\models\TradeJournal;
use app\common\controllers\AuthenticatedController;

class PaymentController extends AuthenticatedController
{
    public function SelectPayWay(Request $request)
    {
        $payment = json_decode($request -> get("payment"));
        $CompanyId=$request -> get("CompanyId");
        $this->assign('Payment', $payment);
        $this->assign('CommodityExtension', json_decode($payment->CommodityExtension));
        if (empty($CompanyId)){
            $this->UserPassport=parent::GetPassport();
            PrivatenessBaseController::assignConsoleSummary($this, $this->PassportId, $this->UserPassport);
            return $this->fetch('PrivatenessSelectPayWay');
        }else{
            CompanyBaseController::assignConsoleSummary($this, $this->PassportId);
            return $this->fetch();
        }

    }

    public function QRCodePay(Request $request)
    {
        $tradeCode = $request->get("TradeCode");
        if(empty($tradeCode)) {
            return $this -> error(412, "Check params failed. ");
        }
        $payment = TradeJournal::get($tradeCode);

        $this->assign('Payment', $payment);
        $this->assign('CommodityExtension', json_decode($payment["CommodityExtension"]));
        return $this->fetch();
    }

    public function PaySuccess(Request $request)
    {
        return $this->fetch();
    }
}


