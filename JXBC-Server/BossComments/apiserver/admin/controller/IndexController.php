<?php

namespace app\admin\controller;

use app\admin\controller\AuthenticatedController;

class IndexController extends AuthenticatedController {
	public function _empty()
    {
        return $this->fetch("console");
    }
}

