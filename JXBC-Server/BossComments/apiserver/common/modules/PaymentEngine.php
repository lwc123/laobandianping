<?php

namespace app\common\modules;
use think\Config;

class PaymentEngine {
    const ShareIncomeStartPointForOpenEnterpriseService = 800;

	public static function GetOpenPrivatenessServicePrice() {
        return 20;
	}
    
	public static function GetStageEvaluationPrice($companyId, $archiveId) {
        return 20;
	}
	
	public static function GetDepartureReportPrice($companyId, $archiveId) {
		return 30;
	}
	
	public static function GetCompanyInviteRegisterPrice($companyId) {
		return 1000;
	}
	
	public static function GetPrivatenessInviteRegisterPrice($passportId) {
		return 400;
	}

    public static function GetOpenEnterpriseGift($companyId) {
        return 3000;
    }
}
