<?php
namespace app\workplace\models;
/**
 * @SWG\Definition(required={"ArchiveCount"})
 */
class PrivatenessArchiveSummary{
  
	/**
	 * @SWG\Property(type="integer", description="档案个数")
	 */
	public $ArchiveNum;
	
	/**
	 * @SWG\Property(type="integer", description="阶段评价个数")
	 */
	public $StageEvaluationNum;
	
	/**
	 * @SWG\Property(type="integer", description="离职报告个数")
	 */
	public $DepartureReportNum;
	
}