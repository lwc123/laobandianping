<?php

namespace app\apppage\controller;
use app\common\controllers\PageController;
use app\common\modules\HttpHelper;
use app\workplace\models\ActivityType;
use app\workplace\models\PriceStrategy;
use app\workplace\services\PriceStrategyService;
use think\Request;


class CompanyController extends PageController {
    public function _empty()
    {
        return $this->fetch();
    }

    public function RenewalEnterpriseService(Request $request)
    {
        $isIOSRequest = $request->get("os") == "ios";
        $version = $request->get("Version");
        $currentActivity = PriceStrategyService::CurrentActivity(['ActivityType'=>ActivityType::CompanyRenewal, "Version"=>$version]);
        $this->view->assign( 'CurrentActivity', $currentActivity );
        $this->view->assign( 'OriginalPrice', $isIOSRequest ? $currentActivity["IosOriginalPrice"] : $currentActivity["AndroidOriginalPrice"] );
        $this->view->assign( 'PreferentialPrice', $isIOSRequest ? $currentActivity["IosPreferentialPrice"] : $currentActivity["AndroidPreferentialPrice"] );
        $this->view->assign( 'ActivityHeadFigure', $isIOSRequest ? $currentActivity["IosActivityHeadFigure"] : $currentActivity["ActivityHeadFigure"] );
        $this->view->assign( 'ActivityDescription', $isIOSRequest ? $currentActivity["IosActivityDescription"] : $currentActivity["AndroidActivityDescription"] );
        $this->view->assign( 'ActivityIcon', $currentActivity["ActivityIcon"] );
        return $this->fetch();
    }
}


