<?php

namespace app\workplace\models;
use think\Model;

/**
 * @SWG\Definition(required={"CompanyName","RealName","JobTitle"})
 */
class  EnterpriseService extends Model {
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CompanyName;
	
	/**
	 * @SWG\Property(type="string", description="成员姓名")
	 */
	public $RealName;
	
	/**
	 * @SWG\Property(type="string", description="成员职务")
	 */
	public $JobTitle;
	
}