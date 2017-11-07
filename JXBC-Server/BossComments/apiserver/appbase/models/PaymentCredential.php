<?php

namespace app\appbase\models;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"TradeCode","TotalFee","TradeMode","PayWay","BizSource","CommoditySubject","TotalFee","BizSource","BuyerId"})
 */
class PaymentCredential extends BaseModel {
    /**
     * @SWG\Property(description="交易编号", type="string")
     */
    public $TradeCode;

    /**
     * @SWG\Property(description="实际支付金额", type="number")
     */
    public $TotalFee;

    /**
     * @SWG\Property(type="string", description="添加时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;

    public function getTotalFeeAttr($value)
    {
        return parent::getMoneyWithDBUnit($value);
    }

    public function setTotalFeeAttr($value)
    {
        return parent::setMoneyWithDBUnit($value);
    }
}