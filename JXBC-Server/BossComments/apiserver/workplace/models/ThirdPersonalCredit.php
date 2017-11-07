<?php

namespace app\workplace\models;
use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 *   name="ThirdPersonalCredit",
 *   description="第三方信用值"
 * )
 */
/**
 * @SWG\Definition(required={"IDCard"})
 */
class  ThirdPersonalCredit extends BaseModel {
    const Status_Querying =  1;
    const Status_Completed =  2;
    const Status_Failed =  9;
    const Status_Empty =  10;

    public static function findExistsCredits($idCard) {
        return ThirdPersonalCredit::where("IDCard",$idCard)->where("Status",self::Status_Completed)->select();
    }

    public static function findQueryingCredits($idCard,$realName,$mobilePhone) {
        return ThirdPersonalCredit::where("IDCard", $idCard)->where("RealName", $realName)->where("MobilePhone", $mobilePhone)->where("Status", self::Status_Querying)->select();
    }

        /**
     * @SWG\Property(type="integer", description="")
     */
    public $CreditId;

	/**
	 * @SWG\Property(type="string", description="身份证")
	 */
	public $IDCard;

    /**
     * @SWG\Property(type="string", description="真实姓名")
     */
	public $RealName;

    /**
     * @SWG\Property(type="string", description="手机号")
     */
	public $MobilePhone;

    /**
     * @SWG\Property(type="string", description="信用产品Code")
     */
    public $ProductCode;
	
	/**
	 * @SWG\Property(type="integer", description="[1]查询中， [2]查询完成， [9]查询失败， [10]查询成功，无返回值")
	 */
	public $Status;

    /**
     * @SWG\Property(type="string", description="第三方平台Code")
     */
    public $ThirdProvider;

    /**
     * @SWG\Property(type="string", description="第三方信用产品报告Code")
     */
    public $ThirdCreditCode;
	
	/**
	 * @SWG\Property(type="integer", description="第三方信用产品分数")
	 */
	public $ThirdCreditScore;

    /**
     * @SWG\Property(type="string", description="第三方信用产品查询结果")
     */
    public $ThirdCreditDetail;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
}