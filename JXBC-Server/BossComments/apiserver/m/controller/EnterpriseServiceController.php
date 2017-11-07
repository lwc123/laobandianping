<?php
namespace app\m\controller;
use app\workplace\models\ActivityType;
use app\workplace\models\Company;
use app\workplace\models\CompanyMember;
use think\Config;
use think\Request;
use app\common\controllers\AuthenticatedController;
use app\workplace\services\PriceStrategyService;

class EnterpriseServiceController extends AuthenticatedController
{
    public function _empty()
    {
        return $this->fetch();
    }

    public function OpenService()
    {
        $priceStrategy = PriceStrategyService::CurrentActivity(['ActivityType'=>ActivityType::CompanyOpen, "Version"=>PriceStrategyService::GetLatestVersion()]);

        $this->assign('PriceStrategy', $priceStrategy);
        if($priceStrategy["AndroidPreferentialPrice"] > 0) {
            return $this -> fetch();
        } else {
            return $this -> fetch("createNew");
        }
    }

    public function RenewalService(Request $request)
    {
        $companyId = $request->get("CompanyId");
        if(empty($companyId)) {
            $this->error(401, '没有指定资源的操作权限');
        }

        $company = Company::cache(true)->find($companyId);

        if(empty($company)) {
            $this->error(401, 'Not find the company');
        }

        $priceStrategy = PriceStrategyService::CurrentActivity(['ActivityType'=>ActivityType::CompanyRenewal, "Version"=>PriceStrategyService::GetLatestVersion()]);

        $this->assign('PriceStrategy', $priceStrategy);
        $this->assign('Company', $company);
        $this->assign('Member', CompanyMember::getPassportRoleByCompanyId($companyId, $this->PassportId));
        return $this -> fetch();
    }

    public function ChoicePay()
    {
        $priceStrategy = PriceStrategyService::CurrentActivity(['ActivityType'=>ActivityType::CompanyRenewal, "Version"=>PriceStrategyService::GetLatestVersion()]);

        $this->assign('PriceStrategy', $priceStrategy);
        return $this -> fetch();
    }
}


