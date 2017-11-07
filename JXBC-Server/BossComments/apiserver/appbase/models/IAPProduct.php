<?php

namespace app\appbase\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"Name","ProductCode"})
 */
class IAPProduct
{
    /**
     * @SWG\Property(description="业务名称", type="long")
     */    
    public $Name;
    
   /**
     * @SWG\Property(description="苹果内购[产品ID]", type="integer")
     */
    public $ProductCode;

    /**
     * @SWG\Property(description="支付价格", type="number")
     */
    public $Price;
    
    /**
     * @SWG\Property(description="金币数量", type="number")
     */
    public $GoldCoins;
}