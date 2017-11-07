<?php
/**
 * 华道征信API驱动
 */
namespace app\thirdapis\providers;
use app\common\modules\DES;
use think\Log;

Class SinowayApiProvider
{
    const Product_PFBL =  "PFBL";
    const Product_PFXY =  "PFXY";
    const Products =  array("PFXY","PFBL");

    public static function sendQueryRequest($query) {
        $apiUrl = sprintf("%s/appbase/sinoway/SendQueryRequest?Product=%s&IDCard=%s&RealName=%s&MobilePhone=%s", Config('site_root_api')
            ,$query["Product"],$query["IDCard"],urlencode($query["RealName"]),$query["MobilePhone"]);
        return self::sendApiRequest($apiUrl, true);
    }

    public static function parseQueryResult($productCode,$queryResult) {
        $apiUrl = sprintf("%s/appbase/sinoway/ParseQueryResult?product=%s&result=%s", Config('site_root_api')
            ,$productCode, urlencode($queryResult));
        return self::sendApiRequest($apiUrl);
    }

    private static function sendApiRequest($apiUrl, $async = false) {
        $ch = curl_init();
        //curl_setopt($ch,CURLOPT_PROXY,"127.0.0.1");
        //curl_setopt($ch,CURLOPT_PROXYPORT, "8888");

        curl_setopt($ch, CURLOPT_URL, $apiUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        if(empty($async)) {
            curl_setopt($ch, CURLOPT_TIMEOUT, 12);
        } else {
            curl_setopt($ch, CURLOPT_TIMEOUT, 20);
        }

//        curl_setopt($ch, CURLOPT_POST, 1);
//        curl_setopt($ch, CURLOPT_HTTPHEADER, $postHeader);
//        curl_setopt($ch, CURLOPT_POSTFIELDS, base64_encode($encryptPostData));

        $apiResponse = curl_exec($ch);
        curl_close($ch);

        $message = sprintf("\"SendApiRequest [%s] <== %s", $apiResponse, $apiUrl);
        //echo($message);
        Log::record($message);

        return $apiResponse;
    }
}