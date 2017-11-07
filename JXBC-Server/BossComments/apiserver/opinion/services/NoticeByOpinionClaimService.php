<?php

namespace app\opinion\services;
use think\Request;
use app\workplace\models\Company as workplaceCompany;
use app\workplace\models\EventCode;
use app\workplace\models\NoticeContacts;
use app\workplace\models\NoticeArgs;
use app\workplace\models\CompanyMember;
use app\opinion\models\Company;
use app\workplace\services\NoticeService;
/**
 * 口碑公司认领发消息具体实现调用
 */
class NoticeByOpinionClaimService {
    /**
     * 认领通过/未通过，给认领人、公司老板、管理员发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
  public static function OpinionClaimSuccess($MessageMan){
      if (empty ( $MessageMan ) || empty ( $MessageMan['CompanyId'] ) || empty ( $MessageMan['OpinionCompanyId'] )) {
          exception ( '非法请求-0', 412 );
      }
           $CompanyName=  workplaceCompany::where('CompanyId',$MessageMan['CompanyId'])->value('CompanyName');
           $OpinionCompanyName =    Company::where('CompanyId',$MessageMan['OpinionCompanyId'])->value('CompanyName');
           $MemberList = CompanyMember::where('role','lt',3)->where('CompanyId',$MessageMan['CompanyId'])->select();
           if(! empty ( $MessageMan['PassportId'] )){
             $ClaimMan = CompanyMember::where('PassportId',$MessageMan['PassportId'] )->where('CompanyId',$MessageMan['CompanyId'])->find();
             if($ClaimMan['Role']>2 ){
                 array_push ( $MemberList, $ClaimMan );
             }
         }
      // 收信人
      $ToContactsList = [];
      foreach($MemberList as $key=>$val){
          $item = new NoticeContacts ();
          $item->CompanyId = $val ['CompanyId'];
          $item->PassportId = $val ['PassportId'];
          $item->MobilePhone = $val ['MobilePhone'];
          $item->DisplayName = $val ['RealName'];
          array_push ( $ToContactsList, $item );
      }
      // 发信人 平台管理员
      $FromContact = ['CompanyId'=>0,'PassportId'=>0,'MobilePhone'=>0,'DisplayName'=>0];
      //事件类型
      if($MessageMan['AuditStatus']==2){
          $eventCode = EventCode::OpinionClaimSuccess;
      }else if($MessageMan['AuditStatus']==3){
          $eventCode = EventCode::OpinionClaimFailed;
      }else{
          return false;
      }
      $noticeArgs = new NoticeArgs();
      $noticeArgs->ToContactsList = $ToContactsList;
      $noticeArgs->FromContacts =$FromContact;
      $noticeArgs->BizType = "";
      $noticeArgs->BizId=$MessageMan ['CompanyId'];
      $noticeArgs->EventModel = array(
          'CompanyName' => $CompanyName,
          'OpinionCompanyName' => $OpinionCompanyName
      );
      NoticeService::sendNotice($eventCode, $noticeArgs);
}

}