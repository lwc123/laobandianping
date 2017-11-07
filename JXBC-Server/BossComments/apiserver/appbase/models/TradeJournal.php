<?php

namespace app\appbase\models;
use think\Config;

/**
 * @SWG\Definition(required={"OwnerId","TradeType","TradeMode","PayWay","BizSource","TotalFee","BizSource","BuyerId"})
 */
class TradeJournal extends Payment
{
    const ActionBizSourceScopes = [
        TradeMode::Action_Buy => [BizSources::OpenPersonalService, BizSources::OpenEnterpriseService, BizSources::BuyBackgroundSurvey],
        TradeMode::Action_Withdraw => [BizSources::Withdraw, BizSources::WithdrawRefund]
    ];

    public static function LoadPersonalTradeHistory($mode, $bizSource, $pagination) {
        $queryBuilder = function() use ($mode, $bizSource, $pagination) {
            $query = TradeJournal::With("PaymentCredential")
                ->where('TradeStatus', TradeStatus::BizCompleted)
                ->where('TradeType', 'in', [TradeType::PersonalToPersonal,TradeType::PersonalToOrganization, TradeType::OrganizationToPersonal]);
            if($mode>TradeMode::All){
                if($mode<=TradeMode::Payout) {
                    $query->where('TradeMode', $mode);
                } else {
                     $query->where('BizSource', 'in', TradeJournal::ActionBizSourceScopes[$mode]);
                }
            }
            if(!empty($bizSource)) {
                $query->where('BizSource', $bizSource);
            }
            return $query;
        };

        $pagination->TotalCount =  $queryBuilder($mode, $bizSource, $pagination)->count();
        $list = $queryBuilder($mode, $bizSource, $pagination)->order ( 'ModifiedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        return $list;
    }

    public static function LoadOrganizationTradeHistory($mode, $bizSource, $pagination) {
        $queryBuilder = function() use ($mode, $bizSource, $pagination) {
            $query = TradeJournal::With("PaymentCredential")
                ->where('TradeStatus', TradeStatus::BizCompleted)
                ->where('TradeType', 'in', [TradeType::OrganizationToOrganization]);
            if($mode>TradeMode::All){
                if($mode<=TradeMode::Payout) {
                    $query->where('TradeMode', $mode);
                } else {
                    $query->where('BizSource', 'in', TradeJournal::ActionBizSourceScopes[$mode]);
                }
            }
            if(!empty($bizSource)) {
                $query->where('BizSource', $bizSource);
            }
            return $query;
        };

        $pagination->TotalCount =  $queryBuilder($mode, $bizSource, $pagination)->count();
        $list = $queryBuilder($mode, $bizSource, $pagination)->order ( 'ModifiedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        return $list;
    }

    public static function FindPersonalTradeHistory($ownerId, $mode, $pagination) {
        $queryBuilder = function() use ($ownerId, $mode, $pagination) {
            $query = TradeJournal::where('OwnerId', $ownerId)
                ->where('TradeStatus', TradeStatus::BizCompleted)
                ->where('TradeType', 'in', [TradeType::PersonalToPersonal,TradeType::PersonalToOrganization,TradeType::OrganizationToPersonal]);
            if($mode>TradeMode::All){
                if($mode<=TradeMode::Payout) {
                    $query->where('TradeMode', $mode);
                } else {
                    $query->where('BizSource', 'in', TradeJournal::ActionBizSourceScopes[$mode]);
                }
            }
            return $query;
        };

        $pagination->TotalCount =  $queryBuilder($ownerId, $mode, $pagination)->count();
        $list = $queryBuilder()->order ( 'ModifiedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        return $list;
    }
    
    public static function FindOrganizationTradeHistory($orgId, $mode, $pagination) {
        $queryBuilder = function() use ($orgId, $mode, $pagination) {
            $query = TradeJournal::where('OwnerId', $orgId)
                ->where('TradeStatus', TradeStatus::BizCompleted)
                ->where('TradeType', 'in', [TradeType::OrganizationToOrganization]);
            if($mode>TradeMode::All){
                if($mode<=TradeMode::Payout) {
                    $query->where('TradeMode', $mode);
                } else {
                    $query->where('BizSource', 'in', TradeJournal::ActionBizSourceScopes[$mode]);
                }
            }
            return $query;
        };

        $pagination->TotalCount =  $queryBuilder($orgId, $mode, $pagination)->count();
        $list = $queryBuilder()->order ( 'ModifiedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();

        return $list;
    }    

    protected function initialize()
    {
        $this->connection = Config::get('db_tradesystem');
    }

    /**
     * @SWG\Property(description="交易状态，参见枚举[TradeStatus]", type="integer")
     */  
    public $TradeStatus;

    /**
     * @SWG\Property(description="业务订单号：开户交易时，就是公司Id, 购买档案交易时，就是购买记录Id", type="string")
     */  
    public $TargetBizTradeCode;

    /**
     * @SWG\Property(description="交易修改时间， 类型[datetime]",type="string", format="date-time")
     */  
    public $ModifiedTime;
    
    public function getTotalFeeAttr($value)
    {
        return parent::getMoneyWithDBUnit($value);
    }
    
    public function setTotalFeeAttr($value)
    {
        return parent::setMoneyWithDBUnit($value);
    }

    // 关联UserProfile
    public function PaymentCredential()
    {
        return $this->hasOne('PaymentCredential','TradeCode');
    }
}