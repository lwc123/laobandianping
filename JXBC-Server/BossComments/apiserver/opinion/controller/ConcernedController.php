<?php

namespace app\opinion\controller;

use app\common\controllers\AuthenticatedApiController;
use app\opinion\services\CompanyService;
use app\opinion\services\ConcernedService;
use think\Request;

class ConcernedController extends AuthenticatedApiController
{


    /**
     * @SWG\GET(
     * path="/opinion/Concerned/mine",
     * summary="我的关注企业列表",
     * description=" ",
     * tags={"Opinion"},
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
     * ref="#/definitions/ConcernedTotal"
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
    public function mine(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        return ConcernedService::ConcernedList($param);
    }


    /**
     * @SWG\POST(
     * path="/opinion/Concerned/attention",
     * summary="关注/取关企业",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="企业Id",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="boolean")
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
    public function attention(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        return ConcernedService::Concerned($param);
    }


}	

 