<?php

namespace app\Admin\controller;
use app\admin\models\AdminUser;
use app\admin\models\UserRole;
use think\View;
use think\Db;
use think\Config;
use think\Request;

class AdminUserController extends AuthenticatedController {


    public function adminList(){

        $data = AdminUser::all();
        $this->assign('data',$data);

        return $this->fetch('/adminuser/adminlist');
    }

    public function addAdmin(Request $request){

        if ($request->isPost()){

            $data = $request->post();
            $sign = mt_rand(0000,9999);
            $passwd = md5($data['Password']).$sign;
            $user_data = array('AdminName'=>$data['AdminName'],'MobilePhone'=>$data['MobilePhone'],'Password'=>md5($passwd),'RoleCode'=>$data['role'],'Sign'=>$sign);
            AdminUser::create($user_data);
            $this->success('添加成功');

        }else{

            $role = UserRole::all();
            $this->assign('role',$role);
            return $this->fetch('adminuser/addadmin');
        }
    }


    public function delAdmin($admin_user_id){

        $status = AdminUser::where('AdminUserId', intval($admin_user_id))->update(['Status' => 0]);

        if ($status){

            $this->success('操作成功');

        }else{

            $this->error('操作失败');
        }

    }


}
