<?php
namespace app\workplace\models;
use app\common\models\BaseModel;

use think\Db;


/**
 * @SWG\Tag(
 * name="BossDynamic",
 * description="老板圈动态",
 * )
 */
/**
 * @SWG\Definition(required={"DynamicId","Img","Content"})
 */

class BossDynamicSummary extends BossDynamic
{
    /**
     * @SWG\Property(ref="#/definitions/Company")
     */
    public $Company;

    /**
     * @SWG\Property(type="string", description="评论内容列表")
     */
    public $Comments;

    /**
     * @SWG\Property(type="boolean", description="是否点赞")
     */
    public $IsOpt;

}
