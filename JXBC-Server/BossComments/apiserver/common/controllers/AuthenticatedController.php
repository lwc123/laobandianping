<?php

namespace app\common\controllers;
use think\Config;
use think\Request;
use think\Controller;
use app\appbase\models\UserPassport;
use app\appbase\models\UserPassportToken;

class AuthenticatedController extends Controller {
    protected  $PassportId = 0;
    protected $UserPassport;

	public function __construct() {
        parent::__construct();
        $request = Request::instance();

        $token = Request::instance ()->header ( "JX-TOKEN" );

        if(empty($token)) {
            $token = Request::instance ()->cookie ( "JX-TOKEN" );
        }
        if(!empty($token)) {
            $this->PassportId = UserPassportToken::FindIdByToken($token);
        }

        if (empty($this->PassportId)) {
            $this->redirect("/account/login?rurl=".urlencode($request->url()));
        }
	}    

	protected function GetPassport() {
	    if(empty($this->UserPassport)) {
	        $this->UserPassport = UserPassport::load($this->PassportId);
	    }
	    return $this->UserPassport;
	}

    protected function error($status = '', $msg = '',   $url = null, array $header = []) {
        header("HTTP/1.1 ".$status." ".$msg);
        header("status: ".$status." ".$msg);
        Config::set('default_return_type',"json");
        parent::error($status,$msg,$url,$header);
    }
}