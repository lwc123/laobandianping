<?php

namespace app\admin\controller;

use think\Controller;
use think\View;
use think\Db;
use think\Request;
use think\Config;
use think\Session;

class AuthenticatedController extends Controller {
	protected $AdminPassport;

	public function __construct() {
		parent::__construct();

        $this->AdminId = Session::get('admin.AdminUserId');

        if (empty($this->AdminId)){
            $this->redirect("/public/login?rurl=".urlencode(Request::instance()->url()));
        }
	}     
}


