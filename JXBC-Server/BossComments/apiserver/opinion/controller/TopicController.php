<?php

namespace app\opinion\controller;

use app\opinion\services\TopicService;
use think\Request;

class TopicController
{
    /**
     * @SWG\GET(
     * path="/opinion/Topic/index",
     * summary="专题列表",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Topic"
     * )
     * ),
     * @SWG\Response(
     * response="412",
     * description="参数不符合要求",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function index()
    {
        return TopicService::TopicList();
    }

    /**
     * @SWG\GET(
     * path="/opinion/Topic/detail",
     * summary="专题详情(包含所有公司)",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="TopicId",
     * in="query",
     * description="专题ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页码",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页个数",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Topic"
     * )
     * ),
     * @SWG\Response(
     * response="412",
     * description="参数不符合要求",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function detail(Request $request)
    {
        $param = $request->param();
        if ($param) {
            return TopicService::Detail($param);
        }
    }
}	

 