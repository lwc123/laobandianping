<?php

namespace app\appbase\controller;

/**
 * @SWG\Tag(
 *   name="PaymentService",
 *   description="支付相关API（服务器授权调用）"
 * )
 * @SWG\Definition(
 *   definition="Payment:parent",
 *   allOf={
 *     @SWG\Schema(ref="#/definitions/Payment"),
 *     @SWG\Schema(required={"ParentTradeCode"})
 *   },
 * )
 */ 
class PaymentServiceController
{
    /**
     * @SWG\POST(
     *     path="/appbase/PaymentService/Withdraw",
     *     summary="提现扣款",
     *     description="提现后，立即从钱包扣款",
     *     tags={"PaymentService"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/Payment"),
     *     ),       
     *     @SWG\Response(
     *         response=200,
     *         description="交易记录信息，包括提现结果",
     *         @SWG\Schema(
     *             ref="#/definitions/PaymentResult"
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
    public function Withdraw($payment)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }

    /**
     * @SWG\POST(
     *     path="/appbase/PaymentService/Refund",
     *     summary="退款",
     *     description="指定交易记录，进行退款",
     *     tags={"PaymentService"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/Payment:parent"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="交易记录信息，包括退款结果",
     *         @SWG\Schema(
     *             ref="#/definitions/PaymentResult"
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
    public function Refund($payment)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }

    /**
     * @SWG\POST(
     *     path="/appbase/PaymentService/ShareIncome",
     *     summary="收入分成",
     *     description="A对B发生消费行为时，当A的交易完成时，给B的分成",
     *     tags={"PaymentService"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/Payment:parent"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="交易记录信息，包括分成结果",
     *         @SWG\Schema(
     *             ref="#/definitions/PaymentResult"
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
    public function ShareIncome($payment)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }

    /**
     * @SWG\POST(
     *     path="/appbase/PaymentService/SystemGift",
     *     summary="系统赠送",
     *     description="系统赠送给用户指定的消费金额",
     *     tags={"PaymentService"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/Payment"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="交易记录信息，包括分成结果",
     *         @SWG\Schema(
     *             ref="#/definitions/PaymentResult"
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
    public function SystemGift($payment)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }

    /**
     * @SWG\POST(
     *     path="/appbase/PaymentService/OfflinePay",
     *     summary="系统赠送",
     *     description="系统赠送给用户指定的消费金额",
     *     tags={"PaymentService"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/PaymentResult"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="交易记录信息",
     *         @SWG\Schema(
     *             ref="#/definitions/PaymentResult"
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
    public function OfflinePay($paymentResult)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }
}
