<?php

namespace app\io\models;

use app\common\models\BaseModel;
use Think\Config;
/**
 * @SWG\Tag(
 * name="AdminUser",
 * description="后台渠道表"
 * )
 */
/**
 * @SWG\Definition(required={"PersonId"})
 */


class PersonEntity extends BaseModel{

	protected function initialize()
	{
		$this->connection = Config::get('db_io');
	}
    /**
     * @SWG\Property(type="integer", description="PersonId")
     */
    public $PersonId;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $MobilePhone;


    /**
     * @SWG\Property(type="string", description="")
     */
    public $Email;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $Gender;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $Birthday;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $IDCard;

    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime',
        'Birthday'      => 'datetime'
    ];

    public function Employee()
    {
        return $this->hasOne('EmployeeEntity', 'PersonId');
    }
}
?>