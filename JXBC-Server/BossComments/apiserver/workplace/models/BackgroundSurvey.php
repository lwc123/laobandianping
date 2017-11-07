<?php

namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="BackgroundSurvey",
 * description="背景调查"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId"})
 */
class BackgroundSurvey extends BaseModel {
 
	/**
	 * @SWG\Property(type="string", description="身份证号")
	 */
	public $IDCard;
	
	/**
	 * @SWG\Property(type="string", description="真实姓名")
	 */
	public $RealName;
	
	/**
	 * @SWG\Property(type="string", description="性别")
	 */
	public $Gender;
	
	/**
	 * @SWG\Property(type="string", description="毕业学校")
	 */
	public $GraduateSchool;
	
	/**
	 * @SWG\Property(type="string", description="学历")
	 */
	public $Education;
	
	/**
	 * @SWG\Property(type="string", description="出生年月")
	 */
	public $Birthday;
	
	/**
	 * @SWG\Property(type="string", description="头像")
	 */
	public $Picture;
	
	/**
	 * @SWG\Property(type="string", description="担任职位")
	 */
	public $PostTitle;
	
	/**
	 * @SWG\Property(type="string", description="任职过的公司")
	 */
	public $CompanyNames;
	
	/**
	 * @SWG\Property(type="boolean", description="是否有档案")
	 */
	public $IsArchive;
	
	/**
	 * @SWG\Property(type="boolean", description="是否离职")
	 */
	public $IsDimission;
	
	/**
	 * @SWG\Property(ref="#/definitions/BackgroundSurveyItem")
	 */
	public $InquiryResultList;
}