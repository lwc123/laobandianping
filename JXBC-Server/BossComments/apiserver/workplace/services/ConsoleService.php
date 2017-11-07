<?php
namespace app\workplace\services;

use app\appbase\models\Wallet;
use app\workplace\models\ArchiveComment;
use app\workplace\models\Company;
use app\workplace\models\CompanyBankCard;
use app\workplace\models\CompanyMember;
use app\workplace\models\EmployeArchive;
use app\workplace\models\MemberRole;
use app\workplace\models\Message;
use think\Cache;
use think\Db;

/**工作台服务层
 * Class ConsoleService
 * @package app\workplace\services
 */
class ConsoleService
{

    public static function Console($CompanyId, $PassportId)
    {
        if (empty  ($CompanyId) && empty  ($PassportId)) {
            exception('非法请求-0', 412);
        }
        $Console = Company::cache(true)->find($CompanyId);
        if (empty($Console)) {
            exception('非法请求-0', 412);
        }
        if($Console['ServiceEndTime']&&(substr($Console['ServiceEndTime'],0,4)!='3000')){
            $CurrentServiceEndTime=Company::where('CompanyId',$CompanyId)->value('ServiceEndTime');
            if(strtotime($CurrentServiceEndTime)<strtotime(date("Y-m-d H:i:s"))){
                $Console['ServiceEndTime']=$CurrentServiceEndTime;
            }
        }

        $Console['BossInformation'] = CompanyMember::getBossRoleByCompanyId($CompanyId);
        $Console['MyInformation'] = CompanyMember::getPassportRoleByCompanyId($CompanyId, $PassportId);
        $comments = ArchiveComment::field('CommentType,COUNT(CommentId) as Number')->where(['AuditStatus' => 2, 'CompanyId' => $CompanyId])->group('CommentType')->select();
        foreach ($comments as $key => $value) {
            if ($value['CommentType'] == 0) {
                $Console ['StageEvaluationNum'] = $value['Number'];
            }
            if ($value['CommentType'] == 1) {
                $Console ['DepartureReportNum'] = $value['Number'];
            }
        }
        $Console ['PromptInfo'] = "企业认证信息审核中，\n请耐心等待。联系客服400-815-9166";
        $Console ['UnreadMessageNum'] = Message::where(['ToPassportId' => $PassportId, 'IsRead' => 0])->count('MessageId');
        //获取银行卡信息
        $Console['Wallet'] = Wallet::GetOrganizationWallet($CompanyId);
        $Console['ExistBankCard'] = CompanyBankCard::ExistBankCard($CompanyId,1)['ExistBankCard'];
        return $Console;
    }


}