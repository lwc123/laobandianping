<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(required={"ArchiveCount"})
 */
class PrivatenessmyArchives extends EmployeArchive{
  
	/**
	 * @SWG\Property(type="string", description="公司名称")
	 */
	public $CompanyName;
	
	/**
	 * @SWG\Property(type="integer", description="阶段评价个数")
	 */
	public $StageEvaluationNum;
	
	/**
	 * @SWG\Property(type="integer", description="离职报告个数")
	 */
	public $DepartureReportNum;
	
}