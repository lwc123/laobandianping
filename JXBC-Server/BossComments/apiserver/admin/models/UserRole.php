<?php

namespace app\admin\models;

/**
 * @SWG\Tag(
 * name="UserRole",
 * description="后台用户角色"
 * )
 */
/**
 * @SWG\Definition(required={"RoleId"})
 */

class UserRole extends AdminBase{


    /**
     * @SWG\Property(type="integer", description="角色id")
     */
    public $RoleId;

    /**
     * @SWG\Property(type="string", description="角色名称")
     */
    public $RoleName;

    /**
     * @SWG\Property(type="string", description="角色code")
     */
    public $RoleCode;

    /**
     * @SWG\Property(type="string", description="角色说明")
     */
    public $Intro;

    /**
     * @SWG\Property(type="string", description="状态，1激活，0停用")
     */
    public $Status;

}

?>