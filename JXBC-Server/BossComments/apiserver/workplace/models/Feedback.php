<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
/**
 * @SWG\Tag(
 *   name="Feedback",
 *   description="反馈建议API"
 * )
 */
/**
 * @SWG\Definition(required={"PassportId","Content"})
 */
class Feedback extends BaseModel{

    /**
     * @SWG\Property(type="integer", description="自增ID")
     */
    public $FeedbackId;

    /**
     * @SWG\Property(type="integer", description="企业ID")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="用户ID")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string", description="反馈内容")
     */
    public $Content;

    /**
     * @SWG\Property(type="string", description="发布时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;

}