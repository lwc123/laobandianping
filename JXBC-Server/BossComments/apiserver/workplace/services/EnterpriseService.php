<?php

namespace app\workplace\services;


use app\common\models\Result;
use app\common\modules\PaymentEngine;
use app\common\modules\ChannelApiClient;
use app\common\modules\ServerVisitManager;
use app\opinion\models\CompanyClaimRecord;
use app\workplace\models\EventCode;
use app\workplace\models\InvitedRelationship;
use think\Db;
use think\Log;
use app\appbase\models\TradeStatus;
use app\appbase\models\TradeJournal;
use app\workplace\models\OpenEnterpriseRequest;
use app\workplace\models\Company;
use app\workplace\models\CompanyMember;
use app\workplace\models\CompanyAsset;
use app\workplace\models\ServiceContract;
use app\workplace\models\MemberRole;
use app\appbase\models\UserPassport;
use app\appbase\models\BizSources;
use app\appbase\models\PayWays;
use app\appbase\models\TradeType;
use app\common\modules\DbHelper;
use app\workplace\models\InvitedRegister;
use app\workplace\models\ContractStatus;
use app\workplace\services\NoticeByOpenEnterpriseService;
use app\workplace\services\NoticeBySuccessInternalService;


class EnterpriseService
{
    public static function createNewCompany($openEnterpriseRequest, $passportId)
    {
        if (empty ($openEnterpriseRequest) || !array_key_exists("CompanyName", $openEnterpriseRequest)) {
            exception('非法请求-2', 412);
        }
        $passportMobilePhone = UserPassport::load($passportId)['MobilePhone'];
        return self::processCreateNewCompany($openEnterpriseRequest, null, $passportId, $passportMobilePhone);
    }
    public static function renewalEnterpriseService($tradeJournal) {
        if (empty ($tradeJournal) || empty ($tradeJournal["TradeCode"])) {
            exception('非法请求-0', 412);
        }

        $tradeJournal = TradeJournal::get([
            'TradeCode' => $tradeJournal ["TradeCode"]
        ]);
        if (empty ($tradeJournal)) {
            exception('非法请求-1', 412);
        }

        $companyId = $tradeJournal["OwnerId"];
        if ($tradeJournal ["TradeStatus"] == TradeStatus::BizCompleted) {
            return Result::success(-1);
        } else if ($tradeJournal ["TradeStatus"] != TradeStatus::Paid) {
            exception('非法请求-3', 412);
        }

        $company = Company::cache(true)->find($companyId);
        $member= CompanyMember::getPassportRoleByCompanyId($companyId, $tradeJournal ["BuyerId"]);
        if (empty ($company) || empty ($member)) {
            exception('非法请求-1', 412);
        }

        $openEnterpriseRequest = json_decode($tradeJournal ["CommodityExtension"],true);
        $openEnterpriseRequest["CompanyName"] =  $company['CompanyName'];
        $openEnterpriseRequest["MobilePhone"] =  $member["MobilePhone"];
        $openEnterpriseRequest["RealName"] =  $member['RealName'];
        return self::processRenewalEnterpriseService($tradeJournal, $company, $openEnterpriseRequest);
    }
    public static function openEnterpriseService($tradeJournal)
    {
        if (empty ($tradeJournal) || empty ($tradeJournal ["TradeCode"])) {
            exception('非法请求-0', 412);
        }

        $tradeJournal = TradeJournal::get([
            'TradeCode' => $tradeJournal ["TradeCode"]
        ]);
        if (empty ($tradeJournal)) {
            exception('非法请求-1', 412);
        }

        $openEnterpriseRequest = json_decode($tradeJournal ["CommodityExtension"],true);
        if (empty ($openEnterpriseRequest) || !array_key_exists("CompanyName", $openEnterpriseRequest)) {
            exception('非法请求-2', 412);
        }

        if ($tradeJournal ["TradeStatus"] == TradeStatus::BizCompleted) {
            $company = Company::get([
                'CompanyName' => $openEnterpriseRequest["CompanyName"]
            ]);
            return $company;
        } else if ($tradeJournal ["TradeStatus"] != TradeStatus::Paid) {
            exception('非法请求-3', 412);
        }

        $openEnterpriseRequest["MobilePhone"] = UserPassport::load($tradeJournal ["BuyerId"])['MobilePhone'];
        $inviter = self::loadInviterCodeInfo($openEnterpriseRequest, $tradeJournal["BuyerId"]);
        $company = self::processCreateNewCompany($openEnterpriseRequest, $tradeJournal, $tradeJournal ["BuyerId"], $openEnterpriseRequest["MobilePhone"], $inviter);
        self::processRenewalEnterpriseService($tradeJournal, $company, $openEnterpriseRequest, $inviter);
        return $company;
    }

    /**查找邀请人信息
     * @param $invitecode
     * @return mixed
     */
    public static function loadInviterCodeInfo($openEnterpriseRequest, $passportId)
    {
        /**
         * 邀请开户分成计划
         */
        $inviteCode = null;
        if(!empty($openEnterpriseRequest) && array_key_exists("InviteCode", $openEnterpriseRequest))
            $inviteCode = $openEnterpriseRequest["InviteCode"]; // 默认使用当前邀请码进行分成

        if(empty($inviteCode)) {
            $invitedRelationship = InvitedRelationship::findByPassportId($passportId);
            if(!empty($invitedRelationship)) {
                $inviteCode = $invitedRelationship['InviteCode'];  // 使用最后一次付费邀请邀请码进行分成
            }
        }

        if(!empty($inviteCode)) {
            $inviter = InvitedRegister::where('InviterCode', $inviteCode)->find();
            if (!empty($inviter)) {
                $inviter['InternalChannel'] = 1;//内部渠道 (自主注册企业或用户)
                if ($inviter['CompanyId'] > 0) {
                    $inviter['ShareIncomeTotalFee'] = PaymentEngine::GetCompanyInviteRegisterPrice($inviter['CompanyId']);
                } else {
                    $inviter['ShareIncomeTotalFee'] = PaymentEngine::GetPrivatenessInviteRegisterPrice($inviter['PassportId']);
                    $inviter['InternalPassportId'] = 0;
                }
            }
        }
        if (empty($inviter)) {
            $inviter['InternalChannel'] = 0;
            $inviter['InviterCode'] = $inviteCode;
            $inviter['ShareIncomeTotalFee'] = 0;
            $inviter['PassportId'] = 0;
        }
        return $inviter;
    }
    private static function processCreateNewCompany($openEnterpriseRequest, $tradeJournal, $passportId, $passportMobilePhone, $inviter = null)
    {
        if(empty($inviter)) {
            $inviter = self::loadInviterCodeInfo($openEnterpriseRequest, $passportId);
        }

        $serviceEndTime = empty($tradeJournal) ? date("Y-m-d",strtotime("+30 day")) : DbHelper::getMaxDbDate();
        $company = null;
        Db::startTrans();
        try {
            $company = Company::createNew($openEnterpriseRequest["CompanyName"], $passportId);
            //认领关系创建
            if ($openEnterpriseRequest['OpinionCompanyId'] > 0) {
                $company_claim_record = new CompanyClaimRecord([
                    'CompanyId' => $company ["CompanyId"],
                    'OpinionCompanyId' => $openEnterpriseRequest['OpinionCompanyId'],
                    'PassportId' => $company ["PassportId"]
                ]);
                $company_claim_record->allowField(true)->save();
            }
            // 添加管理员
            $companyMember = new CompanyMember ([
                'CompanyId' => $company ["CompanyId"],
                'Role' => MemberRole::Manager, // admin
                'PassportId' => $company ["PassportId"],
                'RealName' => $openEnterpriseRequest["RealName"],
                'JobTitle' => $openEnterpriseRequest["JobTitle"],
                'MobilePhone' => $passportMobilePhone
            ]);
            $companyMember->allowField(true)->save();

            // 添加企业资产
            $companyAsset = new CompanyAsset ([
                'CompanyId' => $company ["CompanyId"],
                'AssetType' => 1,
                'AssetNum' => -1
            ]);
            $companyAsset->allowField(true)->save();

            // 添加企业合同
            $serviceContract = new ServiceContract ([
                'CompanyId' => $company ["CompanyId"],
                'PassportId' => $company ["PassportId"],
                'ContractStatus' => ContractStatus::NewContract,
                'ServiceBeginTime' => date("Y-m-d H:i:s"),
                'ServiceEndTime' => $serviceEndTime,
                'TradeCode' => empty($tradeJournal) ? null : $tradeJournal ["TradeCode"],
                'PaidWay' => empty($tradeJournal) ? null : $tradeJournal ["PayWay"],
                'TotalFee' => empty($tradeJournal) ? null : $tradeJournal ["TotalFee"]
            ]);
            $serviceContract->allowField(true)->save();

            // 更新公司的渠道与合同信息
            Company::update([
                'ChannelCode' => $inviter["InviterCode"],
                'InternalChannel' => $inviter["InternalChannel"],
                'ContractStatus' => ContractStatus::NewContract,
                'ServiceEndTime' => $serviceEndTime
            ],['CompanyId' =>$company ["CompanyId"]]);

            Db::commit();
        } catch (\Exception $e) {
            Db::rollback();
            exception($e->getMessage(), $e->getCode());
        }

        //给注册人发消息
        $MessageMan = ['CompanyId' => $company["CompanyId"], 'MobilePhone' => $passportMobilePhone, 'RealName' => $openEnterpriseRequest["RealName"], 'PassportId' => $company ["PassportId"]];
        NoticeByOpenEnterpriseService::SuccessfulOpeningAccount($MessageMan);

        return $company;
    }
    private static function processRenewalEnterpriseService($tradeJournal, $company, $openEnterpriseRequest, $inviter = null)
    {
        if(empty($inviter)) {
            $inviter = self::loadInviterCodeInfo($openEnterpriseRequest, $tradeJournal["BuyerId"]);
        }
        $serviceEndTime = DbHelper::getMaxDbDate();

        // 修改企业合同
        $serviceContract = ServiceContract::where('CompanyId',$company["CompanyId"])->order("ContractId desc")->find();
        $serviceContract->save([
                'PassportId' => $tradeJournal["BuyerId"],
                'ContractStatus' => ContractStatus::Servicing,
                'ServiceBeginTime' => date("Y-m-d"),
                'ServiceEndTime' => $serviceEndTime,
                'TradeCode' => $tradeJournal ["TradeCode"],
                'PaidWay' => $tradeJournal ["PayWay"],
                'TotalFee' => $tradeJournal ["TotalFee"]
            ]
        );

        // 更新公司的渠道与合同信息
        Company::update([
            'ChannelCode' => $inviter["InviterCode"],
            'InternalChannel' => $inviter["InternalChannel"],
            'ContractStatus' => ContractStatus::Servicing,
            'ServiceEndTime' => $serviceEndTime
        ],['CompanyId' =>$company["CompanyId"]]);

        if (abs($tradeJournal ["TotalFee"]) <= PaymentEngine::ShareIncomeStartPointForOpenEnterpriseService) {
            Log::info("开户金额" . abs($tradeJournal ["TotalFee"]) . "<=" . PaymentEngine::ShareIncomeStartPointForOpenEnterpriseService . ", 不进行分成和返现");
            return Result::success($serviceContract["ContractId"]);
        }
        if ($inviter["InternalChannel"] == 1) {
            $ownerId = $inviter["CompanyId"];
            $BuyerId= $inviter["PassportId"];
            if (empty($inviter["CompanyId"])) {
                $TradeType = TradeType::OrganizationToPersonal;
                $ownerId = $inviter["PassportId"];
                $inviter["PassportId"]=0;
            } else {
                $TradeType = TradeType::OrganizationToOrganization;
            }
            $post_url = Config('site_root_api') . '/appbase/PaymentService/ShareIncome';
            $post_data ['ParentTradeCode'] = $tradeJournal ["TradeCode"];
            $post_data ['OwnerId'] = $BuyerId;
            $post_data ['TradeType'] = $TradeType;
            $post_data ['PayWay'] = PayWays::System;
            $post_data ['TotalFee'] = $inviter["ShareIncomeTotalFee"];
            $post_data ['CommoditySubject'] = '邀请企业注册获得分成';
            $post_data ['CommoditySummary'] = '邀请公司：' . $openEnterpriseRequest["CompanyName"];
            $post_data ['BizSource'] = BizSources::ShareIncomeForOpenEnterpriseService;
            $post_data ['BuyerId'] = $ownerId;
            $reponse = ServerVisitManager::ServerVisitPost($post_url, $post_data, 1);
            if (empty($reponse) || is_array($reponse)==false || false == array_key_exists('Success', $reponse)) {
                Log::error("/////分成失败 " . json_encode($post_data));//分成失败， 任务重试
            }
            //发分成短信
            if ($inviter["PassportId"]>0) {
                NoticeBySuccessInternalService::SuccessCompanyInter($ownerId, $inviter["PassportId"]);
            } else {
                NoticeBySuccessInternalService::SuccessPersonalInter($ownerId);
            }
        }
        {
            $post_url = Config('site_root_api') . '/appbase/PaymentService/SystemGift';
            $post_data ['ParentTradeCode'] = $tradeJournal ["TradeCode"];
            $post_data ['OwnerId'] = $company["CompanyId"];
            $post_data ['TradeType'] = TradeType::OrganizationToOrganization;
            $post_data ['PayWay'] = PayWays::System;
            $post_data ['TotalFee'] = PaymentEngine::GetOpenEnterpriseGift($company["CompanyId"]);
            $post_data ['CommoditySubject'] = '开通服务返款';
            $post_data ['CommoditySummary'] = '不可提现';
            $post_data ['BizSource'] = BizSources::OpenEnterpriseGift;
            $post_data ['BuyerId'] = 0;
            $reponse = ServerVisitManager::ServerVisitPost($post_url, $post_data, 1);
            if (empty($reponse) || is_array($reponse)==false || false == array_key_exists('Success', $reponse)) {
                Log::error("/////开通服务返款失败 " . json_encode($post_data));//分成失败， 任务重试
            }

            //给渠道发送开户企业信息
            if ($inviter["InternalChannel"] == 0 && !empty($inviter["InviterCode"])) {
                $openedEnterpriseInfo = array(
                    "channel_code" => $inviter["InviterCode"],
                    "channel_name" => "",
                    "business_name" => $openEnterpriseRequest["CompanyName"],
                    "business_id" => $company["CompanyId"],
                    "user_id" => $tradeJournal ["BuyerId"],
                    "user_name" => $openEnterpriseRequest["RealName"],
                    "user_tel" => $openEnterpriseRequest["MobilePhone"],
                    "paytime" => DbHelper::toLocalDateTime($tradeJournal["ModifiedTime"]),
                    "amount" => abs($tradeJournal ["TotalFee"]),
                );
                ChannelApiClient::SendOpenedEnterprise($openedEnterpriseInfo);
            }
        }

        return Result::success($serviceContract["ContractId"]);
    }

}