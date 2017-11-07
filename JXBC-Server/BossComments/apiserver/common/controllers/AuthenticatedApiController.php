<?php

namespace app\common\controllers;
use think\Request;
use app\appbase\models\UserPassport;

class AuthenticatedApiController extends ApiController {
	protected $UserPassport;

	public function __construct() {
		parent::__construct();
		if(empty($this->PassportId)){
			$this->error(401,'用户没有登录或不存在');
		}
	}    

	protected function GetPassport() {
	    if(empty($this->UserPassport)) {
	        $this->UserPassport = UserPassport::load($this->PassportId);
	    }
	    return $this->UserPassport;
	}    
}