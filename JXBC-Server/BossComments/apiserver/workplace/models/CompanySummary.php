<?php

namespace app\workplace\models;

use think\Model;

/**
 * @SWG\Tag(
 * name="Company",
 * description="企业相关API，包括工作台等"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyName"})
 */
class CompanySummary extends Company {
	
	/**
	 * @SWG\Property(type="int", description="离职档案人数")
	 */
	public $DimissionNum;
	
	/**
	 * @SWG\Property(type="int", description="在职档案人数")
	 */
	public $EmployedNum;
	
	/**
	 * @SWG\Property(type="int", description="未读消息个数")
	 */
	public $UnreadMessageNum;
	
	/**
	 * @SWG\Property(type="string", description="企业审核中提示信息")
	 */
	public $PromptInfo;
 
	/**
	 * @SWG\Property(ref="#/definitions/CompanyMember",description="企业老板信息")
	 */
	public $BossInformation;
	
	/**
	 * @SWG\Property(ref="#/definitions/CompanyMember",description="我的身份信息")
	 */
	public $MyInformation;
	
	/**
	 * @SWG\Property(ref="#/definitions/Wallet", description="钱包")
	 */
	public $Wallet;
}
