<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
use app\workplace\models\NoticeArgs;
/**
 * @SWG\Tag(
 * name="Message",
 * description="",
 * )
 */
/**
 * @SWG\Definition(required={"MessageId"})
 */
class MessageSms extends BaseModel
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
	 * @SWG\Property(type="integer", description="发送人id")
	 */
	public $FromPassportId;    
	
	/**
	 * @SWG\Property(type="string", description="消息标题")
	 */
	public $Subject;

    /**
     * @SWG\Property(type="string", description="手机号")
     */
    public $MobilePhone;
		
	/**
	 * @SWG\Property(type="string", description="消息内容")
	 */
	public $Content;
	
	/**
	 * @SWG\Property(type="integer", description="是否已读，默认1未读，0已读")
	 */
	public $IsRead;
	
	/**
	 * @SWG\Property(type="string", description="发送时间")
	 */
	public $SendTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="发送方式（短信/站内消息/推送通知）")
	 */

    public $SendType;



    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime',
        'SendTime'      => 'datetime',
        'ReadTime'      => 'datetime',
    ];


    public function __construct($data = []){

        parent::__construct($data);
    }

    public function addAddMsg($msg_data){

        return $this->data($msg_data,true)->isUpdate(false)->save();

    }

}