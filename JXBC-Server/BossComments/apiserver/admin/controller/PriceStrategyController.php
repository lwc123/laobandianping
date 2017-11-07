<?php

namespace app\Admin\controller;
use think\Controller;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\Admin\controller\AdminBaseController;
use app\admin\services\PriceStrategyService;
use app\admin\services\PaginationServices;
use app\workplace\models\PriceStrategy;


class PriceStrategyController extends AdminBaseController
{

    /**
     * 价格策略(活动特惠)列表
     * @return 列表
     */
    public function activityList(Request $request)
    {
        $ActivityList = PriceStrategy::order('CreatedTime desc')->select();
        $this->view->assign('ActivityList', $ActivityList);
        return $this->fetch();
    }

    /**
     * 关闭活动
     *
     * @param Request $request 价格策略(活动特惠)Id
     * @throws \think\Exception
     */
    public function activityClose(Request $request)
    {
        $ActivityId = $request->get('ActivityId');
        $ActivityList = PriceStrategy::where('ActivityId', $ActivityId)->update(['IsOpen' => 0, 'AuditStatus' => 1]);
        if ($ActivityList) {
            $post = "/PriceStrategy/activityList";
            header("location:$post");
        }
    }

    /**
     * 开启活动
     *
     * @param Request $request 价格策略(活动特惠)Id
     * @throws \think\Exception
     */
    public function activityOpen(Request $request)
    {
        $ActivityId = $request->get('ActivityId');
        $ActivityList = PriceStrategy::where('ActivityId', $ActivityId)->update(['IsOpen' => 1, 'AuditStatus' => 3]);
        if ($ActivityList) {
            $post = "/PriceStrategy/activityList";
            header("location:$post");
        }
    }

    public function addActivity(Request $request)
    {
        return $this->fetch();
    }

    /**  添加 活动 方法
     */
    public function add(Request $request)
    {
        $Activity = $request->post();
        $Activity['ActivityIcon'] = empty($_FILES["ActivityIcon"]['tmp_name']) ? "" : base64EncodeImage($_FILES["ActivityIcon"]);
        $Activity['ActivityHeadFigure'] = empty($_FILES["ActivityHeadFigure"]['tmp_name']) ? "" : base64EncodeImage($_FILES["ActivityHeadFigure"]);
        $Activity['IosActivityHeadFigure'] = empty($_FILES["IosActivityHeadFigure"]['tmp_name']) ? "" : base64EncodeImage($_FILES["IosActivityHeadFigure"]);
        $add = PriceStrategyService::PriceStrategyAdd($Activity);
        if ($add) {
            $post = "/PriceStrategy/activityList";
            header("location:$post");
        } else {
            $this->error('添加失败');
        }

    }

    /**
     * @param Request $request
     * @return mixed
     */
    public function update(Request $request)
    {
        $ActivityId = $request->get('ActivityId');
        $Detail = PriceStrategy::find($ActivityId);
        $this->assign('Detail', $Detail);
        return $this->fetch();
    }

    /**
     * 修改活动方法
     * @param Request $request
     * @return mixed
     */
    public function updateActivity(Request $request)
    {
        $Activity = $request->post();
        $Activity['ActivityIcon'] = empty($_FILES["ActivityIcon"]['tmp_name']) ? $Activity['IconUrl'] : base64EncodeImage($_FILES["ActivityIcon"]);
        $Activity['ActivityHeadFigure'] = empty($_FILES["ActivityHeadFigure"]['tmp_name']) ?$Activity['HeadFigureUrl'] : base64EncodeImage($_FILES["ActivityHeadFigure"]);
        $Activity['IosActivityHeadFigure'] = empty($_FILES["IosActivityHeadFigure"]['tmp_name']) ? $Activity['IosHeadFigureUrl'] : base64EncodeImage($_FILES["IosActivityHeadFigure"]);
        unset($Activity['IconUrl']);
        unset($Activity['HeadFigureUrl']);
        unset($Activity['IosHeadFigureUrl']);
        $update = PriceStrategyService::PriceStrategyUpdate($Activity);
        if ($update) {
            $post = "/PriceStrategy/activityList";
            header("location:$post");
        } else {
            $this->error('修改失败');
        }

    }
}