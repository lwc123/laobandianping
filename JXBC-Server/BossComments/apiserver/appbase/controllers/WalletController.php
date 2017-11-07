<?php

namespace app\appbase\controller;

class WalletController
{
    /**
     * @SWG\POST(
     *     path="/appbase/Wallet/Pay",
     *     summary="（使用钱包）支付指定交易",
     *     description="不同交易来源(BizSource)，使用商品相关参数组合<br/> <br/>对公交易时，必须设置参数<b>OwnerId</b>，开户时设置该值为 <b>-1</b>;",     
     *     tags={"Payment"},
     *     @SWG\Parameter(
     *         name="ownerId",
     *         in="query",
     *         description="交易所有人(对私交易：当前用户PassportId,；对公交易：所属机构的机构Id),必须传入该值",
     *         required=true,
     *         type="integer"
     *     ),
     *     @SWG\Parameter(
     *         name="tradeCode",
     *         in="query",
     *         description="交易编号",
     *         required=true,
     *         type="string"
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="支付结果，包含详细的支付凭据",
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
    public function Pay($entity)
    {
        throw new Exception("逻辑实现位于.net项目 JXBC.WebAPI"); 
    }
}
