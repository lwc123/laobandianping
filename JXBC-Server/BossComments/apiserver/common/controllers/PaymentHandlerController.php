<?php
namespace app\common\controllers;

use think\Controller;
use think\Request;
use app\common\controllers\MicroServiceApiController;
use app\appbase\models\TradeStatus;
use app\appbase\models\TradeJournal;

/**
 * @SWG\Tag(
 *   name="PaymentHandler",
 *   description="购买相关的业务处理"
 * )
 */ 
class PaymentHandlerController extends Controller {

    public function __construct() {
        parent::__construct();
    }

    protected function loadTradeJournal(Request $request) {
        $payment = $request->put();
        if(empty($payment)|| empty($payment["TradeCode"])) {
            exception('非法请求-0', 412);
        }
        
        $tradeJournal = TradeJournal::get(['TradeCode' => $payment["TradeCode"]]);
        if(empty($tradeJournal)) {
            exception('非法请求-1', 412);
        }
        
        if($tradeJournal["TradeStatus"] != TradeStatus::Paid && $tradeJournal["TradeStatus"] != TradeStatus::BizCompleted) {
            exception('非法请求-2', 412);
        }
        
        return $tradeJournal;
    }
}