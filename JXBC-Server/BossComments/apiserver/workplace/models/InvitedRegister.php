<?php
namespace app\workplace\models;
 
use think\Db;
use app\common\models\BaseModel;
/**
 * @SWG\Definition(required={"PassportId"})
 */
class InvitedRegister  extends BaseModel
{ 
	 
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $InvitedId;
	
	/**
	 * @SWG\Property(type="integer", description="公司ID，个人不传")
	 */
	public $CompanyId;
	
	/**
	 * @SWG\Property(type="integer", description="用户ID")
	 */
	public $PassportId;
		
	/**
	 * @SWG\Property(type="string", description="邀请码")
	 */
	public $InviterCode;
	
	
	/**
	 * @SWG\Property(type="string", description="邀请二维码图片地址")
	 */
	public $InviteRegisterQrcode;

	/**
	 * @SWG\Property(type="string", description="邀请企业奖金")
	 */
	public $InvitePremium;
	
	/**
	 * @SWG\Property(type="string", description="邀请链接URL")
	 */
	public $InviteRegisterUrl;
	 
	
	/**
	 * @SWG\Property(type="string", description="过期时间")
	 */
	public $ExpirationTime;
	 
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
			'ExpirationTime'  => 'datetime',
	];
	
}