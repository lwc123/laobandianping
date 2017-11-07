<?php

namespace app\opinion\models;

use think\Config;
use app\common\models\BaseModel;



class OpinionBase extends BaseModel{


    protected function initialize()
    {

        parent::init();
        $this->connection = Config::get('db_opinion');
    }

}




