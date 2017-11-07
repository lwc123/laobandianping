<?php

namespace app\workplace\services;

use app\common\modules\DbHelper;
use app\common\modules\DictionaryPool;
use app\workplace\models\ArchiveComment;
use app\workplace\models\Company;
use app\workplace\models\ContractStatus;
use app\workplace\models\Department;
use app\workplace\models\EmployeArchive;
use app\workplace\models\ServiceContract;
use think\Db;
use think\Request;
use app\common\modules\ResourceHelper;
use app\workplace\models\CommentType;
use app\workplace\models\AuditStatus;
use app\workplace\models\MemberRole;
use app\workplace\models\CompanyAuditRequest;
use app\workplace\models\CompanyMember;
use app\workplace\models\EventCode;
use app\workplace\services\NoticeByCompanyAuditService;

class CompanyService
{
    /**修改公司信息
     * @param $Company
     * @return bool
     */
    public static function CompanyUpdate($Company)
    {
        if (empty ($Company) || empty ($Company ['CompanyId'])) {
            exception('非法请求-0', 412);
        }

        // 修改信息date
        $Companydate = [
            'CompanySize' => $Company ['CompanySize'],
            'Industry' => $Company ['Industry'],
            'CompanyAbbr' => $Company ['CompanyAbbr'],
            'Region' => $Company ['Region'],
            'CompanyId' => $Company ['CompanyId']
        ];

        // 公司LOGO
        if (!empty ($Company ['CompanyLogo'])) {
            if (strstr($Company ['CompanyLogo'], Config('resources_site_root')) == false) {
                $Companydate ['CompanyLogo'] = ResourceHelper::SaveAvatar($Company ['CompanyId'], $Company ['CompanyLogo']);
            } else {
                $Companydate ['CompanyLogo'] = str_replace(Config('resources_site_root'), '', $Company ['CompanyLogo']);
            }
        }
        $CompanyUpdate = Company::update($Companydate);
        if ($CompanyUpdate) {
            return true;
        } else {
            return false;
        }
    }

    /**认证公司
     * @param $Company
     * @return bool
     */
    public static function AuditCompany($Company)
    {
        if (empty ($Company) || empty ($Company ['AuditStatus']) || empty ($Company ['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $findcompany = Company::where([
            'CompanyId' => $Company ['CompanyId'],
            'AuditStatus' => AuditStatus::Submited
        ])->find();
        if ($findcompany) {
            //提交人信息
            $ManagerInfo = CompanyMember::where([
                'CompanyId' => $Company ['CompanyId'],
                'Role' => MemberRole::Manager,
                'PassportId' => $findcompany ['PassportId']
            ])->find();
            // 运营后台，认证通过操作
            if ($Company ['AuditStatus'] == AuditStatus::AuditPassed) {

                // 查询法人手机号是否与提交人注册手机号一致
                $LegalMobilePhone = CompanyAuditRequest::where([
                    'CompanyId' => $Company ['CompanyId']
                ])->value('MobilePhone');

                if ($ManagerInfo ['MobilePhone'] != $LegalMobilePhone) {
                    // 创建老板账号
                    $bossdata = [
                        'CompanyId' => $findcompany ['CompanyId'],
                        'RealName' => $findcompany ['LegalName'],
                        'PresenterId' => 0,
                        'JobTitle' => '法人',
                        'MobilePhone' => $LegalMobilePhone,
                        'Role' => MemberRole::Boss
                    ];
                    $BossMemberId = MemberService::MemberAddService($bossdata);

                    if (empty ($BossMemberId)) {
                        return false;
                    }

                } else {
                    // 更新管理员为法人
                    CompanyMember::update([
                        'Role' => MemberRole::Boss,
                        'RealName' => $ManagerInfo ['RealName'],
                        'JobTitle' => $ManagerInfo ['JobTitle'],
                        'CompanyId' => $ManagerInfo ['CompanyId'],
                        'PassportId' => $ManagerInfo ['PassportId'],
                        'MobilePhone' => $ManagerInfo ['MobilePhone'],
                        'MemberId' => $ManagerInfo ['MemberId']
                    ], [
                        'MemberId' => $ManagerInfo ['MemberId']
                    ]);
                }
                // 发短信给提交人(老板)
                $MessageMan = ['CompanyId' => $Company ['CompanyId'], 'PassportId' => $findcompany ['PassportId']];
                NoticeByCompanyAuditService::EnterpriseCertification($MessageMan);

                // 更新公司为已认证
                $tradeJournal = ServiceContract::where(['CompanyId' => $Company ['CompanyId']])->value('TradeCode');
                $serviceEndTime = empty($tradeJournal) ? date("Y-m-d", strtotime("+30 day")) : DbHelper::getMaxDbDate();
                $AuditPassed = Company::update([
                    'AuditStatus' => AuditStatus::AuditPassed,
                    'CompanyId' => $Company ['CompanyId'],
                    'ServiceEndTime' => $serviceEndTime
                ]);
                $AuditRequestPassed = CompanyAuditRequest::where('CompanyId', $Company ['CompanyId'])->update([
                    'AuditStatus' => AuditStatus::AuditPassed
                ]);
                ServiceContract::WHERE('CompanyId', $Company ['CompanyId'])->update([
                    'ServiceBeginTime' => date("Y-m-d H:i:s"),
                    'ContractStatus' => ContractStatus::Servicing,
                    'ServiceEndTime' => $serviceEndTime
                ]);
                //创建默认部门
                $Departments = DictionaryPool::getDictionaries('Department');
                if ($Departments['Department']) {
                    foreach ($Departments['Department'] as $key => $val) {
                        if ($val['Forbidden'] == 0) {
                            $Department = new Department([
                                'CompanyId' => $Company ['CompanyId'],
                                'PresenterId' => 0,
                                'DeptName' => $val['Name']
                            ]);
                            $Department->save();
                        }
                    }
                }
                return true;
            } else {
                // 更新公司为被拒绝,和拒绝理由
                $AuditRejected = Company::update([
                    'AuditStatus' => AuditStatus::AuditRejected,
                    'CompanyId' => $Company ['CompanyId']
                ]);
                $AuditRequestRejected = CompanyAuditRequest::where('CompanyId', $Company ['CompanyId'])->update([
                    'AuditStatus' => AuditStatus::AuditRejected,
                    'RejectReason' => $Company ['RejectReason']
                ]);
                // 给提交人发送通知（企业认证未通过）
                NoticeByCompanyAuditService::EnterpriseCertificationError($findcompany);
                return true;
            }
        } else {
            return false;
        }
    }


    public $EmployedNum;
    const EmployedNum = 'EmployedNum';

    public $DimissionNum;
    const DimissionNum = 'DimissionNum';

    public $StageEvaluationNum;
    const StageEvaluationNum = 'StageEvaluationNum';

    public $DepartureReportNum;
    const DepartureReportNum = 'DepartureReportNum';

    public $increase;
    const increase = 'Increase';

    public $decrease;
    const decrease = 'Decrease';


    public static function Statistics($companyid, $param, $incdec)
    {
        if (empty ($companyid) || empty ($param) || empty ($incdec)) {
            exception('非法请求-0', 412);
        }
        Db::startTrans();
        try {
            if ($incdec == CompanyService::increase) {
                Company::update(['CompanyId'=>$companyid,$param=>array('exp', "$param".'+1')]);
            } else {
                Company::update(['CompanyId'=>$companyid,$param=>array('exp', "$param".'-1')]);
            }
            // 提交事务
            Db::commit();
        } catch (\Exception $e) {
            // 回滚事务
            Db::rollback();
            exception($e->getMessage(), $e->getCode());
        }
        return true;

    }


    /**当前公司在职人数和离职人数,阶段评价和离职报告计算方法
     *
     * @param $companyId
     */
    public static function CalculateCompanyArchive($companyId)
    {
        if ($companyId) {
            Db::startTrans();
            try {
                $archives = EmployeArchive::field('IsDimission,COUNT(ArchiveId) as Number')->where('CompanyId', $companyId)->group('IsDimission')->select();
                $comments = ArchiveComment::field('CommentType,COUNT(CommentId) as Number')->where('CompanyId', $companyId)->where('AuditStatus', AuditStatus::AuditPassed)->group('CommentType')->select();
                $Console ['EmployedNum']=0;
                $Console ['DimissionNum']=0;
                $Console ['StageEvaluationNum']=0;
                $Console ['DepartureReportNum']=0;
                foreach ($archives as $key => $value) {
                    if ($value['IsDimission'] == 0) {
                        $Console ['EmployedNum'] = $value['Number'];
                    }
                    if ($value['IsDimission'] == 1) {
                        $Console ['DimissionNum'] = $value['Number'];
                    }
                }
                foreach ($comments as $keys => $values) {
                    if ($values['CommentType'] == 0) {
                        $Console ['StageEvaluationNum'] = $values['Number'];
                    }
                    if ($values['CommentType'] == 1) {
                        $Console ['DepartureReportNum'] = $values['Number'];
                    }
                }
                $Console['CompanyId']=$companyId;
                Company::update($Console);
                // 提交事务
                Db::commit();
            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                exception($e->getMessage(), $e->getCode());
            }
        }
    }
}