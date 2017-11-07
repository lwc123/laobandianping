<?php
namespace app\appbase\models;

/**
 * @SWG\Definition()
 */
class TradeMode
{ 
    /**
     * @SWG\Property(title="All", type="int",description="默认值 <b>[ 0 ]</b>")
     */
    public $All;
    const All = 0;
    
    /**
     * @SWG\Property(type="int",description="收益 <b>[ 1 ]</b>")
     */
    public $Payoff;
    const Payoff = 1;
    /**
     * @SWG\Property(type="int",description="支出 <b>[ 2 ]</b>")
     */
    public $Payout;
    const Payout = 2;
    
    /**
     * @SWG\Property(type="int",description="消费记录 <b>[ 21 ]</b>")
     */
    public $Action_Buy;
    const Action_Buy = 21;

    /**
     * @SWG\Property(type="int",description="提现/提现退款 <b>[ 22 ]</b>")
     */
    public $Action_Withdraw;
    const Action_Withdraw = 22;
}
