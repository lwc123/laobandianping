<?php

namespace app\workplace\services;

use app\workplace\models\Business;
use think\Loader;

class BusinessService {


    public static function getBizTypeById($biz_id){

        return Business::where('BusinessId',$biz_id)->value('BusinessName');

    }

}