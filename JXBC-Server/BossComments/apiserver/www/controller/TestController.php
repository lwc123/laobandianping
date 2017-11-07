<?php
namespace app\www\controller;
use think\Cache;
use think\Config;
use think\Request;
use think\Controller;
use app\common\controllers\AuthenticatedController;

class TestController extends Controller
{
    public function index(Request $request)
    {
        Cache::rm("Dic:Entries_".strtoupper("city"));
        Cache::rm("Dic:Entries_".strtoupper("industry"));
        echo 123;
    }

}


