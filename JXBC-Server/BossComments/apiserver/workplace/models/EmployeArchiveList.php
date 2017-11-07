<?php

namespace app\workplace\models;
use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 * name="EmployeArchiveList",
 * description="企业员工档案列表API"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId"})
 */
class EmployeArchiveList extends BaseModel {
 
	
	/**
	 * @SWG\Property(ref="#/definitions/Department")
	 */
	public $Departments;
	
	/**
	 * @SWG\Property(ref="#/definitions/EmployeArchive")
	 */
	public $EmployeArchives;
	
	

}
