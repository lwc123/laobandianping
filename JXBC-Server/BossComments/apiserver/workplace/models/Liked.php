<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
use think\Db;


/**
 * @SWG\Tag(
 *   name="Liked",
 *   description="点赞",
 *   @SWG\ExternalDocumentation(
 *     description="Find out more",
 *     url="http : //swagger.io"
 *   )
 * )
 */
/**
 * @SWG\Definition(required={"LikedId"})
 */
class Liked extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="点赞者")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="integer", description="被赞对象的id，1老板圈")
     */
    public $ResId;

    /**
     * @SWG\Property(type="string", description="点赞时间")
     */
    public $CreatedTime;


}
