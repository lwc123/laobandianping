<?php

namespace app\admin\services;

use app\admin\models\AdminUser;
use think\db;
use app\common\modules\ResourceHelper;

class AdminUserService {

    public static function getAdminUserinfoByPhone($mobile_phone){

        return AdminUser::where('MobilePhone',$mobile_phone)->where('Status',1)->find();
    }


    public static function getAdminUserinfoById($admin_user_id){

        return AdminUser::where('AdminUserId',$admin_user_id)->where('Status',1)->find();

    }


    public static function getAdminUserList($start,$size){

        return AdminUser::order('LastLoginTime desc')->field('AdminUserId,AdminName,MobilePhone,CreatedTime,LastLoginTime,LastLoginIp,Status')->limit('0,20')->select();

    }



}