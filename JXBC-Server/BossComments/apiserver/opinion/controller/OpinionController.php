<?php

namespace app\opinion\controller;

use app\common\controllers\AuthenticatedApiController;
use app\common\models\ErrorCode;
use app\common\models\Result;
use app\opinion\models\Liked;
use app\opinion\services\OpinionService;
use think\Request;

class OpinionController extends AuthenticatedApiController
{
    /**
     * @SWG\GET(
     * path="/opinion/Opinion/index",
     * summary="口碑列表",
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
     * ref="#/definitions/OpinionTotal"
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
    public function index(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        return OpinionService::OpinionList($param);
    }

    /**
     * @SWG\GET(
     * path="/opinion/Opinion/mine",
     * summary="我的口碑列表",
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
     * ref="#/definitions/OpinionTotal"
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
        return OpinionService::myOpinionList($param);
    }

    /**
     * @SWG\POST(
     * path="/opinion/Opinion/create",
     * summary="添加公司点评（口碑）",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/Opinion")
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/Result")
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
    public function create(Request $request)
    {
        $request = $request->put();
        if (empty($request['CompanyId'])) {
            return Result::error(ErrorCode::CompanyId_Empty, '请选择要点评的公司');
        }
        $request['PassportId']=$this->PassportId;
        return OpinionService::OpinionCreate($request);
    }




    /**
     * @SWG\POST(
     * path="/opinion/Opinion/liked",
     * summary="点赞/取消赞",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="OpinionId",
     * in="query",
     * description="点评ID",
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
    public function liked(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return Liked::Liked($param);
        }
    }

    /**
     * @SWG\GET(
     * path="/opinion/Opinion/detail",
     * summary="口碑详情(包含所有评论)",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="OpinionId",
     * in="query",
     * description="点评ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Opinion"
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
        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return OpinionService::OpinionDetail($param);
        }
    }

}	

 