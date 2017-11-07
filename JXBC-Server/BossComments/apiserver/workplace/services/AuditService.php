<?php

namespace app\workplace\services;

use app\workplace\models\Company;
use app\workplace\models\CompanyAuditRequest;
use app\workplace;
use think\Request;
use think\db;
use app\workplace\validate\CompamyAudit;
use app\workplace\validate\AuditRequest;
use app\common\modules\ResourceHelper;

class AuditService
{
    public static function AuditRequest($request)
    {
        if (empty ($request) || empty ($request ['Company'] ['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $AuditInfo = CompanyAuditRequest::where('CompanyId', $request ['Company'] ['CompanyId'])->find();

        if ($AuditInfo) {
            // 身份证图片
            //身份证2.1不用上传
            if (isset($request ['Images']) && !empty($request ['Images'])) {
                foreach ($request ['Images'] as $keys => $value) {
                    if (strstr($value, Config('resources_site_root')) == false) {
                        $LegalImages [] = ResourceHelper::SaveOpenEnterpriseRequestImage($request ['Company'] ['CompanyId'], $value);
                    } else {
                        // 新数据和数据库比较
                        $value = str_replace(Config('resources_site_root'), '', $value);
                        if ($value != $AuditInfo ['Images'] [$keys]) {
                            $LegalImages [] = str_replace($AuditInfo ['Images'] [$keys], '', $value);
                        }
                    }
                }
            } else {
                $LegalImages = [];
            }

            // 营业执照
            if (strstr($request ['Licence'], Config('resources_site_root')) == false) {
                $Licence = ResourceHelper::SaveOpenEnterpriseRequestImage($request ['Company'] ['CompanyId'], $request ['Licence']);
            } else {
                $Licence = str_replace(Config('resources_site_root'), '', $request ['Licence']);
            }
        } else {
            //身份证2.1不用上传
            if (isset($request ['Images']) && !empty($request ['Images'])) {
                foreach ($request ['Images'] as $value) {
                    $LegalImages [] = ResourceHelper::SaveOpenEnterpriseRequestImage($request ['Company'] ['CompanyId'], $value);
                }
            } else {
                $LegalImages = [];
            }
            // 营业执照
            $Licence = ResourceHelper::SaveOpenEnterpriseRequestImage($request ['Company'] ['CompanyId'], $request ['Licence']);
        }

        // /////////////////提取数据/验证开始//////////////
        $Companydata = [
            'CompanyName' => $request ['Company'] ['CompanyName'], // 企业全称
            'CompanyAbbr' => $request ['Company'] ['CompanyAbbr'], // 企业简称
            'Industry' => $request ['Company'] ['Industry'], // 所属行业
            'CompanySize' => $request ['Company'] ['CompanySize'], // 企业规模
            'Region' => $request ['Company'] ['Region'], // 所在地区
            'LegalName' => $request ['Company'] ['LegalName'], // 法人姓名
            'CompanyId' => $request ['Company'] ['CompanyId'], // 法人姓名
            'AuditStatus' => 1
        ];

        $AuditRequestdate = [
            'Licence' => $Licence, // 营业执照
            'MobilePhone' => $request ['MobilePhone'], // 法人手机号
            'Images' => '[' . implode(',', $LegalImages) . ']', // 身份证照片
            'AuditStatus' => 1
        ];

        // //////////////提取数据/验证结束/////////////////////

        // ///判断开户时企业名称和认证时填写的企业名称是否相同，不相同判断企业名称是否开户

        // 开户企业名称
        $openCompanyName = Company::where('CompanyId', $request ['Company'] ['CompanyId'])->value('CompanyName');

        // 认证企业名称
        $auditCompanyName = $request ['Company'] ['CompanyName'];
        NoticeByCompanyAuditService::UnderReviewToOperation($auditCompanyName);
        if ($openCompanyName != $auditCompanyName) {
            $opencompany = Company::get([
                'CompanyName' => $auditCompanyName
            ]);
            if ($opencompany) {
                exception('您输入的公司已开通服务！请联系该公司管理员', 412);
            } else {
                // 更新公司信息
                Company::update($Companydata);
                // 查看有无认证信息
                $ApplyId = CompanyAuditRequest::where('CompanyId', $request ['Company'] ['CompanyId'])->value('ApplyId');
                if ($ApplyId) {
                    // 更新公司认证信息
                    CompanyAuditRequest::where('ApplyId', $ApplyId)->update($AuditRequestdate);
                    return true;
                } else {
                    // 新建公司认证信息

                    $AuditRequestdate ['CompanyId'] = $request ['Company'] ['CompanyId'];
                    $AuditRequestdate ['ApplicantId'] = $request ['ApplicantId'];
                    CompanyAuditRequest::create($AuditRequestdate);
                    return true;
                }
            }
        } else {
            // 更新公司信息
            Company::update($Companydata);
            // 查看有无认证信息
            $ApplyId = CompanyAuditRequest::where('CompanyId', $request ['Company'] ['CompanyId'])->value('ApplyId');

            if ($ApplyId) {
                // 更新公司认证信息
                $success = CompanyAuditRequest::where('ApplyId', $ApplyId)->update($AuditRequestdate);
                if ($success) {
                    return true;
                }

            } else {
                // 新建公司认证信息

                $AuditRequestdate ['CompanyId'] = $request ['Company'] ['CompanyId'];
                $AuditRequestdate ['ApplicantId'] = $request ['ApplicantId'];

                CompanyAuditRequest::create($AuditRequestdate);
                return true;
            }
        }
    }
}