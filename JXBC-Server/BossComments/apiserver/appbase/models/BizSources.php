<?php
namespace app\appbase\models;

/**
 * @SWG\Definition()
 */
class BizSources
{  
    /**
     * @SWG\Property(type="string",description="充值")
     */
    public $Deposit;
    const Deposit = "Deposit";

    /**
     * @SWG\Property(type="string",description="提现")
     */
    public $Withdraw;
    const Withdraw = "Withdraw";

    /**
     * @SWG\Property(type="string",description="提现退款")
     */
    public $WithdrawRefund;
    const WithdrawRefund = "WithdrawRefund";
    /**
     * @SWG\Property(type="string",description="开通企业服务")
     */
    public $OpenEnterpriseService;
    const OpenEnterpriseService = "OpenEnterpriseService";

    /**
     * @SWG\Property(type="string",description="企业服务续费（含开户）")
     */
    public $RenewalEnterpriseService;
    const RenewalEnterpriseService = "RenewalEnterpriseService";

    /**
     * @SWG\Property(type="string",description="【分成】开通企业服务")
     */
    public $ShareIncomeForOpenEnterpriseService;
    const ShareIncomeForOpenEnterpriseService = "ShareIncomeForOpenEnterpriseService";

    /**
     * @SWG\Property(type="string",description="开通企业时赠送")
     */
    public $OpenEnterpriseGift;
    const OpenEnterpriseGift = "OpenEnterpriseGift";
    
    /**
     * @SWG\Property(type="string",description="购买背景调查(评价、离职报告)")
     */
    public $BuyBackgroundSurvey;
    const BuyBackgroundSurvey = "BuyBackgroundSurvey";

    /**
     * @SWG\Property(type="string",description="销售背景调查(评价、离职报告)【分成】")
     */
    public $SellBackgroundSurvey;
    const SellBackgroundSurvey = "SellBackgroundSurvey";
    
    /**
     * @SWG\Property(type="string",description="开通个人服务")
     */
    public $OpenPersonalService;
    const OpenPersonalService = "OpenPersonalService";
}