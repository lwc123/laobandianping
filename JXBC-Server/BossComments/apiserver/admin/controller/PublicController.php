<?php

namespace app\Admin\controller;
use app\admin\models\AdminUser;
use app\admin\services\AdminUserService;
use app\common\modules\DbHelper;
use think\Controller;
use think\Session;
use think\View;
use think\Db;
use think\Config;
use think\Request;


class PublicController extends Controller {


    public function __construct(Request $request = null){

        parent::__construct($request);
    }

    public function login(Request $request){

        if ($request->isPost()){

            $user_data = $request->put();
            $get_user_info = AdminUserService::getAdminUserinfoByPhone($user_data['MobilePhone']);

            if (empty($get_user_info['AdminUserId'])){
                echo 2;
            } elseif ($get_user_info['Password'] !== md5($user_data['Password'].$get_user_info['Sign'])){

               echo 3;
            }

            else{

                Session::set('admin',$get_user_info);
                AdminUser::where('AdminUserId',$get_user_info['AdminUserId'])->update(['LastLoginTime'=>DbHelper::toLocalDateTime(date("Y-m-d H:i:s")),'LastLoginIp'=>$request->ip()]);
                //$this->success('登录成功','/admin/Sample/console');
                echo 1;
            }

        }else{

              return $this->fetch('/sample/login');
        }

    }

    public function logout(){

        Session::delete('admin');
        $this->success('已成功退出','/public/login');

    }



}
