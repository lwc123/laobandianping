<?php
namespace app\www\controller;
use think\Config;
use think\Request;
use think\Controller;


class BackgroundSurveyController extends CompanyBaseController
{
    public function _empty()
    {
        return $this->fetch();
    }
}


