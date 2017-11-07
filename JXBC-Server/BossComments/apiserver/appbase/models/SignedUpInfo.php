<?php
namespace app\appbase\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition()
 */
class SignedUpInfo extends BaseModel
{  
    protected function initialize()
    {
        $this->connection = Config::get('db_passports');
    }
    protected $type = [
        'CreatedTime'       => 'datetime',
        'ModifiedTime'      => 'datetime',
        'SignedUpTime'      => 'datetime'
    ];    
    
    /**
     * @SWG\Property(type="long")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string")
     */
    public $InviteCode;
    
    /**
     * @SWG\Property(type="datetime")
     */
    public $SignedUpTime;       
}