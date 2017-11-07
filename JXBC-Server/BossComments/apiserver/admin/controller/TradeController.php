<?php

namespace app\Admin\controller;
use think\Request;
use app\common\modules\DbHelper;
use app\appbase\models\TradeMode;
use app\appbase\models\TradeJournal;
use app\admin\services\PaginationServices;



class TradeController extends AuthenticatedController
{

    /**
     * 交易列表
     * @return mixed
     */
    public function CompanyTradeHistory(Request $request)
    {
        $mode = $request->get("mode");
        $bizSource =  $request->get("BizSource");
        if(!isset ($mode)) {
            $mode = TradeMode::All;
        }
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $urlQuery = "mode=$mode&bizSource=$bizSource";

        $tradeHistroy = TradeJournal::LoadOrganizationTradeHistory($mode, $bizSource, $pagination);
        if(!empty($tradeHistroy)) {
            $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery, $request->action());
            $this->view->assign('PageNavigation', $pageNavigation);
        }

        $this->view->assign('TradeMode', $mode);
        $this->view->assign('TradeHistroy', $tradeHistroy);
        $this->view->assign('Pagination', $pagination);
        $this->view->assign('pageHtml', PaginationServices::getPagination($pagination,$urlQuery,$request->action()));

        return $this->fetch();
    }

    /**
     * 交易列表
     * @return mixed
     */
    public function PrivatenessTradeHistory(Request $request)
    {
        $mode = $request->get("mode");
        $bizSource =  $request->get("BizSource");
        if(!isset ($mode)) {
            $mode = TradeMode::All;
        }
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $urlQuery = "mode=$mode&bizSource=$bizSource";

        $tradeHistroy = TradeJournal::LoadPersonalTradeHistory($mode, $bizSource, $pagination);
        if(!empty($tradeHistroy)) {
            $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery, $request->action());
            $this->view->assign('PageNavigation', $pageNavigation);
        }

        $this->view->assign('TradeMode', $mode);
        $this->view->assign('TradeHistroy', $tradeHistroy);
        $this->view->assign('Pagination', $pagination);
        $this->view->assign('pageHtml', PaginationServices::getPagination($pagination,$urlQuery,$request->action()));

        return $this->fetch();
    }
}


