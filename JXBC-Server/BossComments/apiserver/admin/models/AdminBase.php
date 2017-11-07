<?php

namespace app\admin\models;

use think\Config;
use app\common\models\BaseModel;



class AdminBase extends BaseModel{


    protected function initialize()
    {

        parent::init();
        $this->connection = Config::get('db_admin');
    }

}




