<?php

namespace app\common\controllers;
use think\Config;
use think\Controller;

class PageController extends Controller {
	public function __construct() {
		parent::__construct();  
        Config::set('default_return_type',"html");
	}
}