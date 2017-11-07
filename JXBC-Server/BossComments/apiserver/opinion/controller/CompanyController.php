<?php

namespace app\opinion\controller;

use app\common\controllers\AuthenticatedApiController;
use app\opinion\services\CompanyService;
use think\Request;

class CompanyController extends AuthenticatedApiController
{


    /**
     * @SWG\GET(
     * path="/opinion/Company/index",
     * summary="企业列表",
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
     * ref="#/definitions/Company"
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
        return CompanyService::CompanyList($param);
    }

    /**
     * @SWG\GET(
     * path="/opinion/Company/search",
     * summary="企业搜索，默认返回老东家",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="Keyword",
     * in="query",
     * description="关键字",
     * required=false,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Company"
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
    public function search(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        return CompanyService::SearchList($param);
    }


    /**
     * @SWG\GET(
     * path="/opinion/Company/detail",
     * summary="企业详情(包含所有口碑)",
     * description=" ",
     * tags={"Opinion"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
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
            return CompanyService::Detail($param);
        }
    }

}	

 