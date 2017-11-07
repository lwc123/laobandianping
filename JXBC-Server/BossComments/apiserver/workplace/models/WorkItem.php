<?php

namespace app\workplace\models;
use app\common\models\BaseModel; 
use app\common\modules\DbHelper;

/**
 * @SWG\Tag(
 * name="WorkItem",
 * description="企业员工档案职务信息API"
 * )
 */
/**
 * @SWG\Definition(required={"ArchiveId"})
 */
class WorkItem extends BaseModel {
		
	/**
	 * @SWG\Property(type="integer", description="档案ID")
	 */
	public $ArchiveId;
	
	/**
	 * @SWG\Property(type="string", description="部门名称")
	 */
	public $Department;
	/**
	 * @SWG\Property(type="string", description="担任职务")
	 */
	public $PostTitle;
	
	/**
	 * @SWG\Property(type="string", description="薪水")
	 */
	public $Salary;
	
	/**
	 * @SWG\Property(type="string", description="任职开始时间")
	 */
	public $PostStartTime;
	
	/**
	 * @SWG\Property(type="string", description="任职结束日期")
	 */
	public $PostEndTime;
	
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
			'PostStartTime'  => 'datetime',
			'PostEndTime'  => 'datetime' 
	];
	
	/**
	 * 关联档案
	 */
	//所属部门关联
	public function Department()
	{
		return $this->belongsTo('Department','DeptId');
	}
}
