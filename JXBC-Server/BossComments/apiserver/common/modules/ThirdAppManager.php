<?php
/**
 * Created by PhpStorm.
 * User: Kevin
 * Date: 2017/1/7
 * Time: 20:21
 */

namespace app\common\modules;
use app\common\models\ThirdApplication;

class ThirdAppManager
{
    const Param_Sign = "sign";
    const Param_AppId = "appid";
    const Param_Nonce = "nonce";
    private static $ThirdAppStore = [];

    public static function GenerateSign(array $params){
        if(!array_key_exists(ThirdAppManager::Param_Nonce, $params) || empty($params[ThirdAppManager::Param_Nonce]))
            exception('非法请求-nonce', 412);
        if(!array_key_exists(ThirdAppManager::Param_AppId, $params) || empty($params[ThirdAppManager::Param_AppId]))
            exception('非法请求-appId', 412);
        $thirdApplication = ThirdAppManager::FindThirdApplication($params[ThirdAppManager::Param_AppId]); 
        
        //签名步骤一：按字典序排序参数
        ksort($params);  
        $query = ThirdAppManager::ToUrlSignParams($params); 
        //签名步骤二：在string后加入KEY
        $query = $query . "&key=".$thirdApplication['AppSecret']; 
        //签名步骤三：MD5加密
        $query = md5($query); 
        //签名步骤四：所有字符转为大写
        $result = strtoupper($query);  
       // dump($result);die;
        return $result;
    }

    public static function VerifySign(array $params){
        if(!array_key_exists(ThirdAppManager::Param_Sign, $params) || empty($params[ThirdAppManager::Param_Sign]))
            exception('非法请求-sign', 412);
        if(!array_key_exists(ThirdAppManager::Param_Nonce, $params) || empty($params[ThirdAppManager::Param_Nonce]))
            exception('非法请求-nonce', 412);
        if(!array_key_exists(ThirdAppManager::Param_AppId, $params) || empty($params[ThirdAppManager::Param_AppId]))
            exception('非法请求-appId', 412);

        $originalSign = $params[ThirdAppManager::Param_Sign];
        $sign = ThirdAppManager::GenerateSign($params);
        return $originalSign==$sign;
    }

    private static function ToUrlSignParams(array $params)
    {
        $query = "";
        foreach ($params as $key => $value) {
            if($key != ThirdAppManager::Param_Sign && !empty($value) && !is_array($value)){
                $query .= $key . "=" . $value . "&";
            }
        }
        $query = trim($query, "&");
        return $query;
    }

    private static function FindThirdApplication($appId) {
        if(empty($ThirdAppStore) || count($ThirdAppStore) == 0) {
            $apps = ThirdApplication::all();
            foreach ($apps as $item) {
                $ThirdAppStore[$item["AppId"]] = $item;
            }
        }

        if(!array_key_exists($appId, $ThirdAppStore))
            exception('非法请求-ThirdApplication', 412);

        return $ThirdAppStore[$appId];
    }
     
}