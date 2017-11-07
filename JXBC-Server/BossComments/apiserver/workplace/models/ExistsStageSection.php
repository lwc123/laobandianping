<?php
namespace app\workplace\models; 
/**
 * @SWG\Tag(
 * name="ExistsStageSection",
 * description="查看此档案已添加的年份区间评价"
 * )
 */
/**
 * @SWG\Definition(required={"StageYear"})
 */
class ExistsStageSection   {
	/**
	 * @SWG\Property(type="string", description="评价年份")
	 */
	public $StageYear;
	
	/**
	 * @SWG\Property(type="string", description="年份区间")
	 */
	public $StageSection;
}