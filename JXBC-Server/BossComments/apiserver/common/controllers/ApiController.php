<?php

namespace app\common\controllers;
use think\Config;
use think\Controller;
use think\Request;
use think\Db;
use app\appbase\models\UserPassportToken;

define('BS_ERROR','401');
//图片地址
 

class ApiController extends Controller {
    protected  $PassportId = 0; 
    public function __construct() {
        parent::__construct();
        
        $token = Request::instance ()->header ( "JX-TOKEN" );
       
        if(empty($token)) {
            $token = Request::instance ()->cookie ( "JX-TOKEN" );
        }
        if(empty($token)) {
            $this->error(401, '没有请求权限');
        } else {
            $this->PassportId = UserPassportToken::FindIdByToken($token);
        }
    }
    
    protected function error($status = '', $msg = '',   $url = null, array $header = []) {
        header("HTTP/1.1 ".$status." ".$msg);
        header("status: ".$status." ".$msg);
        Config::set('default_return_type',"json");
        parent::error($status,$msg,$url,$header);
    }
    
    protected function returnNull() {
    	Config::set('default_return_type',"html");
    	return "null";
    }
    
    protected function listenDb() {
        Db::listen(function($sql, $time, $explain){
            // 记录SQL
            echo $sql. ' ['.$time.'s]';
            // 查看性能分析结果
            dump($explain);
        });    
    }
}