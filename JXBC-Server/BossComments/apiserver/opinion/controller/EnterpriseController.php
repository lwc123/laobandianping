<?php

namespace app\opinion\controller;

use app\common\controllers\CompanyApiController;
use app\common\models\ErrorCode;
use app\common\models\Result;
use app\opinion\models\CompanyClaimRecord;
use app\opinion\services\OpinionService;
use app\opinion\services\CompanyService;
use think\Request;

class EnterpriseController extends CompanyApiController
{
    /**
     * @SWG\GET(
     * path="/opinion/Enterprise/opinions",
     * summary="B端口碑列表",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="B端公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="OpinionCompanyId",
     * in="query",
     * description="口碑公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="AuditStatus",
     * in="query",
     * description="默认1显示列表，2隐藏列表",
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
    public function opinions(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        return OpinionService::OpinionList($param);
    }

    /**
     * @SWG\GET(
     * path="/opinion/Enterprise/claim",
     * summary="B端企业认领口碑公司列表",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="B端公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/Company")
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
    public function claim(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return CompanyClaimRecord::CompanyClaimList($param);
        }
    }

    /**
     * @SWG\POST(
     * path="/opinion/Enterprise/hideOpinions",
     * summary="隐藏选中的点评",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="B端公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="OpinionIds",
     * in="query",
     * description="点评数组",
     * required=true,
     * type="string"
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
    public function hideOpinions(Request $request)
    {
        $param = $request->put();
        if (empty($param)){
            return false;
        }
        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return OpinionService::hideOpinions($param);
        }
    }

    /**
     * @SWG\POST(
     * path="/opinion/Enterprise/restoreOpinions",
     * summary="恢复显示选中的点评",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="B端公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="OpinionIds",
     * in="query",
     * description="点评数组",
     * required=true,
     * type="string"
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
    public function restoreOpinions(Request $request)
    {
        $param = $request->put();
        if (empty($param)){
            return false;
        }
        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return OpinionService::restoreOpinions($param);
        }
    }

    /**
     * @SWG\GET(
     * path="/opinion/Enterprise/settings",
     * summary="B端高级设置",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="B端公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="OpinionCompanyId",
     * in="query",
     * description="口碑公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="IsCloseComment",
     * in="query",
     * description="true开启，false关闭",
     * required=true,
     * type="boolean"
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
    public function settings(Request $request)
    {
        $param = $request->param();

        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return CompanyService::Settings($param);
        }
    }

    /**
     * @SWG\POST(
     * path="/opinion/Enterprise/labels",
     * summary="管理口碑公司标签",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="B端公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="OpinionCompanyId",
     * in="query",
     * description="口碑公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="labels",
     * in="query",
     * description="标签数组",
     * required=true,
     * type="string"
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
    public function labels(Request $request)
    {
        $param = $request->put();
        if (empty($param)){
            return false;
        }
        $param['PassportId'] = $this->PassportId;
        if ($param) {
            return CompanyService::Labels($param);
        }
    }


    /**
     * @SWG\POST(
     * path="/opinion/Enterprise/reply",
     * summary="官方回复点评",
     * description="",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/OpinionReply")
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
    public function reply(Request $request)
    {
        $request = $request->put();
        if (empty($request['OpinionId'])) {
            return Result::error(ErrorCode::OpinionId_Empty, '请选择要评论的点评');
        }
        if (empty($request['Content'])) {
            return Result::error(ErrorCode::Content_Empty, '请填写内容');
        }
        return OpinionService::ReplyCreate($request);
    }
}	

 