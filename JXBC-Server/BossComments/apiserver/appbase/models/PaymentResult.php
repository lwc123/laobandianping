<?php

namespace app\appbase\models;

/**
 * @SWG\Definition(required={"Success","TradeCode"})
 */
class PaymentResult extends Payment
{   
    /**
     * @SWG\Property(description="是否成功", type="boolean")
     */
    public $Success;

    /**
     * @SWG\Property(description="第三方支付完成后得到的原始结果", type="string")
     */    
    public $PaidDetail; 
    /**
     * @SWG\Property(type="string")
     */    
    public $TargetBizTradeCode; 

    /**
     * @SWG\Property(type="string")
     */    
    public $ErrorCode; 
    /**
     * @SWG\Property(type="string")
     */    
    public $ErrorMessage; 
}