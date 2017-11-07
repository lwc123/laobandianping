<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(description="价格策略状态")
 */
class PriceStrategyAuditStatus
{
    /**
     * @SWG\Property(type="int",description="关闭 <b>[ 1 ]</b>")
     */
    public $PriceStrategyClose;
    const AuditStatusClose = 1;

    /**
     * @SWG\Property(type="int",description="等待中 <b>[ 2 ]</b>")
     */
    public $AuditStatusWait;
    const AuditStatusWait = 2;

    /**
     * @SWG\Property(type="int",description="进行中 <b>[ 3 ]</b>")
     */
    public $AuditStatusUnderway;
    const AuditStatusUnderway =3;

    /**
     * @SWG\Property(type="int",description="已过期 <b>[ 4 ]</b>")
     */
    public $AuditStatusStale;
    const AuditStatusStale =4;

}
