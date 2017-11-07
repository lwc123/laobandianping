<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(description="提现确认状态")
 */
class DrawMoneyAuditStatus
{
    /**
     * @SWG\Property(type="int",description="未提交 <b>[ 0 ]</b>")
     */
    public $NoSubmit;
    const NoSubmit = 0;

    /**
     * @SWG\Property(type="int",description="已提交 <b>[ 1 ]</b>")
     */
    public $Submited;
    const Submited = 1;
    /**
     * @SWG\Property(type="int",description="认证通过 <b>[ 2 ]</b>")
     */
    public $AuditPassed;
    const AuditPassed =2;

    /**
     * @SWG\Property(type="int",description="认证被拒绝 <b>[ 9 ]</b>")
     */
    public $AuditRejected;
    const AuditRejected = 9;
}
