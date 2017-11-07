<?php
namespace app\workplace\models;
use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 * name="NoticeArgs",
 * description="",
 * )
 */
/**
 * @SWG\Definition(required={"PassportId","FromPassportId"})
 */
class NoticeArgs
{    
    protected $readonly = ['FromContacts','ToContactsList','EventModel'];
	
	/**
	 * @SWG\Property(description="接收人列表，接收人类型参考[NoticeContacts]", type="string")
	 */
	public $ToContactsList;
	
	/**
	 * @SWG\Property(description="发送人", ref="#/definitions/NoticeContacts")
	 */
	public $FromContacts;

	/**
	 * @SWG\Property(type="integer", description="业务ID")
	 */
	public $BizType;
	
	/**
	 * @SWG\Property(type="integer", description="业务ID")
	 */
	public $BizId;	
	
	/**
	 * @SWG\Property(type="string", description="图片url")
	 */
	public $Picture;
    
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $EventModel; 
}