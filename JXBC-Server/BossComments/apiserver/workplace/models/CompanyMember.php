<?php

namespace app\workplace\models;
 
use think\Cache;
use think\Db;
use think\Model;
use app\common\models\BaseModel;
/**
 * @SWG\Tag(
 *   name="CompanyMember",
 *   description="企业成员相关API，包括角色列表，增删改授权人等"
 * )
 */
/**
 * @SWG\Definition(required={"RealName","JobTitle"})
 */
class  CompanyMember extends BaseModel {
	const CacheName ="CompanyMember";
    const CacheExpire = 24 * 60 * 60;
	/**
	 * @SWG\Property(type="integer", description="成员ID")
	 */
	public $MemberId;
	
	/**
	 * @SWG\Property(type="integer", description="公司ID")
	 */
	public $CompanyId;
	
	/**
	 * @SWG\Property(type="integer", description="用户ID")
	 */
	public $PassportId;
		
	/**
	 * @SWG\Property(type="integer", description="操作人ID")
	 */
	public $PresenterId;
	
	/**
	 * @SWG\Property(type="integer", description="修改人ID")
	 */
	public $ModifiedId;
	
	/**
	 * @SWG\Property(type="string", description="成员手机号")
	 */
	public $MobilePhone;
	
	/**
	 * @SWG\Property(type="string", description="成员姓名")
	 */
	public $RealName;
	
	/**
	 * @SWG\Property(type="string", description="成员职务")
	 */
	public $JobTitle;
	
	/**
	 * @SWG\Property(type="integer", description="成员角色")
	 */
	public $Role;
	 
	/**
	 * @SWG\Property(type="string", description="添加时间")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="修改时间")
	 */
	public $ModifiedTime;
	
	 
	
	// 定义一对一关联
	public function myCompany()
	{
		return $this->belongsTo('Company','CompanyId')->field('CompanyName');
	}
	
	// 定义一对一关联
	public function myMessage()
	{
		return $this->belongsTo('Message','PassportId')->field('MessageId');
	}


    /**获取企业老板角色信息
     * @param $companyId
     * @return array|false|mixed|\PDOStatement|string|Model
     */
    public static function getBossRoleByCompanyId($companyId){
        $boss_key = CompanyMember::CacheName .'-'. $companyId .'-Boss';
        $BossRole = Cache::get($boss_key);
        if (empty($BossRole)) {
            $BossRole = CompanyMember::where(['CompanyId' => $companyId, "Role" => MemberRole::Boss])->find();
            if ($BossRole) {
                Cache::set($boss_key, $BossRole, CompanyMember::CacheExpire);
            }
        }
        return $BossRole;
    }

    /**获取用户角色信息
     * @param $companyId
     * @param $passportId
     */

	public static function getPassportRoleByCompanyId($companyId,$passportId){
            $role_key = CompanyMember::CacheName .'-'. $companyId .'-'. $passportId;
            $PassportRole = Cache::get($role_key);
            if (empty($PassportRole)) {
                $PassportRole = CompanyMember::where(['CompanyId' => $companyId, "PassportId" => $passportId])->find();
                if ($PassportRole) {
                    Cache::set($role_key, $PassportRole, CompanyMember::CacheExpire);
                }
            }
            return $PassportRole;
    }

    public function save($data = [], $where = [], $sequence = null)
    {
        $result = parent::save($data, $where, $sequence);
        $role_key = CompanyMember::CacheName .'-'. $this["CompanyId"] .'-'. $this["PassportId"];
        if(!empty($this)){
            Cache::set($role_key, $this, CompanyMember::CacheExpire);
        }
        //缓存老板信息
        if($this["Role"]==MemberRole::Boss){
            $boss_key = CompanyMember::CacheName .'-'. $this["CompanyId"] .'-Boss';
            Cache::set($boss_key, $this, CompanyMember::CacheExpire);
        }
        return $result;
    }


}
