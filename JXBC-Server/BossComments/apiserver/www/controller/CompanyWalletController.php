<?php
namespace app\www\controller;
use app\appbase\models\TradeMode;
use app\appbase\models\TradeJournal;
use app\common\modules\DbHelper;
use think\Config;
use think\Request;
use think\Controller;
use app\www\services\PaginationServices;

class CompanyWalletController extends CompanyBaseController
{
    public function Index(Request $request)
    {
        $mode = $request->get("mode");
        if(!isset ($mode)) {
            $mode = TradeMode::All;
        }
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $urlQuery = "CompanyId=".$request->get("CompanyId")."&mode=".$mode;


        $tradeHistroy = TradeJournal::FindOrganizationTradeHistory($this->CurrentCompanyId, $mode, $pagination);
        if(!empty($tradeHistroy)) {
            $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery, $request->action());
            $this->view->assign('PageNavigation', $pageNavigation);
        }

        $this->view->assign('TradeMode', $mode);
        $this->view->assign('TradeHistroy', $tradeHistroy);
        $this->view->assign('Pagination', $pagination);

        return $this->fetch();
    }
}


