<?php
namespace app\appbase\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"RealName", "CurrentCompany", "CurrentJobTitle"})
 */
class UserProfile extends BaseModel
{  
    protected function initialize()
    {
        $this->connection = Config::get('db_passports');
    }
    
    protected $type = [
        'CreatedTime'       => 'datetime',
        'ModifiedTime'      => 'datetime',
        'LastSignedInTime'  => 'datetime',
        'LastActivityTime'  => 'datetime'
    ];
    
    /**
     * @SWG\Property(type="integer")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="integer")
     */
    public $CurrentProfileType;

    /**
     * @SWG\Property(type="string")
     */
    public $RealName;

    /**
     * @SWG\Property(type="string")
     */
    public $CurrentCompany;

    /**
     * @SWG\Property(type="string")
     */
    public $CurrentJobTitle;

    /**
     * @SWG\Property(type="string", format="datetime")
     */
    public $LastSignedInTime;

    /**
     * @SWG\Property(type="string", format="datetime")
     */
    public $LastActivityTime;    
}