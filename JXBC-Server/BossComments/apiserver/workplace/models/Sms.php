<?php
namespace app\workplace\models;
use app\appbase\models\TradeJournal;
use app\common\models\BaseModel;
use think\Db;
use app\appbase\models\TradeMode;


/**
 * @SWG\Tag(
 *   name="Sms",
 *   description="短信服务",
 *   @SWG\ExternalDocumentation(
 *     description="Find out more",
 *     url="http : //swagger.io"
 *   )
 * )
 */
/**
 * @SWG\Definition(required={"SmsId"})
 */
class Sms extends BaseModel
{

    /**
     * @SWG\Property(type="string", description="短信内容")
     */
    public $Content;

    /**
     * @SWG\Property(type="string", description="接受者手机号")
     */
    public $ToMobile;

    /**
     * @SWG\Property(type="string", description="发送时间")
     */
    public $SendTime;

    /**
     * @SWG\Property(type="integer", description="接受者id")
     */
    public $ToPassportId;

    /**
     * @SWG\Property(type="integer", description="发送者id")
     */
    public $FromPassportId;

    public $sms_model;


}