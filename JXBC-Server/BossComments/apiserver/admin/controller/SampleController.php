<?php

namespace app\admin\controller;

use app\admin\controller\AuthenticatedController;

class SampleController extends AuthenticatedController {

	public function _empty()
    {
        return $this->fetch();
    }

}

