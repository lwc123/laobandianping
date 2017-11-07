<?php

namespace app\apppage\controller;
use app\common\controllers\PageController;

  
class JobDetailController extends PageController {
    public function _empty()
    {
        return $this->fetch();
    }
}
