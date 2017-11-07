<?php
namespace app\workplace\controller;
use app\common\controllers\PaymentHandlerController;
use think\Log;
use think\Request;
use app\appbase\models\Payment;
use app\common\models\Result;
use app\workplace\models\Company;
use app\workplace\services\EnterpriseService;

/**
 * @SWG\Tag(
 *   name="PaymentBizProcessor",
 *   description="支付后的业务处理APIs"
 * )
 */ 
class RenewalEnterpriseServiceController extends PaymentHandlerController {
	/**
	 * @SWG\POST(
	 *     path="/workplace/RenewalEnterpriseService/Preprocess",
	 *     summary="企业开户前的预处理",
	 *     tags={"PaymentBizProcessor"},
	 *     @SWG\Parameter(
	 *         name="body",
	 *         in="body",
	 *         description="支付参数",
	 *         required=true,
	 *         @SWG\Schema(ref="#/definitions/Payment"),
	 *     ),
	 *     @SWG\Response(
	 *         response=200,
	 *         description="交易记录信息，包括交易编码和第三方支付所需的（签名后）参数",
	 *         @SWG\Schema(type="boolean")
	 *     ),
	 *     @SWG\Response(
	 *         response="412",
	 *         description="不符合预期的输入参数",
	 *         @SWG\Schema(
	 *             ref="#/definitions/Error"
	 *         )
	 *     )
	 * )
	 */
	public function Preprocess(Request $request) {
        $payment = $request->put();
        Log::record($payment["CommodityExtension"]);

        $minTotalFee = 0.01;
        if($payment["TotalFee"] >= $minTotalFee) {
            return true;
        } else {
            return false;
        }
    }        
    /**    
     * @SWG\POST(
     *     path="/workplace/RenewalEnterpriseService/BizProcess",
     *     summary="企业开户",     
     *     tags={"PaymentBizProcessor"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易记录信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/TradeJournal"),
     *     ),       
     *     @SWG\Response(
     *         response=200,
     *         description="业务处理结果",
     *         @SWG\Schema(
     *             ref="#/definitions/Result"
     *         )
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(   
     *             ref="#/definitions/Error"
     *         )
     *     ) 
     * )
     */
    public function BizProcess(Request $request) {
        $tradeJournal = $request->put();

        try{
            $result = EnterpriseService::renewalEnterpriseService($tradeJournal);
            return $result;
        } catch (\Exception $e) {
            $this->error($e->getCode(),$e->getMessage());
        }
    }
}
