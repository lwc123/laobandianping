<?php

namespace Appbase;

class AccountExtensionContainer
{
    /**
     * @SWG\Get(
     *     path="/AccountExtension/SignStatus",
     *     summary="注册(或登录)的结果状态",
     *     tags={"const"},
     *     @SWG\Response(
     *         response=200,
     *         description="结果状态",
     *         @SWG\Schema(ref="#/definitions/SignStatus")
     *     )
     * )
     */
    public function SignStatus()
    {
    }
    
    /**
     * @SWG\Get(
     *     path="/AccountExtension/ProfileType",
     *     summary="用户身份类型",
     *     tags={"const"},
     *     description="注册时选择一种身份，开通另外一种身份时可以叠加身份（1|2=3）",
     *     @SWG\Response(
     *         response=200,
     *         description="用户身份类型",     
     *         @SWG\Schema(ref="#/definitions/ProfileType")
     *     )
     * )
     */
    public function ProfileType()
    {
    }    
}

/**
 * @SWG\Definition()
 */
class ProfileType
{  
    /**
     * @SWG\Property(type="int",description="个人用户 <b>[ 1 ]</b>")
     */
    public $UserProfile;    
    /**
     * @SWG\Property(type="int",description="机构(企业)用户 <b>[ 2 ]</b>")
     */
    public $OrganizationProfile;
}     

/**
 * @SWG\Definition()
 */
class SignStatus
{  
    /**
     * @SWG\Property(type="int",description="默认值 <b>[ 0 ]</b>")
     */
    public $None;    
    /**
     * @SWG\Property(type="int",description="注册(或登录)成功 <b>[ 1 ]</b>")
     */
    public $Success;
    /**
     * @SWG\Property(type="int",description="验证码错误 <b>[ 2 ]</b>")
     */
    public $InvalidValidationCode;
    /**
     * @SWG\Property(type="int",description="注册失败 <b>[ 9 ]</b>")
     */
    public $Failed;      
    /**
     * @SWG\Property(type="int",description="服务器端错误，注册失败 <b>[ 99 ]</b>")
     */
    public $Error;    
    /**
     * @SWG\Property(type="int",description="邮箱格式错误 <b>[ 101 ]</b>")
     */
    public $InvalidEmail;
    /**
     * @SWG\Property(type="int",description=" 手机号格式错误<b>[ 102 ]</b>")
     */
    public $InvalidMobilePhone;
    /**
     * @SWG\Property(type="int",description="用户名不符合要求 <b>[ 103 ]</b>")
     */
    public $InvalidUserName;  
    /**
     * @SWG\Property(type="int",description="密码不符合要求 <b>[ 109 ]</b>")
     */
    public $InvalidPassword;    
    /**
     * @SWG\Property(type="int",description="邮箱重复，已经注册 <b>[ 201 ]</b>")
     */
    public $DuplicateEmail;     
    /**
     * @SWG\Property(type="int",description="手机号重复，已经注册 <b>[ 202 ]</b>")
     */
    public $DuplicateMobilePhone;
    /**
     * @SWG\Property(type="int",description="用户名重复，已经注册 <b>[ 203 ]</b>")
     */
    public $DuplicateUserName;   
    /**
     * @SWG\Property(type="int",description="服务器已禁用该用户 <b>[ 999 ]</b>")
     */
    public $UserRejected;     
}