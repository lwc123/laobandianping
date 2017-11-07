<?php

namespace app\workplace\services;

use app\common\modules\DictionaryPool;
use app\workplace\models\MessageSms;
use think\Cache;
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
class NoticeByCompanyAuditService
{
    /**
     * 企业认证,运营审核通过，给提交人发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function EnterpriseCertification($MessageMan)
    {
        if (empty ($MessageMan) || empty ($MessageMan['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $MemberDate = CompanyMember::where([
            'CompanyId' => $MessageMan ['CompanyId']
        ])->where('PassportId', $MessageMan['PassportId'])->find();
        // 收信人
        $ToContactsList = [];
        $item = new NoticeContacts ();
        $item->CompanyId = $MemberDate ['CompanyId'];
        $item->PassportId = $MemberDate ['PassportId'];
        $item->MobilePhone = $MemberDate ['MobilePhone'];
        $item->DisplayName = $MemberDate ['RealName'];
        array_push($ToContactsList, $item);

        // 发信人 平台管理员
        $FromContactpassport = ['CompanyId' => 0, 'PassportId' => 0, 'MobilePhone' => 0, 'DisplayName' => 0];
        //事件类型
        $eventCode = EventCode::EnterpriseCertification;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactpassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId = $MemberDate['PassportId'];
        $noticeArgs->EventModel = array();
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**
     * 企业认证,运营审核通过，并给老板创建账号，给老板发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function EnterpriseCertificationCreateAccount($MemberDate, $Password)
    {
        if (empty ($MemberDate) || empty ($Password)) {
            exception('非法请求-0', 412);
        }
        // 收信人
        $ToContactsList = [];
        $item = new NoticeContacts ();
        $item->CompanyId = $MemberDate ['CompanyId'];
        $item->PassportId = $MemberDate ['PassportId'];
        $item->MobilePhone = $MemberDate ['MobilePhone'];
        $item->DisplayName = $MemberDate ['RealName'];
        array_push($ToContactsList, $item);
        //公司的名字
        $CompanyName = Company::where(['CompanyId' => $MemberDate ['CompanyId']])->value('CompanyName');
        // 发信人
        $FromContactPassport = ['CompanyId' => 0, 'PassportId' => 0, 'MobilePhone' => 0, 'DisplayName' => 0];
        //事件类型
        $eventCode = EventCode::EnterpriseCertificationCreateAccount;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactPassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId = $MemberDate['PassportId'];
        $noticeArgs->EventModel = array(
            'CompanyName' => $CompanyName,
            'Password' => $Password,
            'MobilePhone' => $MemberDate['MobilePhone']
        );
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**
     * 企业认证,运营审核通过，不创建老板账号，给提交人，老板发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function EnterpriseCertificationDotAccount($MemberDate)
    {
        if (empty ($MemberDate) || empty ($MemberDate['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        //老板的信息
        $BossInfor[0] = CompanyMember::where(['CompanyId' => $MemberDate ['CompanyId']])->where(['Role' => MemberRole::Boss])->find();
        $BossInfor[1] = CompanyMember::where(['CompanyId' => $MemberDate ['CompanyId']])->where(['Role' => MemberRole::Manager])->order('CreatedTime')->limit(1)->find();
        // 收信人
        $ToContactsList = [];
        foreach ($BossInfor as $value) {
            $item = new NoticeContacts ();
            $item->CompanyId = $value ['CompanyId'];
            $item->PassportId = $value ['PassportId'];
            $item->MobilePhone = $value ['MobilePhone'];
            $item->DisplayName = $value ['RealName'];
            array_push($ToContactsList, $item);
        }
        // 发信人
        $FromContactPassport = ['CompanyId' => 0, 'PassportId' => 0, 'MobilePhone' => 0, 'DisplayName' => 0];
        //事件类型
        //print_r($ToContactsList);die;
        $eventCode = EventCode::EnterpriseCertificationDotAccount;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactPassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId = $MemberDate['CompanyId'];
        $noticeArgs->EventModel = array();
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**
     * 企业认证审核未通过，给提交人发送消息
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function EnterpriseCertificationError($MemberDate)
    {
        if (empty ($MemberDate) || empty ($MemberDate['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $MemberDate = CompanyMember::where(['CompanyId' => $MemberDate['CompanyId'], 'PassportId' => $MemberDate['PassportId']])->find();
        // 收信人
        $ToContactsList = [];
        $item = new NoticeContacts ();
        $item->CompanyId = $MemberDate ['CompanyId'];
        $item->PassportId = $MemberDate ['PassportId'];
        $item->MobilePhone = $MemberDate ['MobilePhone'];
        $item->DisplayName = $MemberDate ['RealName'];
        array_push($ToContactsList, $item);
        // 发信人
        $FromContactPassport = ['CompanyId' => 0, 'PassportId' => 0, 'MobilePhone' => 0, 'DisplayName' => 0];
        //事件类型
        $eventCode = EventCode::EnterpriseCertificationError;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactPassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId = $MemberDate['PassportId'];
        $noticeArgs->EventModel = array();
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**
     * 企业认证,运营审核通过，不创建老板账号，给老板发送短信
     *
     * @access public
     * @param
     *
     * @return
     *
     */
    public static function EnterpriseCertificationDotAccountBoss($MemberDate)
    {
        if (empty ($MemberDate) || empty ($MemberDate['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        //老板的信息
        $BossInfor = CompanyMember::where(['CompanyId' => $MemberDate ['CompanyId']])->where(['Role' => MemberRole::Boss])->find();
        // 收信人
        $ToContactsList = [];
        $item = new NoticeContacts ();
        $item->CompanyId = $BossInfor ['CompanyId'];
        $item->PassportId = $BossInfor ['PassportId'];
        $item->MobilePhone = $BossInfor ['MobilePhone'];
        $item->DisplayName = $BossInfor ['RealName'];
        array_push($ToContactsList, $item);
        //公司的名字
        $CompanyName = Company::where(['CompanyId' => $MemberDate ['CompanyId']])->value('CompanyName');
        // 发信人
        $FromContactPassport = ['CompanyId' => 0, 'PassportId' => 0, 'MobilePhone' => 0, 'DisplayName' => 0];
        //事件类型
        $eventCode = EventCode::EnterpriseCertificationDotAccountBoss;
        $noticeArgs = new NoticeArgs();
        $noticeArgs->ToContactsList = $ToContactsList;
        $noticeArgs->FromContacts = $FromContactPassport;
        $noticeArgs->BizType = "";
        $noticeArgs->BizId = $MemberDate['CompanyId'];
        $noticeArgs->EventModel = array(
            'CompanyName' => $CompanyName,
        );
        //print_r($noticeArgs);
        NoticeService::sendNotice($eventCode, $noticeArgs);
    }

    /**公司提交认证资料，给运营中心发送通知短信
     *
     */
    public static function UnderReviewToOperation($CompanyName)
    {
        if ($CompanyName) {
            //运营人员的手机号信息
            $ToOperation = DictionaryPool::getDictionaries('Listeners_UnderReview');
            $text = $CompanyName . '刚刚提交了认证资料，请及时审核';
            if ($ToOperation['Listeners_UnderReview']) {
                foreach ($ToOperation['Listeners_UnderReview'] as $key => $value) {
                    if ($value['Code']) {
                        $MobilePhones[] = $value['Code'];
                        $url = 'http://sdk.entinfo.cn/webservice.asmx/mdSmsSend?sn=SDK-BBX-010-23630&pwd=AF01B559B6B6CD0D1D259CC41B255347&mobile=' .
                            trim($value['Code']) . '&content=' . urlencode(iconv('UTF-8', 'gbk', $text)) . '&ext=&stime=&rrid=&msgfmt';
                        $result = file_get_contents($url);
                    }
                }
                if ($MobilePhones) {
                    $msg_data = array(
                        'CompanyId' => 0,
                        'PassportId' => 0,
                        'FromCompanyId' => 0,
                        'FromPassportId' => 0,
                        'MobilePhone' => implode(",", $MobilePhones),
                        'Content' => $text,
                        'IsRead' => 0,
                        'EventCode' => 0,
                        'BizId' => 0,
                        'BizType' => 0,
                        'SendType' => 'sms');
                    MessageSms::create($msg_data);
                }
            }


        }
    }
}