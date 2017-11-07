<?php
namespace app\workplace\models;

use app\common\models\BaseModel;

use app\common\modules\DbHelper;
use think\Cache;
use think\Db;


/**
 * @SWG\Tag(
 *   name="BossDynamicComment",
 *   description="动态评论",
 *   @SWG\ExternalDocumentation(
 *     description="Find out more",
 *     url="http : //swagger.io"
 *   )
 * )
 */

/**
 * @SWG\Definition(required={"CompanyId","DynamicId","Content"})
 */
class BossDynamicComment extends BaseModel
{
    const CacheName = "BossDynamicComment";
    const CacheExpire = 24 * 60 * 60;
    /**
     * @SWG\Property(type="integer", description="评论id")
     */
    public $CommentsId;

    /**
     * @SWG\Property(type="integer", description="动弹id")
     */
    public $DynamicId;

    /**
     * @SWG\Property(type="integer", description="公司id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="发表评论的用户id")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string", description="评论时间")
     */
    public $CreatedTime;


    /**
     * @SWG\Property(type="integer", description="发表评论的公司简称")
     */
    public $CompanyAbbr;

    /**
     * @SWG\Property(type="string", description="评论内容字符串")
     */
    public $Content;

    protected $type = [
        'CreatedTime' => 'datetime',
        'ModifiedTime' => 'datetime'
    ];

    /**获取老板圈动态评论列表
     * @param $dynamicId
     * @return array
     */
    public static function getDynamicCommentList($dynamicId)
    {
        $comment_key = BossDynamicComment::CacheName . '-' . $dynamicId . '-list';
        $Comments = Cache::get($comment_key);
        if (is_array($Comments)) {
            return $Comments;
        } else {
            $Comments = BossDynamicComment::where(['DynamicId' => $dynamicId])->select();
            if (empty($Comments)) {
                $Comments = [];
            }
            Cache::set($comment_key, $Comments, BossDynamicComment::CacheExpire);
            return $Comments;
        }
    }

    public function addComment($comment_data)
    {
        $comment_key = BossDynamicComment::CacheName . '-' . $comment_data['DynamicId'] . '-list';
        Cache::rm($comment_key);
        return $this->data($comment_data, true)->isUpdate(false)->save();

    }

    public function getCommentByDynamicId($dynamic_id)
    {

        $sql = "SELECT A.CommentsId,A.DynamicId,A.CompanyId,A.Content,A.CreatedTime, A.`Status`,B.CompanyAbbr FROM 
                boss_dynamic_comment A INNER JOIN company B ON A.CompanyId = B.CompanyId 
                WHERE A.`Status`=1 AND A.DynamicId=$dynamic_id ORDER BY A.CommentsId ASC";

        $data = Db::query($sql);

        foreach ($data as $key => &$value) {

            $value['CreatedTime'] = DbHelper::toUtcDateTime($value['CreatedTime']);
        }

        return $data;
    }
}
