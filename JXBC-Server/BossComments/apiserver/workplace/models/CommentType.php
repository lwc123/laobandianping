<?php
namespace app\workplace\models;

/**
 * @SWG\Definition()
 */
class CommentType
{
	/**
	 * @SWG\Property(type="int",description="阶段评价 <b>[ 0 ]</b>")
	 */
	public $StageEvaluation	;
	const StageEvaluation = 0;
	/**
	 * @SWG\Property(type="int",description="离职报告 <b>[ 1 ]</b>")
	 */
	public $DepartureReport;
	const DepartureReport = 1;
 
}