<?php
namespace app\www\controller;

use think\Config;
use think\Controller;
use think\Request;

class NewsController extends Controller{

    public function _empty()
    {
        return $this->fetch();
    }

    public function detail(Request $request)
    {
        $id = $request->param ('id');
        $url=APP_PATH.'www/view/news/new'.$id.'.html';
        $detail=file_get_contents($url);
        $detail=str_replace(array("\r\n", "\r", "\n"), "<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", $detail);
        $detail=str_replace("</h2><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span", "</h2><span", $detail);
        $detail=str_replace('{$Think.config.resources_site_root}',Config('resources_site_root'),  $detail);
        preg_match("/<h2>([\s\S]*?)<\/h2>/",$detail, $matches);
        $title =$matches[1];
        //$detail=str_replace("</span><br>", "</span>", $detail);
        $this->assign('detail',$detail);
        $this->assign('title',$title);
        if ($request->isMobile())
            return $this->fetch ("detail-mobile");
        else
            return $this->fetch ();
         
    }
}