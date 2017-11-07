<?php

namespace app\workplace\services;
 
use app\common\modules\DbHelper;
use app\thirdapis\providers\SinowayApiProvider;
use app\workplace\models\ThirdPersonalCredit;
use think\Cache;
use think\Log;
use app\common\models\Result;
use app\common\models\ErrorCode;
use app\common\modules\ResourceHelper;

class ThirdPersonalCreditService {
    const CacheExpire = 24 * 60 * 60 * 100;

	/**
	 * 查找填写身份证号在此公司是否存在
	 *
	 * @access public
	 * @param array $fundidcard        	
	 * @return boolean
	 */
	public static function querySinowayCredit(array $query) {
		if (empty ( $query ) || empty($query ["IDCard"]) || empty($query ["RealName"]) || empty($query ["MobilePhone"])) {
			exception ( '非法请求-0', 412 );
		}
        $credits = ThirdPersonalCredit::findExistsCredits($query ["IDCard"]);
        $result = [];
        $nowTimestamp = strtotime('now');
        foreach (SinowayApiProvider::Products as $product){
            $sendQueryRequest = true;
            foreach ($credits as $credit){
                if($credit["ProductCode"] == $product
                    && ($nowTimestamp-strtotime(DbHelper::toLocalDateTime($credit["ModifiedTime"]))) < self::CacheExpire)
                {
                    $sendQueryRequest = false;
                    $result[] = $credit;
                    break;
                }
            }

            if($sendQueryRequest) {
                $result[] = self::querySinowayCreditWithProduct($query, $product);
            }
        }
        return $result;
	}

    private static function querySinowayCreditWithProduct(array $query, $product){
        $query ["Product"] = $product;
        $queryData = SinowayApiProvider::sendQueryRequest($query);
        $creditCode = null;

        if(!empty($queryData) && strstr($queryData, "status")) {
            $queryInfo = json_decode($queryData);
            if($queryInfo->status == "1") {
                $creditCode = $queryInfo->fnttrnjrn;
            } else {
                $error = sprintf("querySinowayCredit：[%s] <= [%s]",$queryData, json_encode($query));
                Log::error($error);
                return  $error;
            }
        }
        $credit = ThirdPersonalCredit::create(array(
            "IDCard" => $query ["IDCard"],
            "RealName" => $query ["RealName"],
            "MobilePhone" => $query ["MobilePhone"],
            "ProductCode" => $query ["Product"],
            "Status" => ThirdPersonalCredit::Status_Querying,
            "ThirdProvider" => "Sinoway",
            "ThirdCreditCode" =>$creditCode
        ));

        return $credit;
    }

    public static function updateSinowayCredit($product, $queryData){
        $queryJson = SinowayApiProvider::parseQueryResult($product, $queryData);
        $queryResult = json_decode($queryJson,true);

        $querySucess = false;
        if(is_array($queryResult) && array_key_exists("reqPams",$queryResult) && array_key_exists("body",$queryResult) && array_key_exists("header",$queryResult)){
            $credits = ThirdPersonalCredit::findQueryingCredits($queryResult["reqPams"] ["idcard"],$queryResult["reqPams"] ["prsnnam"],$queryResult["reqPams"] ["mobile"]);
            foreach ($credits as $credit){
                if($credit["ProductCode"] == $product) {
                    if(is_array($queryResult["reqPams"])&&is_array($queryResult["body"])&&is_array($queryResult["header"])){
                        $credit["ThirdCreditCode"] = $queryResult["header"] ["fnttrnjrn"];
                        if(empty($queryResult["header"] ["status"])) {
                            $credit["Status"] = ThirdPersonalCredit::Status_Failed;
                            $credit["ThirdCreditDetail"] = $queryResult["header"] ["result"];
                            $credit["ThirdCreditScore"] = 0;
                        } else {
                            $credit["Status"] = ThirdPersonalCredit::Status_Completed;
                            $credit["ThirdCreditDetail"] = json_encode($queryResult["body"]);
                            $credit["ThirdCreditScore"] = 0;
                            foreach ($queryResult["body"] as $item) {
                                $credit["ThirdCreditScore"] = $item["modelScore"]["score"];
                            }
                            //返回最小值435， 通常是没有查询结果
                            if($credit["ThirdCreditScore"] <= 435) {
                                $credit["Status"] = ThirdPersonalCredit::Status_Empty;
                            }
                        }
                        $credit->save();
                        $querySucess = true;
                    }
                }
            }
        }
        return $querySucess;
    }
}
