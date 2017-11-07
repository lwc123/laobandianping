<?php
namespace app\www\controller;
use think\Config;
use think\Request;
use think\Controller;
use app\common\controllers\AuthenticatedController;

class AppController extends Controller
{
    public function index(Request $request)
    {
        $this->redirect("/");
    }

    public function download(Request $request)
    {
        $target = $request->get("target");
        $userAgent = strtolower($request->header('user-agent'));
        if($target == "wechat" || strpos($userAgent, "micromessenger") !== false) {
            $this->redirect(Config::get("app_download_wechat"));
        }else if($target == "ios" || strpos($userAgent, "ios") !== false  || strpos($userAgent, "iphone") !== false || strpos($userAgent, "mac os x") !== false) {
            $this->redirect(Config::get("app_download_ios"));
        } else if ($request->isMobile()&& !empty(Config::get("app_download_apk_mobile"))) {
            $this->redirect(Config::get("app_download_apk_mobile"));
        } else {
            $this->redirect(Config::get("app_download_apk"));
        }
    }
}


