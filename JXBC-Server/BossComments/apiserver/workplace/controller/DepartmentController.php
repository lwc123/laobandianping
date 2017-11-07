<?php

namespace app\workplace\controller;
use app\common\controllers\CompanyApiController;
use app\workplace\models\Department;
use think\Request;
use app\workplace\services\DepartmentService;
class DepartmentController extends CompanyApiController {
 	 
	/**
	 * @SWG\POST(
	 * path="/workplace/Department/add",
	 * summary="添加公司部门",
	 * description="",
	 * tags={"Department"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/Department")
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="返回结构",
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
	public function add(Request $request) { 
		$request = $request->put ();
		if ($request) {
			$request ['PresenterId'] = $this->PassportId;
			$Department =DepartmentService::DepartmentCreate($request);
			return $Department;
		}
	}
	
	
	/**
	 * @SWG\POST(
	 * path="/workplace/Department/update",
	 * summary="修改公司部门",
	 * description="",
	 * tags={"Department"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/Department")
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="返回结构",
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
	public function update(Request $request) { 
		$request = $request->put ();
		if ($request) { 
			$Department =DepartmentService::Update($request);
			return $Department;
		}
	}
	 
	
	/**
	 * @SWG\POST(
	 * path="/workplace/Department/delete",
	 * summary="修改公司部门",
	 * description="",
	 * tags={"Department"},
	 * @SWG\Parameter(
	 * name="body",
	 * in="body",
	 * description="",
	 * required=true,
	 * @SWG\Schema(ref="#/definitions/Department")
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="返回结构",
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
	public function delete(Request $request) { 
		$request = $request->put ();
		if ($request) { 
			$Department =DepartmentService::Delete($request);
			return $Department;
		}
	}
 
	/**
	 * @SWG\GET(
	 * path="/workplace/Department/all",
	 * summary="公司部门列表",
	 * description="",
	 * tags={"Department"},
	 * tags={"Department"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="integer"
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="",
	 * @SWG\Schema(ref="#/definitions/Department")
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
	public function all(Request $request) {
		$request = $request->param ();
		if ($request) {
			$Department =DepartmentService::All($request);
			return $Department;
		}
	}
	
}
