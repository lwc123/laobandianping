<?php

namespace app\common\models;

/**
 * @SWG\Definition(required={"Success"})
 */
class Result { 
	public static function success($bizId=NULL,$jsonModel = NULL) {
		$result = new Result;
		$result->Success = true;
		$result->BizId = $bizId;
	    $result->JsonModel =json_encode($jsonModel); 
		return $result;
	}
	public static function error($errorCode, $errorMessage) {
		$result = new Result;
		$result->Success = false;
		$result->ErrorCode = $errorCode;
		$result->ErrorMessage = $errorMessage;
		return $result;
	} 
 
	
	/**
	 * @SWG\Property(description="是否请求成功", type="boolean")
	 */
	public $Success;
	
	/**
	 * @SWG\Property()
	 * 
	 * @var string
	 */
	public $BizId;
	
	/**
	 * @SWG\Property()
	 *
	 * @var string
	 */
	public $JsonModel;
	
	/**
	 * @SWG\Property()
	 * 
	 * @var string
	 */
	public $ErrorCode;
	
	/**
	 * @SWG\Property()
	 * 
	 * @var string
	 */
	public $ErrorMessage;
}
