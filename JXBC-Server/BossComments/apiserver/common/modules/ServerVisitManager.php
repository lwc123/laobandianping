<?php
/**
 * Created by PhpStorm.
 * User: Oliver
 * Date: 2017/1/9
 * Time: 20:00
 */
namespace app\common\modules;


use think\Log;

Class ServerVisitManager
{
    const Param_Url = "url";

    public static function ServerVisitPost($url, $params = NULL, $json = false)
    {
        if(empty($params) || empty($url))
            exception('非法请求-curl', 412);
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);

        if (!empty ($params)) {
            if ($json && is_array($params)) {
                $params = json_encode($params);
            }

            curl_setopt($curl, CURLOPT_POST, 1);
            curl_setopt($curl, CURLOPT_POSTFIELDS, $params);
            if ($json) {
                curl_setopt($curl, CURLOPT_HEADER, 0);
                curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json; charset=utf-8', 'JX-TOKEN: 0000000000000000000000000000000000000000', 'Content-Length: ' . strlen($params)));
            }
        }
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        $res = curl_exec($curl);
        $errorNo = curl_errno($curl);


        if ($errorNo) {
            Log::error("#".$errorNo."# <<===== ".$url);
            return array(
                'error' => false,
                'error_msg' => $errorNo
            );
        }else{
            Log::info("#".json_encode($res)."# <<===== ".$url);
        }
        curl_close($curl);
        return json_decode($res, true);
    }

    public static function ServerVisitGet($url){
        if(empty($url))
            exception('非法请求-curl', 412);
        //初始化
        $curl = curl_init();
        //设置抓取的url
        curl_setopt($curl, CURLOPT_URL, $url);
        //设置头文件的信息作为数据流输出
        curl_setopt($curl, CURLOPT_HEADER, 0);
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json; charset=utf-8',	'JX-TOKEN: 0000000000000000000000000000000000000000'));

        //设置获取的信息以文件流的形式返回，而不是直接输出。
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        //执行命令
        $data = curl_exec($curl);
        //关闭URL请求
        curl_close($curl);
        //显示获得的数据
        return $data;
    }


    //拼接参数，生成sign，暂不启用
    public static function ServerVisitPostSpare($params)
    {

        //拼装验证参数，appid,sign,nonce
        $apps = ThirdApplication::all();

        $params['appid'] = $apps['AppId'];
        $params['nonce'] = randomkeys(10);
        //生成sign
        $sign = ThirdAppManager::GenerateSign($params);
        $params['sign'] = $sign;
        return $params;
        //验证sign
        $isVerifiedSign = ThirdAppManager::VerifySign($params);
        if (false == $isVerifiedSign) {
            exception('非法请求-sign', 412);
        }
        return;

    }
}