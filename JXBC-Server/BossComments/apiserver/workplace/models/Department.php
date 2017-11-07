<?php

namespace app\workplace\models;
use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 *   name="Department",
 *   description="企业部门相关API"
 * )
 */
/**
 * @SWG\Definition(required={"DeptName"})
 */
class  Department extends BaseModel {
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $DeptId;
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $CompanyId; 
	
	/**
	 * @SWG\Property(type="integer", description="提交人ID")
	 */
	public $PresenterId;
	
	/**
	 * @SWG\Property(type="string", description="部门名称")
	 */
	public $DeptName;
	
	/**
	 * @SWG\Property(type="integer", description="部门在岗人数")
	 */
	public $StaffNumber;
	
	/**
	 * @SWG\Property(type="integer", description="部门排序")
	 */
	public $DeptSort;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
}