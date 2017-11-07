<?php

namespace app\admin\models;


/**
 * @SWG\Tag(
 * name="AdminUser",
 * description="后台用户表"
 * )
 */
/**
 * @SWG\Definition(required={"AdminUserId"})
 */


class AdminUser extends AdminBase{


    /**
     * @SWG\Property(type="integer", description="管理员id")
     */
    public $AdminUserId;

    /**
     * @SWG\Property(type="string", description="管理员姓名")
     */
    public $AdminName;


    /**
     * @SWG\Property(type="string", description="管理员手机号")
     */
    public $MobilePhone;


    /**
     * @SWG\Property(type="string", description="帐号创建时间")
     */
    public $ModifiedTime;


    /**
     * @SWG\Property(type="string", description="帐号创建时间")
     */
    public $CreatedTime;


    /**
     * @SWG\Property(type="string", description="帐号最后登录时间")
     */
    public $LastLoginTime;


    /**
     * @SWG\Property(type="string", description="帐号最后登录ip")
     */
    public $LastLoginIp;


    /**
     * @SWG\Property(type="string", description="密码加盐字符串")
     */
    public $Sign;


    /**
     * @SWG\Property(type="string", description="状态，1激活，0停用")
     */
    public $Status;

    /**
     * @SWG\Property(type="string", description="角色Code")
     */
    public $RoleCode;

}



?>