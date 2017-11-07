<?php
namespace app\common\controllers;

use think\Controller;
use think\Request;
use app\common\modules\ThirdAppManager;

class MicroServiceApiController extends Controller {

    public function __construct() {
        parent::__construct();

        $request = Request::instance(); 
        $reuqestParams = null;
        if($request->isGet()){
            $reuqestParams = $request->get(); 
        } else {
            $reuqestParams = $request->put();
        }
        if(isset($reuqestParams['channel_code'])){
            $this->verifySign($reuqestParams);
        }
    }

    private function verifySign($params) { 
        if(!array_key_exists(ThirdAppManager::Param_Sign, $params) || empty($params[ThirdAppManager::Param_Sign]))
            $this->error(412, '非法请求-sign');
        if(!array_key_exists(ThirdAppManager::Param_Nonce, $params) || empty($params[ThirdAppManager::Param_Nonce]))
            $this->error(412, '非法请求-nonce');
        if(!array_key_exists(ThirdAppManager::Param_AppId, $params) || empty($params[ThirdAppManager::Param_AppId]))
            $this->error(412, '非法请求-appId');

        $isVerifiedSign = ThirdAppManager::VerifySign($params);
         
        if(false == $isVerifiedSign) { 
            $this->error(412, '非法请求-sign');
        }
    }

    protected function error($status = '', $msg = '',   $url = null, array $header = []) {
        header("HTTP/1.1 ".$status." ".$msg);
        header("status: ".$status." ".$msg);
        parent::error($status,$msg,$url,$header);
    }
}