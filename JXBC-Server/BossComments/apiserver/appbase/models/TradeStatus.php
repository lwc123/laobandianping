<?php
namespace app\appbase\models;

/**
 * @SWG\Definition()
 */
class TradeStatus
{ 
    /**
     * @SWG\Property(title="All", type="int",description="默认值 <b>[ 0 ]</b>")
     */
    public $All;
    const All = 0;
    
    /**
     * @SWG\Property(type="int",description="新的交易 <b>[ 1 ]</b>")
     */
    public $NewTrade;
    const NewTrade = 1;
    
    /**
     * @SWG\Property(type="int",description="等待支付 <b>[ 2 ]</b>")
     */
    public $WaitingPayment;
    const WaitingPayment = 2;
    
    /**
     * @SWG\Property(type="int",description="已支付，待进行业务处理 <b>[ 3 ]</b>")
     */
    public $Paid;
    const Paid = 3;

    /**
     * @SWG\Property(type="int",description="业务处理完成，订单处理结束 <b>[ 9 ]</b>")
     */
    public $BizCompleted;
    const BizCompleted = 9;    
}
