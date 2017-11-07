<?php
namespace app\workplace\models;

/**
 * @SWG\Definition()
 */
class ContractStatus
{ 
    /**
     * @SWG\Property(title="All", type="int",description="默认值 <b>[ 0 ]</b>")
     */
    public $All;
    const All = 0;
    
    /**
     * @SWG\Property(type="int",description="新的合同 <b>[ 1 ]</b>")
     */
    public $NewContract;
    const NewContract = 1;

    /**
     * @SWG\Property(type="int",description="服务中 <b>[ 2 ]</b>")
     */
    public $Servicing;
    const Servicing = 2;

    /**
     * @SWG\Property(type="int",description="服务已结束（过期） <b>[ 3 ]</b>")
     */
    public $ServiceEnd;
    const ServiceEnd = 10;
}
