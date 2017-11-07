<?php
namespace app\workplace\models;

use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 *   name="PaymentBackground",
 *   description="背景调查API，包括已购买列表，搜索等"
 * )
 */
/**
 * @SWG\Definition(required={"ArchiveId"})
 */
class BuyCommentRecord extends BaseModel {
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $RecordId;
	
	
	/**
	 * @SWG\Property(type="integer", description="购买人")
	 */
	public $PassportId;
	
	
	/**
	 * @SWG\Property(type="integer", description="购买评价类型")
	 */
	public $CommentType;
	
	
	/**
	 * @SWG\Property(type="integer", description="档案所属公司")
	 */
	public $ArchiveCompanyId;
	
	/**
	 * @SWG\Property(type="integer", description="档案ID")
	 */
	public $ArchiveId;
	
	/**
	 * @SWG\Property(type="string", description="评价ID")
	 */
	public $CommentId;
	
	/**
	 * @SWG\Property(type="string", description="购买时间")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
	
}


