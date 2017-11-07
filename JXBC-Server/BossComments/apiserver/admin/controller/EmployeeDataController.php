<?php

namespace app\Admin\controller;
use app\io\models\EmployeeEntity;
use app\io\models\EmployerEntity;
use app\io\models\PersonEntity;
use app\io\providers\EmployeeIOProvider;
use think\Controller;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\common\modules\DbHelper;
use app\admin\services\PaginationServices;

class EmployeeDataController extends AuthenticatedController {

    public function PersonList(Request $request) {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $list = EmployeeIOProvider::queryPerson($request->get(), $pagination);
        
        //搜索条件
        $seachvalue = empty($request->get('MobilePhone'))&&empty($request->get('RealName')) ? "" : "MobilePhone=".$request->get('MobilePhone')."&RealName=".$request->get('RealName');
        //方法名
        $action = 'PersonList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign ( 'List', $list );
        $this->view->assign ( 'PageHtml', $pageHtml );
        $this->view->assign ( 'Pagination',  $pagination);
        return  $this->fetch();
    }

    public function PersonDetail(Request $request) {
        $personId = $request->get("PersonId");
        $entity = PersonEntity::find($personId);
        
        $workHitory = EmployeeEntity::where('PersonId', $personId)->select();

        $this->view->assign ( 'Entity', $entity );
        $this->view->assign ( 'WorkHitory', $workHitory );
        return  $this->fetch();
    }

    public function EmployerList(Request $request) {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        $list = EmployeeIOProvider::queryEmployer($request->get(), $pagination);

        //搜索条件
        $seachvalue = empty($request->get('CompanyName')) ? "" : "CompanyName=".$request->get('CompanyName');
        //方法名
        $action = 'EmployerList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign ( 'List', $list );
        $this->view->assign ( 'PageHtml', $pageHtml );
        $this->view->assign ( 'Pagination',  $pagination);
        return  $this->fetch();
    }

    public function EmployerDetail(Request $request) {
        $employerId = $request->get("EmployerId");
        $entity = EmployerEntity::find($employerId);
        
        $this->view->assign ( 'Entity', $entity );
        return  $this->fetch();
    }

    public function EmployeeList(Request $request) {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $list = EmployeeIOProvider::queryEmployee($request->get(), $pagination);
        
        $seachvalue = "EmployerId=".$request->get('EmployerId');
        //方法名
        $action = 'EmployeeList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
        
        $this->view->assign ( 'List', $list );
        $this->view->assign ( 'PageHtml', $pageHtml );
        $this->view->assign ( 'Pagination',  $pagination);
        return  $this->fetch();
    }

    public function ColleagueList(Request $request) {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $list = EmployeeIOProvider::queryColleague($request->get(), $pagination);
        
        $seachvalue = "PersonId=".$request->get('PersonId')."&EmployerId=".$request->get('EmployerId');
        //方法名
        $action = 'ColleagueList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
        
        $this->view->assign ( 'List', $list );
        $this->view->assign ( 'PageHtml', $pageHtml );
        $this->view->assign ( 'Pagination',  $pagination);
        return  $this->fetch();
    }
}


