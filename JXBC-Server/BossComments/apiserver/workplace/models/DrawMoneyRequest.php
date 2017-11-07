<?php

namespace app\workplace\models;
use app\common\models\BaseModel;
use think\Config;
use think\db\Query;
use app\workplace\models\Company;
/**
 * @SWG\Tag(
 *   name="DrawMoneyRequest",
 *   description="公司提现API"
 * )
 */
 
/**
 * @SWG\Definition(required={"BankCard","BankName","MoneyNumber","CompanyId"})
 */
class  DrawMoneyRequest extends BaseModel {
 
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $ApplyId;
	 
	/**
	 * @SWG\Property(type="integer", description="公司ID,个人传空")
	 */
	public $CompanyId; 
	
	/**
	 * @SWG\Property(type="string", description="公司名称，个人填写姓名")
	 */
	public $CompanyName; 
	
	/**
	 * @SWG\Property(type="integer", description="提交人ID")
	 */
	public $PresenterId;
	 
	/**
	 * @SWG\Property(type="string", description="银行账号")
	 */
	public $BankCard;
 
	/**
	 * @SWG\Property(type="string", description="开户银行")
	 */
	public $BankName;
	
	/**
	 * @SWG\Property(type="number", description="提现金额")
	 */
	public $MoneyNumber;
	
	/**
	 * @SWG\Property(type="integer", description="提现状态，参考枚举DrawMoneyAuditStatus")
	 */
	public $AuditStatus;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;


	public function getMoneyNumberAttr($value)
	{
		return parent::getMoneyWithDBUnit($value);
	}
	
	public function setMoneyNumberAttr($value)
	{
		return parent::setMoneyWithDBUnit($value);
	}



}
