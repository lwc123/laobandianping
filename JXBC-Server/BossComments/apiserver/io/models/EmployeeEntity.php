<?php

namespace app\io\models;

use app\common\models\BaseModel;
use Think\Config;
/**
 * @SWG\Tag(
 * name="AdminUser",
 * description="雇员"
 * )
 */
/**
 * @SWG\Definition(required={"EmployeeId"})
 */


class EmployeeEntity extends BaseModel{

    protected function initialize()
    {
        $this->connection = Config::get('db_io');
    }
    /**
     * @SWG\Property(type="integer", description="EmployeeId")
     */
    public $EmployeeId;

    /**
     * @SWG\Property(type="integer", description="CompanyId")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="PersonId")
     */
    public $PersonId;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CompanyName;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $JobTitle;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $Department;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $WorkCity;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $WorkStart;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $WorkEnd;

    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime',
        'WorkStart'     => 'datetime',
        'WorkEnd'       => 'datetime'
    ];
}
?>