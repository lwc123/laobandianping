<?php

namespace app\m\controller;
use app\common\controllers\PageController;

  
class BossCommentsController extends PageController {
    public function _empty()
    {
        return $this->fetch();
    }
}


