<?php

namespace app\workplace\services; 
use think\Request;
use app\workplace\models\MemberRole;
use app\workplace\models\Company;
use app\workplace\models\EventCode;
use app\workplace\models\NoticeContacts;
use app\workplace\models\NoticeArgs;
use app\workplace\models\CompanyMember;
/**
 * 授权人发消息具体实现调用
 */
class NoticeByMemberService {
    /**
     * 添加授权人，给授权人发送消息(未注册)
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function AddAuthorized($MemberDate, $Password) {
        if (empty ( $MemberDate ) || empty ( $Password ) ) {
            exception ( '非法请求-0', 412 );
        }
        // 收信人
        $ToContactsList = [ ];
        $item = new NoticeContacts ();
        $item->CompanyId = $MemberDate ['CompanyId'];
        $item->PassportId = $MemberDate ['PassportId'];
        $item->MobilePhone = $MemberDate ['MobilePhone'];
        $item->DisplayName = $MemberDate ['RealName'];
        array_push ( $ToContactsList, $item );
        // 判断授权的角色
        if ($MemberDate ['Role'] == MemberRole::Manager) {
            $Role = '管理员';
        } elseif($MemberDate ['Role'] == MemberRole::Executives) {
            $Role = '高管';
        }elseif($MemberDate ['Role'] == MemberRole::FilingClerk){
            $Role = '建档员';
        }
        //公司的名字
        $CompanyName = Company::where ( ['CompanyId' => $MemberDate ['CompanyId']] )->value('CompanyName');


        // 发信人
        $FromContactpassport = CompanyMember::where ( [
            'CompanyId' => $MemberDate ['CompanyId']
        ] )->where ( 'PassportId', $MemberDate['PresenterId'] )->find ();
        //事件类型
        $eventCode = EventCode::AddAuthorized;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactpassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId=$MemberDate['PassportId'];
        $noticeArgs->EventModel=array (
            'CompanyName' =>$CompanyName,
            'Role' => $Role,
            'Password' => $Password,
            'MobilePhone' => $MemberDate['MobilePhone']
        );
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**
     * 添加授权人，给授权人发送消息(已注册)
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function AddAuthorizedAlready($MemberDate) {

        if (empty ( $MemberDate ) ) {
            exception ( '非法请求-0', 412 );
        }
        // 收信人
        $ToContactsList = [ ];
        $item = new NoticeContacts ();
        $item->CompanyId = $MemberDate ['CompanyId'];
        $item->PassportId = $MemberDate ['PassportId'];
        $item->MobilePhone = $MemberDate ['MobilePhone'];
        $item->DisplayName = $MemberDate ['RealName'];
        array_push ( $ToContactsList, $item );
        // 判断授权的角色
        if ($MemberDate ['Role'] == MemberRole::Manager) {
            $Role = '管理员';
        } elseif($MemberDate ['Role'] == MemberRole::Executives) {
            $Role = '高管';
        }elseif($MemberDate ['Role'] == MemberRole::FilingClerk){
            $Role = '建档员';
        }
        //公司的名字
        $CompanyName = Company::where ( ['CompanyId' => $MemberDate ['CompanyId']] )->value('CompanyName');

        // 发信人
        $FromContactpassport = CompanyMember::where ( [
            'CompanyId' => $MemberDate ['CompanyId']
        ] )->where ( 'PassportId', $MemberDate['PresenterId'] )->find ();
        //事件类型
        $eventCode = EventCode::AddAuthorizedAlready;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactpassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId=$MemberDate['PassportId'];
        $noticeArgs->EventModel=array (
            'CompanyName' =>$CompanyName,
            'Role' => $Role
        );
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**
     * 添加授权人，给老板发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function AddAuthorizedBoss($MemberDate) {

        if (empty ( $MemberDate ) ) {
            exception ( '非法请求-0', 412 );
        }
        //老板的信息
        $BossInfor = CompanyMember::where ( ['CompanyId' => $MemberDate ['CompanyId']] )->where ( ['Role' => MemberRole::Boss] )->find();
        // 收信人
        $ToContactsList = [ ];
        $item = new NoticeContacts ();
        $item->CompanyId = $BossInfor ['CompanyId'];
        $item->PassportId = $BossInfor ['PassportId'];
        $item->MobilePhone = $BossInfor ['MobilePhone'];
        $item->DisplayName = $BossInfor ['RealName'];
        array_push ( $ToContactsList, $item );
        // 判断授权的角色
        if ($MemberDate ['Role'] == MemberRole::Manager) {
            $Role = '管理员';
        } elseif($MemberDate ['Role'] == MemberRole::Executives) {
            $Role = '高管';
        }elseif($MemberDate ['Role'] == MemberRole::FilingClerk){
            $Role = '建档员';
        }
        //公司的名字
        $CompanyName = Company::where ( ['CompanyId' => $MemberDate ['CompanyId']] )->value('CompanyName');


        // 发信人
        $FromContactpassport = CompanyMember::where ( [
            'CompanyId' => $MemberDate ['CompanyId']
        ] )->where ( 'PassportId', $MemberDate['PresenterId'] )->find ();

        //事件类型
        $eventCode = EventCode::AddAuthorizedBoss;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactpassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId=$MemberDate['PassportId'];
        $noticeArgs->EventModel=array (
            'RealName' => $MemberDate['RealName'],
            'CompanyName' =>$CompanyName,
            'Role' => $Role
        );
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }
}