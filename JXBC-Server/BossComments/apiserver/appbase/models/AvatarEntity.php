<?php
namespace app\appbase\models;
use think\Config;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"AvatarStream"})
 */
class AvatarEntity
{
    /**
     * @SWG\Property(type="integer")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string")
     */
    public $AvatarStream;
}