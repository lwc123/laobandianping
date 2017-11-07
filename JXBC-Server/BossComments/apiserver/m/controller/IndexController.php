<?php
namespace app\m\controller;
use think\Request;
use think\Controller;

class IndexController extends Controller
{
    public function index(Request $request)
    {
        return $this->fetch ("www@index/index-mobile");
    }
}


