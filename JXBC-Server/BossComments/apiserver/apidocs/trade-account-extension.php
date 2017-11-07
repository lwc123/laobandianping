<?php

namespace Appbase;

class TradeExtensionContainer
{
    /**
     * @SWG\Get(
     *     path="/trade/TradeType",
     *     summary="交易类型",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="交易类型",
     *         @SWG\Schema(ref="#/definitions/TradeType")
     *     )
     * )
     */
    public function TradeType()
    {
    }
    
    /**
     * @SWG\Get(
     *     path="/trade/TradeMode",
     *     summary="交易模式",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="交易模式",
     *         @SWG\Schema(ref="#/definitions/TradeMode")
     *     )
     * )
     */
    public function TradeMode()
    {
    }
    
    /**
     * @SWG\Get(
     *     path="/trade/BizSources",
     *     summary="业务来源",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="业务来源",
     *         @SWG\Schema(ref="#/definitions/BizSources")
     *     )
     * )
     */    
    public function BizSources()
    {
    }   

    /**
     * @SWG\Get(
     *     path="/trade/PayWays",
     *     summary="交易路径(微信\支付宝\银联等)",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="交易路径",
     *         @SWG\Schema(ref="#/definitions/PayWays")
     *     )
     * )
     */    
    public function PayWays(){} 

    /**
     * @SWG\Get(
     *     path="/trade/OpenEnterpriseRequest",
     *     summary="企业开户申请信息",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="开户交易是，附加的企业开户申请信息",
     *         @SWG\Schema(ref="#/definitions/OpenEnterpriseRequest")
     *     )
     * )
     */    
    public function OpenEnterpriseRequest(){} 
    
    /**
     * @SWG\Get(
     *     path="/const/PaymentExtension/TradeStatus",
     *     summary="交易状态",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/TradeStatus")
     *     )
     * )
     */    
    public function TradeStatus() {}  

    /**
     * @SWG\Get(
     *     path="/const/PaymentExtension/WalletType",
     *     summary="钱包类型",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="",
     *         @SWG\Schema(ref="#/definitions/WalletType")
     *     )
     * )
     */    
    public function WalletType() {}      
}