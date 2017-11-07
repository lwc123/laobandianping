<?php

namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="PrivatenessServiceContract",
 *   description="个人服务合同相关API"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId"})
 */
class  PrivatenessServiceContract extends BaseModel {
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $ContractId;
	 
	/**
	 * @SWG\Property(type="integer", description="用户ID")
	 */
	public $PassportId;
 
	/**
	 * @SWG\Property(type="string", description="真实姓名")
	 */
	public $RealName;
  
	/**
	 * @SWG\Property(type="string", description="身份证号")
	 */
	public $IDCard;
	
	/**
	 * @SWG\Property(type="string", description="合同状态，1未生效，2生效，3过期")
	 */
	public $ContractStatus;
	
	/**
	 * @SWG\Property(type="string", description="签约日期")
	 */
	public $ServiceBeginTime;
	
	/**
	 * @SWG\Property(type="string", description="终止日期")
	 */
	public $ServiceEndTime;
	
	/**
	 * @SWG\Property(type="integer", description="支付费用")
	 */
	public $TotalFee;
	
	/**
	 * @SWG\Property(type="string", description="支付渠道")
	 */
	public $PaidWay;
	
	/**
	 * @SWG\Property(type="string", description="合同号")
	 */
	public $TradeCode;
	
	/**
	 * @SWG\Property(type="string", description="附加信息")
	 */
	public $AdditionalInfo;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;

    public function getTotalFeeAttr($value)
    {
        return parent::getMoneyWithDBUnit($value);
    }

    public function setTotalFeeAttr($value)
    {
        return parent::setMoneyWithDBUnit($value);
    }
}