<?php
namespace app\workplace\models;
 
use think\Db;
use app\common\models\BaseModel;
/**
 * @SWG\Definition(required={"PassportId","InviterCode"})
 */
class InvitedRelationship  extends BaseModel
{
    public static function findByPassportId($passportId) {
        $relationship = self::where(['PassportId' => $passportId])->order("ModifiedTime desc")->find();
        return $relationship;
    }
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $RelationshipId;

	/**
	 * @SWG\Property(type="integer", description="用户ID")
	 */
	public $PassportId;
		
	/**
	 * @SWG\Property(type="string", description="邀请码")
	 */
	public $InviteCode;

	/**
	 * @SWG\Property(type="string", description="添加时间")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="修改时间")
	 */
	public $ModifiedTime;
	
	protected $type = [
			'CreatedTime'   => 'datetime',
			'ModifiedTime'  => 'datetime',
	];
	
}