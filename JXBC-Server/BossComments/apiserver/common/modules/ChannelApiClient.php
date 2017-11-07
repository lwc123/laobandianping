<?php
/**
 * Created by PhpStorm.
 * User: Oliver
 * Date: 2017/1/9
 * Time: 20:00
 */
namespace app\common\modules;
use think\Log;


Class ChannelApiClient
{
    const AppKey = "n5SeDSfdZeXC";

    public static function SendOpenedEnterprise(array $params)
    {
        $apiUrl = "http://tth.tidyway.cn/code/Interface.ashx?";

        ChannelApiClient::SendSyncGetRequest($apiUrl, $params);
    }

    public static function SendTradeJournal(array $params)
    {
        $apiUrl = "http://tth.tidyway.cn/code/consumption.ashx?";

        ChannelApiClient::SendSyncGetRequest($apiUrl, $params);
    }

    private static function SendSyncGetRequest($apiUrl, array $params) {
        $params["key"] = ChannelApiClient::AppKey;
        $apiUrl = $apiUrl . ChannelApiClient::ToUrlQuery($params);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $apiUrl);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 3);

        if(config("app_test")) {
            $apiResponse = "*** TEST MOCK ***";
        } else {
            $apiResponse = curl_exec($ch);
        }
        curl_close($ch);

        Log::record("SendSyncGetRequest [".json_encode($apiResponse)."] <== ". $apiUrl);

    }

    private static function ToUrlQuery(array $params = null)
    {
        if(empty($params))
            return null;

        $query = "";
        foreach($params as $key=>$value){
            $query .= $key."=".urlencode($value).'&';
        }
        return rtrim($query, '&');
    }
}