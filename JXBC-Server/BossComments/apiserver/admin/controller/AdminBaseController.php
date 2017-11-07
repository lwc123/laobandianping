<?php

namespace app\Admin\controller;
use think\Controller;
use think\Session;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\common\modules\DbHelper;
use app\workplace\models\Company;


class AdminBaseController extends Controller {

    public $AdminId;

    public function __construct(Request $request = null){

        parent::__construct($request);
        $this->AdminId = Session::get('admin.AdminUserId');

        if (empty($this->AdminId)){

            $this->success('用户不存在','/public/login');
        }
    }

}
