<?php

namespace app\workplace\services; 
use think\Request;
use app\workplace\models\Company;
use app\workplace\models\EventCode;
use app\workplace\models\NoticeContacts;
use app\workplace\models\NoticeArgs;
use app\workplace\models\CompanyMember;
use app\appbase\models\UserPassport;

/**
 * 开户成功发消息具体实现调用
 */
class NoticeByOpenEnterpriseService {
    /**
     * 开户成功，给注册人发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
  public static function SuccessfulOpeningAccount($MessageMan){
      if (empty ( $MessageMan ) || empty ( $MessageMan['CompanyId'] )) {
          exception ( '非法请求-0', 412 );
      }
       // 收信人
      $ToContactsList = [ ];
      $item = new NoticeContacts ();
      $item->CompanyId = $MessageMan ['CompanyId'];
      $item->PassportId = $MessageMan ['PassportId'];
      $item->MobilePhone = $MessageMan ['MobilePhone'];
      $item->DisplayName = $MessageMan ['RealName'];
      array_push ( $ToContactsList, $item );

      // 发信人 平台管理员
      $FromContact = ['CompanyId'=>0,'PassportId'=>0,'MobilePhone'=>0,'DisplayName'=>0];
      //事件类型
      $eventCode = EventCode::SuccessfulOpeningAccount;
      $noticeArgs = new NoticeArgs();
      $noticeArgs->ToContactsList = $ToContactsList;
      $noticeArgs->FromContacts =$FromContact;
      $noticeArgs->BizType = "";
      $noticeArgs->BizId=$MessageMan ['CompanyId'];
      $noticeArgs->EventModel=array();
      NoticeService::sendNotice($eventCode, $noticeArgs);
}
    /**
     * 个人用户开通会员
     *
     * @access public
     * @param
     *
     * @return
     *
     */

    public static function  OpenVip($PassportId){
        //发送短信和站内信
        $UserProfile = UserPassport::load($PassportId);
        $ToContactsList = [ ];
        $item = new NoticeContacts ();
        $item->CompanyId = 0;
        $item->PassportId = $PassportId;
        $item->MobilePhone = $UserProfile['MobilePhone'];
        $item->DisplayName = $UserProfile['UserName'];
        array_push ( $ToContactsList, $item );
        // 发信人
        $FromContactPassport = ['CompanyId'=>0,'PassportId'=>0,'MobilePhone'=>0,'DisplayName'=>0];
        //事件类型
        $eventCode = EventCode::OpenVip;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts =$FromContactPassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId=$PassportId;
        $noticeArgs->EventModel=array ();
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }
}