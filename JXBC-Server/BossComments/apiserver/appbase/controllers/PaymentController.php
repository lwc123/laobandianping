<?php

namespace app\appbase\controller;

/**
 * @SWG\Tag(
 *   name="Payment",
 *   description="支付相关API"
 * )
 */ 
class PaymentController
{
    /**
     * @SWG\Get(
     *     path="/appbase/Payment/getIAPProduct",
     *     summary="获取指定业务的苹果内购产品信息",
     *     tags={"Payment"},
     *     description="",
     *     @SWG\Parameter(
     *         name="bizSource",
     *         in="query",
     *         description="业务源",
     *         required=true,
     *         type="string"
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="苹果内购产品信息",
     *         @SWG\Schema(
     *             ref="#/definitions/IAPProduct"
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
    public function getIAPProduct($request)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }

    /**
     * @SWG\Get(
     *     path="/appbase/Payment/getPayWays",
     *     summary="获取指定业务的所支持的支付方式",
     *     tags={"Payment"},
     *     description="",
     *     @SWG\Parameter(
     *         name="os",
     *         in="query",
     *         description="APP系统",
     *         required=true,
     *         type="string"
     *     ),
     *     @SWG\Parameter(
     *         name="bizSource",
     *         in="query",
     *         description="业务源",
     *         required=true,
     *         type="string"
     *     ),
     *     @SWG\Parameter(
     *         name="payWays",
     *         in="query",
     *         description="指定支付方式列表（仅供测试是使用）",
     *         required=false,
     *         type="string"
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="支付方式列表",
     *         @SWG\Schema(
     *          type="array",
     *          @SWG\Items(type="string")
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
    public function getPayWays($request)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }

    /**
     * @SWG\Definition(
     *   definition="PaymentResult:new",
     *   allOf={
     *     @SWG\Schema(ref="#/definitions/PaymentResult"),
     *     @SWG\Schema(required={"SignedParams"})
     *   },
     * )      
     * @SWG\POST(
     *     path="/appbase/Payment/createTrade",
     *     summary="创建交易记录",
     *     description="不同交易来源(BizSource)，使用商品相关参数组合<br/> <br/>对公交易时，必须设置参数<b>OwnerId</b>，开户时设置该值为 <b>-1</b>;",     
     *     tags={"Payment"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="交易信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/Payment"),
     *     ),       
     *     @SWG\Response(
     *         response=200,
     *         description="交易记录信息，包括交易编码和第三方支付所需的（签名后）参数",
     *         @SWG\Schema(
     *             ref="#/definitions/PaymentResult:new"
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
    public function createTrade($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }

    /**
     * @SWG\Definition(
     *   definition="PaymentResult:paid",
     *   allOf={
     *     @SWG\Schema(ref="#/definitions/PaymentResult"),
     *     @SWG\Schema(required={"PayWay","PaidDetail"})
     *   },
     * )    
     * @SWG\Post(
     *     path="/appbase/Payment/paymentCompleted",
     *     summary="处理APP支付结果，完成交易",
     *     tags={"Payment"},
     *     description="APP支付后，服务端进行后继处理(支付结果校验+修改交易状态+业务处理)",
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="支付结果（包含第三方支付结果)",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/PaymentResult:paid"),
     *     ),     
     *     @SWG\Response(
     *         response=200,
     *         description="支付结果",
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
    public function paymentCompleted($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }

    /**
     * @SWG\Post(
     *     path="/appbase/Payment/queryTrade",
     *     summary="查询交易是否成功支付",
     *     tags={"Payment"},
     *     description="",
     *     @SWG\Parameter(
     *         name="tradeCode",
     *         in="query",
     *         description="交易编号",
     *         required=true,
     *         type="string"
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="支付结果",
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
    public function queryTrade($request)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI");
    }
}
