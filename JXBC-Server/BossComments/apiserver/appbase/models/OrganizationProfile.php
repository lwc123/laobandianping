<?php
namespace app\appbase\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"RealName", "CurrentCompany", "CurrentJobTitle"})
 */
class OrganizationProfile extends UserProfile
{
    /**
     * @SWG\Property(type="integer")
     */
    public $CurrentOrganizationId;
}