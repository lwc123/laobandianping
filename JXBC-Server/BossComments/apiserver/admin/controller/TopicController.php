<?php

namespace app\Admin\controller;
use think\Controller;
use think\View;
use think\Db;
use think\Request;
use app\opinion\services\TopicService;
use app\common\modules\DbHelper;
use app\admin\services\PaginationServices;
use app\opinion\models\Company as OpinionCompany;
use app\opinion\models\Topic;
use app\opinion\models\TopicCompany;

class TopicController extends AdminBaseController
{

    /**
     * 专题列表
     * @return 列表
     */
    public function TopicList(Request $request)
    {
        $TopicList = TopicService::TopicListAll();
        $Topic =[];
        foreach($TopicList as $key =>$val){
            $TopicList[$key]['CompanyCount'] = TopicService::TopicCompanyCount($val['TopicId']);
            if(empty($TopicList[$key]['CompanyCount'])){
                $TopicList[$key]['CompanyCount'] =0;
            }
        }

        $this->view->assign('TopicList', $TopicList);
        return $this->fetch();
    }

    /**
     * 关闭专题
     *
     * @param Request $request
     * @throws \think\Exception
     */
    public function TopicClose(Request $request)
    {
        $TopicId = $request->get('TopicId');
        $TopicList = TopicService::TopicClose($TopicId);
        if ($TopicList) {
            $post = "/Topic/TopicList";
            header("location:$post");
        }
    }

    /**
     * 开启专题
     *
     * @param Request $request
     * @throws \think\Exception
     */
    public function TopicOpen(Request $request)
    {
        $TopicId = $request->get('TopicId');
        $TopicList = TopicService::TopicOpen($TopicId);
        if ($TopicList) {
            $post = "/Topic/TopicList";
            header("location:$post");
        }
    }

    public function addTopic(Request $request)
    {
        return $this->fetch();
    }

    /**  添加 专题方法
     */
    public function addTopicRequest(Request $request)
    {
        $Topic = $request->post();
        $Topic['HeadFigure'] = empty($_FILES["HeadFigure"]['tmp_name']) ? "" : base64EncodeImage($_FILES["HeadFigure"]);
        $Topic['BannerPicture'] = empty($_FILES["BannerPicture"]['tmp_name']) ? "" : base64EncodeImage($_FILES["BannerPicture"]);
        $add = TopicService::TopicAdd($Topic);
        if ($add) {
            $post = "/Topic/TopicList";
            header("location:$post");
        } else {
            $this->error('添加失败');
        }
    }

    /**
     * 修改专题
     * @param Request $request
     * @return mixed
     */
    public function update(Request $request)
    {
        $TopicId= $request->get('TopicId');
        $TopicDetail = TopicService::TopicFind($TopicId);
        $this->assign('TopicDetail', $TopicDetail);
        return $this->fetch();
    }

    /**
     * 修改专题方法
     * @param Request $request
     * @return mixed
     */
    public function updateTopic(Request $request)
    {
        $Topic = $request->post();
        $Topic['BannerPicture'] = empty($_FILES["BannerPicture"]['tmp_name']) ? $Topic['BannerPictureUrl'] : base64EncodeImage($_FILES["BannerPicture"]);
        $Topic['HeadFigure'] = empty($_FILES["HeadFigure"]['tmp_name']) ?$Topic['HeadFigureUrl'] : base64EncodeImage($_FILES["HeadFigure"]);
        unset($Topic['BannerPictureUrl']);
        unset($Topic['HeadFigureUrl']);
        $update = TopicService::TopicUpdate($Topic);
        if ($update) {
            $post = "/Topic/TopicList";
            header("location:$post");
        } else {
            $this->error('修改失败');
        }
    }


    /**
     * 专题添加公司
     * @return 列表
     */
    public function topicCreateList(Request $request)
    {
        $param = $request->get();
        $TopicName= Topic::where('TopicId',$param['TopicId'])->value('TopicName');
        if (!empty($param['CompanyName'])) {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $CompanyName = empty($param['CompanyName']) ? "" : $param['CompanyName'];
        $buildQueryFunc = function() use ($param) {
            $query = OpinionCompany::where('CompanyName', 'like','%'.$param['CompanyName'].'%')->whereOr('CompanyAbbr', 'like','%'.$param['CompanyName'].'%');

            return $query;
        };
        $pagination->TotalCount =  $buildQueryFunc($param)->count();
        $Detail =  $buildQueryFunc()->order('CreatedTime desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
        $seachvalue = "CompanyName=$CompanyName&TopicId=".$param['TopicId'];
        $action = 'topicCreateList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
         $this->view->assign('pageHtml', $pageHtml);

    }else{
            $Detail =[];
        }
        $this->view->assign('TopicList', $Detail);
        $this->view->assign('TopicName', $TopicName);
        return $this->fetch();
    }

    public function addCompanyTopic(Request $request)
    {
        $param = $request->get();
        $IsExist = TopicComPany::where("TopicId",$param['TopicId'])->where("CompanyId",$param['CompanyId'])->find();
        if($IsExist){
            return false;
        }else{
            $reputation = new TopicComPany($param);
            $reputation->allowField(true)->save();
            return true;
            }
    }

    /**
     * 所属专题列表公司
     * @return 列表
     */
    public function topicCompanyList(Request $request)
    {
        $param = $request->get();
        $Detail = Topic::get($param['TopicId']);
        if (empty($Detail)) {
            return null;
        }
        $list= TopicCompany::all(function($query) use ($param){
            $query->where('TopicId',$param['TopicId'])->order('CompanyOrder desc,CreatedTime desc');
        },'Company');
        $Company=[];
        if ($list){
            foreach ($list as $key=>$val){
                $Company[]=$val['Company'];
            }
        }

        $Detail['Companys'] =$Company;
       //return json($Detail);
        $this->view->assign('Detail', $Detail);
        return $this->fetch();
    }

    /**
     * 清除公司专题
     * @param Request $request
     * @return bool
     */
    public function deleteCompanyTopic(Request $request)
    {
        $param = $request->get();
        $IsExist = TopicComPany::where("TopicId",$param['TopicId'])->where("CompanyId",$param['CompanyId'])->delete();
        if($IsExist){
            return true;
        }else{
            return false;
        }
    }
}