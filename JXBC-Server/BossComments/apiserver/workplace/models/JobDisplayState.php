<?php
namespace app\workplace\models;

/**
 * @SWG\Definition()
 */

class JobDisplayState
{


    /**
     * @SWG\Property(type="int",description="显示职位 <b>[ 0 ]</b>")
     */
    public $OpenJob;
    const OpenJob = 0;


    /**
     * @SWG\Property(type="int",description="关闭职位 <b>[ 1 ]</b>")
     */
    public $CloseJob;
    const CloseJob = 1;

}