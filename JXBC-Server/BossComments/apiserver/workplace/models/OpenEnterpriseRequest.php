<?php

namespace app\workplace\models;
use app\common\BaseModel; 

/**
 * @SWG\Definition(required={"CompanyName","RealName","JobTitle"})
 */
class OpenEnterpriseRequest extends BaseModel
{  
    /**
     * @SWG\Property(type="string")
     */
    public $CompanyName;    
    /**
     * @SWG\Property(type="string")
     */
    public $RealName; 
    /**
     * @SWG\Property(type="string")
     */
    public $JobTitle; 
    
    /**
     * @SWG\Property(type="string")
     */
    public $InviteCode;

    /**
     * @SWG\Property(type="integer")
     */
    public $OpinionCompanyId;
}