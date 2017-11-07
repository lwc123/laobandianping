<?php

namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="PrivatenessViewCommentRecord",
 *   description="个人查看档案记录"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId"})
 */
class  PrivatenessViewCommentRecord extends BaseModel {
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $RecordId;
	 
	/**
	 * @SWG\Property(type="integer", description="用户ID")
	 */
	public $PassportId;
  
	/**
	 * @SWG\Property(type="integer", description="档案ID")
	 */
	public $ArchiveId;
	
	/**
	 * @SWG\Property(type="string", description="首次查看日期")
	 */
	public $ViewBeginTime;
	
	/**
	 * @SWG\Property(type="string", description="查看终止日期（7天）")
	 */
	public $ViewEndTime;
	  
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
}