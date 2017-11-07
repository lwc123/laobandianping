<?php

namespace app\appbase\models;

/**
 * @SWG\Definition(required={"SignStatus","CreatedNewPassport"})
 */
class AccountSignResult
{   
    /**
     * @SWG\Property(description="注册(或登录)的结果状态，参见枚举[SignStatus]", type="int")
     */
    public $SignStatus;

    /**
     * @SWG\Property(description="是否创建了新账号", type="boolean")
     */    
    public $CreatedNewPassport;
    
    /**
     * @SWG\Property()
     * @var string
     */
    public $ErrorMessage;

    /**
     * @SWG\Property(description="匿名账号信息", ref="#/definitions/AccountEntity")
     */
    public $Account;
    
    /**
     * @SWG\Property(description="注册(或登录)的后继行为", ref="#/definitions/AdditionalAction")
     */
    public $AdditionalAction;    
      
}

/**
 * @SWG\Definition(required={"ActionType","Source"})
 */
class AdditionalAction
{
    /**
     * @SWG\Property()
     * @var string
     */
    public $ActionType;
    
    /**
     * @SWG\Property(description="来源")
     * @var string
     */
    public $Source;    
}