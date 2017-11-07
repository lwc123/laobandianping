<?php

namespace app\appbase\models;

/**
 * @SWG\Definition(required={"PassportId","Token"})
 */
class AccountEntity
{   
    /**
     * @SWG\Property(type="long")
     */
    public $PassportId;

    /**
     * @SWG\Property(ref="#/definitions/AccountToken")
     */
    public $Token;
    
    /**
     * @SWG\Property(type="int", description="已拥有的的身份，参见枚举[ProfileType]")
     */
    public $MultipleProfiles;       
}

/**
 * @SWG\Definition(required={"PassportId","AccessToken"})
 */
class AccountToken
{   
    /**
     * @SWG\Property(type="long")
     */
    public $PassportId;    
    
    /**
     * @SWG\Property()
     * @var string
     */
    public $AccessToken;    
}