<?php

namespace app\workplace\services;

use app\common\modules\ResourceHelper;
use app\workplace\models\EventCode;
use app\workplace\models\Message;
use app\common\modules\DbHelper;

class MessageService
{
    public static function readMsg($message_id, $passportId)
    {
        $IsRead = Message::where(['ToPassportId' => $passportId, 'MessageId' => $message_id])->value('IsRead');
        if ($IsRead === 0) {
            Message::where('MessageId', $message_id)->where('ToPassportId', $passportId)->update(['IsRead' => 1, 'ReadTime' => DbHelper::toLocalDateTime(date("Y-m-d H:i:s"))]);
        }
        return true;
    }

    public static function detail($message_id, $passportId)
    {
        $detail = Message::where(['ToPassportId' => $passportId, 'MessageId' => $message_id])->find();
        MessageService::readMsg($message_id, $passportId);
        return $detail;
    }

    public static function MessageList($request)
    {
        $MessageType = 'eq';
        if ($request['MessageType'] == 2) {
            $MessageType = 'NEQ';
        }

        $list = Message::where('ToPassportId', $request['PassportId'])->where('BizType', $MessageType, 0)->page($request['Page'], $request['Size'])->order('CreatedTime desc')->select();
        if (empty($list)) {
            return $list;
        }
        foreach ($list as $keys => $value) {
            if ($value['BizType'] > 0) {
                $url = '/_files/message-images/comment' . $value['BizType'] . '.png';
            } else {
                if ($value['EventCode']===EventCode::AddOpinion){
                    $url = '/_files/message-images/ping.png';
                }else{
                    $url = '/_files/message-images/week' . date('w', strtotime($value['CreatedTime'])) . '.png';
                }

            }
            $list[$keys]['Picture'] = ResourceHelper::ToAbsoluteUri($url);
        }
        return $list;
    }

    public static function getRedDotLogic($request)
    {
        $MessageType = 'eq';
        if ($request['MessageType'] == 2) {
            $MessageType = 'NEQ';
        }
        $smscount = Message::where('ToPassportId', $request['PassportId'])->where('BizType', $MessageType, 0)->where('IsRead', 0)->count();
        if ($smscount) {
            return true;
        } else {
            return false;
        }
    }
}