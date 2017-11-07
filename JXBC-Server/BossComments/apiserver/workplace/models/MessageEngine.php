<?php
namespace app\workplace\models;
use app\appbase\models\TradeJournal;
use app\common\models\BaseModel;
use think\Db;
use app\appbase\models\TradeMode;


/**
 * @SWG\Tag(
 * name="MessageEngine",
 * description="消息事件模版",
 * )
 */
/**
 * @SWG\Definition(required={"ActiveId"})
 */
class MessageEngine extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="事件id")
     */
    public $ActiveId;


    /**
     * @SWG\Property(type="integer", description="模版id")
     */
    public $TempleteId;


    /**
     * @SWG\Property(type="integer", description="业务类型")
     */
    public $BizType;


    /**
     * @SWG\Property(type="string", description="业务事件源")
     */
    public $BizEvent;


	/**
     * @SWG\Property(type="integer", description="创建时间")
     */
	public $CreatedTime;



}