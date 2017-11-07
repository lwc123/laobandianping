<?php

namespace app\Admin\controller;
use think\Controller;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\common\modules\DbHelper;
use app\workplace\models\Company;
use app\workplace\models\CompanyMember;
use app\workplace\models\DrawMoneyRequest;
use app\workplace\models\DrawMoneyAuditStatus;
use app\workplace\services\DrawMoneyRequestService;
use app\Admin\controller\AdminBaseController;
use app\admin\services\PaginationServices;

class DrawMoneyController extends AuthenticatedController {
    /**
     * 提现列表  搜索
     *
     * @param Request $request
     * @return mixed
     */
    public function drawMoneyList(Request $request)
    {
        $queryParams = $request->get();
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        //判断搜索条件是否为空
        $MinSignedUpTime = empty($queryParams['MinSignedUpTime']) ? "" : $queryParams['MinSignedUpTime'];
        $MaxSignedUpTime = empty($queryParams['MaxSignedUpTime']) ? '' : $queryParams['MaxSignedUpTime'];
        $CompanyName = empty($queryParams['CompanyName']) ? "" : $queryParams['CompanyName'];
        $AuditStatus = "";
        if (!isset($queryParams['AuditStatus']) || strlen($queryParams['AuditStatus']) == 0) {
            $AuditStatus = '';
        } else {
            if ($queryParams['AuditStatus'] == DrawMoneyAuditStatus::AuditPassed) {
                $AuditStatus = DrawMoneyAuditStatus::AuditPassed;
            } else {
                $AuditStatus = DrawMoneyAuditStatus::Submited;
            }
        }
        $CompanyList = DrawMoneyRequestService::findDrawMoneyByQuery($queryParams, $pagination);
           //获取用户名
            foreach ($CompanyList as $key => $value) {
                if($value['CompanyId']>0){
                    $CompanyList[$key]['PresenterName'] = CompanyMember::where('PassportId', $value['PresenterId'])->where('CompanyId',$value['CompanyId'])->field('RealName')->find();
                }else{
                    $CompanyList[$key]['PresenterName']  = ['RealName'=>$value['CompanyName']];
               }
           }

        //搜索条件
        $seachvalue = "MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&CompanyName=$CompanyName&AuditStatus=$AuditStatus";
        //方法名
        $action = 'DrawMoneyList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign('CompanyList', $CompanyList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('MinSignedUpTime', $MinSignedUpTime);
        $this->view->assign('MaxSignedUpTime', $MaxSignedUpTime);
        $this->view->assign('CompanyName', $CompanyName);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        $this->view->assign('AuditStatus', $AuditStatus);
        return $this->fetch();
    }

    /**
     * 提现详情
     * @param Request $request 提现ID
     */
    public function Detail(Request $request)
    {
        $ApplyId = $request->get('ApplyId');
        //提现账户详情
        $DrawMoneyDetail = DrawMoneyRequest::find([$ApplyId]);
        $this->view->assign('DrawMoneyDetail', $DrawMoneyDetail);
        return $this->fetch();
    }

    /**
     * 提现确认状态修改
     * @param Request $request 提现ID
     */
    public function ConfirmPaymentState(Request $request)
    {
        $ApplyId = $request->get('ApplyId');
        //提现账户详情
        $DrawMoneyDetail = DrawMoneyRequest::find([$ApplyId]);
        $ConfirmPaymentStateUpdate = DrawMoneyRequest::where ( 'ApplyId', $ApplyId)->update ( ['AuditStatus'=>DrawMoneyAuditStatus::AuditPassed] );
        if($ConfirmPaymentStateUpdate){
            echo 1;
        }else{
            echo 0;
        }
    }

}