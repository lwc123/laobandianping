<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
use think\Db;


/**
 * @SWG\Tag(
 * name="MessageTemplete",
 * description="消息模版",
 * )
 */
/**
 * @SWG\Definition(required={"TempleteId"})
 */
class MessageTemplete extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="模版id")
     */
    public $TempleteId;

    /**
     * @SWG\Property(type="string", description="('push','msg','sms')短信/站内消息/推送通知")
     */
    public $SendType;


    /**
     * @SWG\Property(type="integer", description="模版内容")
     */
    public $Content;


    /**
     * @SWG\Property(type="string", description="业务事件源")
     */
    public $BizEvent;


    /**
     * @SWG\Property(type="integer", description="创建时间")
     */
    public $CreatedTime;



}