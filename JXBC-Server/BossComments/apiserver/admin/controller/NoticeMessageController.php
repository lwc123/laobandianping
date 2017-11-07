<?php

namespace app\Admin\controller;
use app\workplace\models\CompanyMember;
use think\Controller;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\Admin\controller\AdminBaseController;
use app\common\modules\DbHelper;
use app\workplace\models\Message;
use app\workplace\models\MessageSms;
use app\admin\services\PaginationServices;



class NoticeMessageController extends AuthenticatedController
{

    /**
     * 企业列表
     * @param Request $request 短信列表
     * @return mixed
     */
    public function SmsList(Request $request)
    {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $pagination->TotalCount=MessageSms::order('CreatedTime desc')->count();
        $SmsList = MessageSms::order('CreatedTime desc')->Page($pagination->PageIndex,$pagination->PageSize)->select();
        //搜索条件
        $seachvalue = "";
        //方法名
        $action = 'SmsList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign('SmsList', $SmsList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        return $this->fetch();
    }

    /**
     * 企业列表
     * @param Request $request 站内信列表
     * @return mixed
     */
    public function MsgList(Request $request)
    {
        $queryParams = $request->get();
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $pagination->TotalCount=Message::order('CreatedTime desc')->count();
        $MsgList = Message::order('CreatedTime desc')->Page($pagination->PageIndex,$pagination->PageSize)->select();
        foreach($MsgList as $key=>$val){
            $MsgList[$key]['Member'] = CompanyMember::getPassportRoleByCompanyId($val['ToCompanyId'], $val['ToPassportId']);
        }
        //搜索条件
        $seachvalue = "";
        //方法名
        $action = 'MsgList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign('MsgList', $MsgList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        return $this->fetch();
    }


}


