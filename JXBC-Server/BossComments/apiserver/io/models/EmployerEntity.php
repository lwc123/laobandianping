<?php

namespace app\io\models;

use app\common\models\BaseModel;
use Think\Config;
/**
 * @SWG\Tag(
 * name="EmployerEntity",
 * description="雇主"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId","CompanyName"})
 */


class EmployerEntity extends BaseModel{

    protected function initialize()
    {
        $this->connection = Config::get('db_io');
    }
    /**
     * @SWG\Property(type="integer", description="EmployerId")
     */
    public $EmployerId;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CompanyName;


    /**
     * @SWG\Property(type="integer", description="")
     */
    public $EmployeeCount;
}

?>