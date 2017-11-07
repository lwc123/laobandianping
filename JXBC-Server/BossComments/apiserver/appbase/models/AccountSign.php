<?php

namespace app\appbase\models;

/**
 * @SWG\Definition(required={"MobilePhone","Password"})
 */
class AccountSign
{   
    /**
     * @SWG\Property(type="string")
     */
    public $MobilePhone;

    /**
     * @SWG\Property(type="integer")
     */
    public $Password;
    
    /**
     * @SWG\Property(type="string", description="短信验证码")
     */
    public $ValidationCode;
    
    /**
     * @SWG\Property(type="integer", description="注册时选择的身份")
     */
    public $SelectedProfileType;    
    
    /**
     * @SWG\Property(type="string", description="注册邀请码")
     */
    public $InviteCode;    
}