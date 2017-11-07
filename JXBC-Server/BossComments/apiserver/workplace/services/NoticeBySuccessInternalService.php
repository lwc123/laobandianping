<?php
/**
 * Created by PhpStorm.
 * User: Soce
 * Date: 2017/1/13
 * Time: 20:54
 */
namespace app\workplace\services;
use app\appbase\models\UserPassport;
use app\common\modules\PaymentEngine;
use app\workplace\models\CompanyMember;
use app\workplace\models\EventCode;
use app\workplace\models\MemberRole;
use app\workplace\models\NoticeArgs;
use app\workplace\models\NoticeContacts;

/**
 * 邀请注册分成发消息具体实现调用
 */
class NoticeBySuccessInternalService {
    /**
     * 企业邀请企业开户成功，给老板+所有管理员发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */

    public static function SuccessCompanyInter($ownerId,$InternalPassportId){
        if (empty ( $ownerId )) {
            exception ( '非法请求-0', 412 );
        }
        // 收信人
        $MemberList = CompanyMember::where ( [
            'CompanyId' => $ownerId] )->where(function($query){
            $query->where ( 'Role',MemberRole::Boss)->whereor( 'Role', MemberRole::Manager )   ;})->select ();

        $ToContactsList = [ ];
        foreach ( $MemberList as $passport ) {
                $item = new NoticeContacts();
                $item->CompanyId = $passport ['CompanyId'];
                $item->PassportId = $passport ['PassportId'];
                $item->MobilePhone = $passport ['MobilePhone'];
                $item->DisplayName = $passport ['RealName'];
                array_push ( $ToContactsList, $item );
        }
        // 发信人,系统
        $FromContactPassport = ['CompanyId'=>0,'PassportId'=>0,'MobilePhone'=>0,'DisplayName'=>0];
        //事件类型
        $eventCode = EventCode::OrdinarynvitedAccountSuccessfully;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactPassport;
        $noticeArgs->BizType = 0;
        $noticeArgs->BizId=$ownerId;
        $noticeArgs->EventModel=array (
            'RealName' => CompanyMember::where ( ['CompanyId' => $ownerId] )->where ( 'PassportId', $InternalPassportId)->value ( 'RealName' ),
            'Money' =>  PaymentEngine::GetCompanyInviteRegisterPrice($ownerId)
        );
        NoticeService::sendNotice($eventCode, $noticeArgs);


    }


    /**
     * 个人邀请企业开户成功，给邀请人发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */

    public static function SuccessPersonalInter($ownerId){
        if (empty ( $ownerId )) {
            exception ( '非法请求-0', 412 );
        }
        $MessageMan=UserPassport::load($ownerId);

        // 收信人
        $ToContactsList = [ ];
        $item = new NoticeContacts ();
        $item->CompanyId = 0;
        $item->PassportId = $MessageMan ['PassportId'];
        $item->MobilePhone = $MessageMan ['MobilePhone'];
        $item->DisplayName = 0;
        array_push ( $ToContactsList, $item );

        // 发信人,系统
        $FromContactPassport = ['CompanyId'=>0,'PassportId'=>0,'MobilePhone'=>0,'DisplayName'=>0];
        //事件类型
        $eventCode = EventCode::AgentsAccountsSuccess;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactPassport;
        $noticeArgs->BizType = 0;
        $noticeArgs->BizId=$ownerId;
        $noticeArgs->EventModel=array (
            'Money' =>  PaymentEngine::GetPrivatenessInviteRegisterPrice($ownerId)
        );
        NoticeService::sendNotice($eventCode, $noticeArgs);


    }

}