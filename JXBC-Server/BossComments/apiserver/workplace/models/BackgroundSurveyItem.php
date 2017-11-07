<?php

namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="BackgroundSurveyItem",
 * description="背景调查子项"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId"})
 */
class BackgroundSurveyItem extends BaseModel {
 
	/**
	 * @SWG\Property(type="string", description="企业名称")
	 */
	public $CompanyName;
	
	/**
	 * @SWG\Property(type="integer", description="企业ID")
	 */
	public $CompanyId;
 
	
	/**
	 * @SWG\Property(type="integer", description="阶段评价条数")
	 */
	public $StageEvaluationNum;
	
	/**
	 * @SWG\Property(type="integer", description="离职报告条数")
	 */
	public $DepartureReportNum;
	
	/**
	 * @SWG\Property(type="integer", description="是否购买过阶段评价")
	 */
	public $IsBoughtStageEvaluation;
	
	/**
	 * @SWG\Property(type="integer", description="是否购买过离职报告")
	 */
	public $IsBoughtDepartureReport;
	
	/**
	 * @SWG\Property(type="integer", description="阶段评价价格")
	 */
	public $StageEvaluationPrice;
	
	/**
	 * @SWG\Property(type="integer", description="离职报告价格")
	 */
	public $DepartureReportPrice;

	/**
	 * @SWG\Property(type="string", description="入职时间")
	 */
	public $EntryTime;
 
	/**
	 * @SWG\Property(type="string", description="离职时间")
	 */
	public $DimissionTime;
	
	/**
	 * @SWG\Property(type="string", description="担任职位")
	 */
	public $PostTitle;
	
	
	
}
