<?php

namespace app\workplace\services;

use app\workplace\models\Message;
use app\workplace\models\MessageEngine;
use app\workplace\models\MessageSms;
use app\workplace\models\MessageTemplete;
use app\workplace\models\NoticeArgs;
use app\workplace\models\NoticeContacts;
use think\View;


class NoticeService
{

    public static function sendNotice($eventCode, NoticeArgs $noticeArgs, $IsSendSms = null)
    {

        $event_id = MessageEngine::where('EventCode', $eventCode)->value('EventId');

        $templetes = MessageTemplete::where('EventId', $event_id)->where('Enable', 1)->select();

        foreach ($templetes as $templete) {

            switch ($templete['SendType']) {
                case 'push':
                    //self::sendPush($templete,$eventCode,$noticeArgs);
                    break;
                case 'msg':
                    self::sendMsg($templete, $eventCode, $noticeArgs);
                    break;

                case 'sms':
                    if ($IsSendSms||isset($IsSendSms)==false) {
                        self::sendSms($templete, $eventCode, $noticeArgs);
                    }
                    break;

                default:
                    exception('event is null', 412);
            }
        }
    }

    private static function ExecTemplete($content, NoticeContacts $toContacts, NoticeArgs $noticeArgs)
    {
        $view = new View();
        $view->assign('Model', $noticeArgs->EventModel);
        $view->assign('NoticeArgs', $noticeArgs);
        $view->assign('ToContacts', $toContacts);
        $view->assign('FromContacts', $noticeArgs->FromContacts);
        $text = $view->display($content, []);
        return $text;
    }

    private static function sendMsg($templete, $eventCode, NoticeArgs $noticeArgs)
    {

        foreach ($noticeArgs->ToContactsList as $toContacts) {
            if ($toContacts->PassportId < 1) continue;
            $text = NoticeService::ExecTemplete($templete['Content'], $toContacts, $noticeArgs);
            $msg_data = array(
                'FromCompanyId' => $noticeArgs->FromContacts['CompanyId'],
                'FromPassportId' => $noticeArgs->FromContacts['PassportId'],
                'ToCompanyId' => $toContacts->CompanyId,
                'ToPassportId' => $toContacts->PassportId,
                'Content' => $text,
                'EventCode' => $eventCode,
                'BizId' => $noticeArgs->BizId,
                'BizType' => $noticeArgs->BizType);
            Message::create($msg_data);
        }

    }

    private static function sendSms($templete, $eventCode, NoticeArgs $noticeArgs)
    {
        foreach ($noticeArgs->ToContactsList as $toContacts) {
            if (empty($toContacts->MobilePhone)) continue;
            $MobilePhone = $toContacts->MobilePhone;
            if (config('app_test') && !empty(config('SMS_TestPhone'))) {
                $toContacts->MobilePhone = Config('SMS_TestPhone');
            }
            $text = NoticeService::ExecTemplete($templete['Content'], $toContacts, $noticeArgs);
            $url = 'http://sdk.entinfo.cn/webservice.asmx/mdSmsSend?sn=SDK-BBX-010-23630&pwd=AF01B559B6B6CD0D1D259CC41B255347&mobile=' .
                trim($toContacts->MobilePhone) . '&content=' . urlencode(iconv('UTF-8', 'gbk', $text)) . '&ext=&stime=&rrid=&msgfmt';
            $result = file_get_contents($url);
            $msg_data = array(
                'CompanyId' => $noticeArgs->FromContacts['CompanyId'],
                'PassportId' => $noticeArgs->FromContacts['PassportId'],
                'FromCompanyId' => $toContacts->CompanyId,
                'FromPassportId' => $toContacts->PassportId,
                'MobilePhone' => $MobilePhone,
                'Content' => $text,
                'IsRead' => 0,
                'EventCode' => $eventCode,
                'BizId' => $noticeArgs->BizId,
                'BizType' => $noticeArgs->BizType,
                'SendType' => 'sms');
            MessageSms::create($msg_data);

        }
    }
}