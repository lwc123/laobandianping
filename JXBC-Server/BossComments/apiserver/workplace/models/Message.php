<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
/**
 * @SWG\Tag(
 * name="Message",
 * description="",
 * )
 */
/**
 * @SWG\Definition(required={"BizType,BizId,ToCompanyId"})
 */
class Message extends BaseModel
{
    /**
     * @SWG\Property(type="integer", description="消息id，不需要用传参")
     */
    public $MessageId;

    /**
     * @SWG\Property(type="integer", description="接收人id")
     */
    public $ToPassportId;

    /**
     * @SWG\Property(type="integer", description="接收人公司id")
     */
    public $ToCompanyId;

    /**
     * @SWG\Property(type="integer", description="发送人id")
     */
    public $FromPassportId;

    /**
     * @SWG\Property(type="integer", description="发送人公司id")
     */
    public $FromCompanyId;

    /**
     * @SWG\Property(type="string", description="业务类型BizType=0 不可点消息，BizType=2 离职报告 ，BizType=3阶段评价")
     */
    public $BizType;


    /**
     * @SWG\Property(type="string", description="业务ID（离职报告id或者阶段评价id）")
     */
    public $BizId;

    /**
     * @SWG\Property(type="string", description="消息标题")
     */
    public $Subject;

    /**
     * @SWG\Property(type="string", description="消息图标")
     */
    public $Picture;

    /**
     * @SWG\Property(type="string", description="消息内容")
     */
    public $Content;

    /**
     * @SWG\Property(type="integer", description="是否已读，默认0未读，1已读")
     */
    public $IsRead;

    /**
     * @SWG\Property(type="string", description="已读时间")
     */
    public $ReadTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;

    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime',
        'ReadTime'      => 'datetime',
    ];

}