<?php

namespace app\workplace\controller;


use app\common\controllers\CompanyApiController;
use app\common\models\ErrorCode;
use app\common\models\Result;
use app\workplace\services\DepartmentService;
use app\workplace\validate\IDCard;
use think\Request;
use app\workplace\models\Department;
use app\workplace\services\ArchiveService;
use app\workplace\models\EmployeArchive;
use app\workplace\models\WorkItem;
use app\workplace\models\ArchiveComment;
use app\workplace\models\CommentType;
use app\common\modules\DictionaryPool;

class EmployeArchiveController extends CompanyApiController
{

    /**
     * @SWG\GET(
     * path="/workplace/EmployeArchive/existsIDCard",
     * summary="验证身份证是否存在",
     * description="",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="IDCard",
     * in="query",
     * description="身份证号",
     * required=true,
     * type="string"
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
    public function existsIDCard(Request $request)
    {
        $existsIDCard = $request->param();
        if ($existsIDCard) {
            $result = ArchiveService::Fundidcard($existsIDCard);
            return $result;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/EmployeArchive/add",
     * summary="添加档案",
     * description="",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/EmployeArchive")
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
    public function add(Request $request)
    {
        // 获取员工档案JSON数据
        $request = $request->put();
        // return $request;
        if ($request) {
            $IDCard = $request['IDCard'];
            if ($IDCard) {
                $checkIDCard = IDCard::validateIDCard($IDCard);
                if ($checkIDCard == false) {
                    return Result::error(ErrorCode::Wrongful_IDCard, '请检查身份证号填写是否正确');
                }
            } else {
                return Result::error(ErrorCode::Empty_IDCard, '请填写身份证信息');
            }
            $request ['PresenterId'] = $this->PassportId;
            $addarchive = ArchiveService::ArchiveCreate($request);
            return $addarchive;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/EmployeArchive/Detail",
     * summary="档案详情(包含职务)",
     * description=" ",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="ArchiveId",
     * in="query",
     * description="档案ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/EmployeArchive"
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
    public function Detail(Request $request)
    {
        $request = $request->param();
        if ($request) {
            $Detail = ArchiveService::Detail($request);
            $Detail['EducationText'] = DictionaryPool::getEntryNames('academic', $Detail['Education']);
            return $Detail;
        }
    }


    /**
     * @SWG\GET(
     * path="/workplace/EmployeArchive/Summary",
     * summary="档案详情",
     * description=" ",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="ArchiveId",
     * in="query",
     * description="档案ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/EmployeArchive"
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
    public function Summary(Request $request)
    {
        $ArchiveId = $request->param('ArchiveId');
        if ($ArchiveId) {
            $Archive = EmployeArchive::get($ArchiveId);
            return $Archive;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/EmployeArchive/update",
     * summary="修改档案",
     * description="",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/EmployeArchive")
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
    public function update(Request $request)
    {
        // 获取员工档案JSON数据
        $request = $request->put();
        // return $request;die;
        if ($request) {
            $request ['ModifiedId'] = $this->PassportId;
            $addarchive = ArchiveService::ArchiveUpdate($request);
            return $addarchive;
        }
    }

    /**
     * @SWG\get(
     * path="/workplace/EmployeArchive/Search",
     * summary="查询员工档案列表",
     * description="姓名模糊搜索",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="RealName",
     * in="query",
     * description="员工姓名",
     * required=true,
     * type="string"
     * ),
     * @SWG\Parameter(
     *    name="Page",
     *    in="query",
     *    description="页码",
     *    required=true,
     *    type="integer"
     *    ),
     * @SWG\Parameter(
     *    name="Size",
     *    in="query",
     *    description="每页个数",
     *    required=true,
     *    type="integer"
     *    ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/EmployeArchive"
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
        $Archive = $request->param();
        $search = ArchiveService::ArchiveSearch($Archive);
        return $search;
    }

    /**
     * @SWG\GET(
     * path="/workplace/EmployeArchive/EmployeList",
     * summary="企业档案列表",
     * description="
     * Departments 为部门数组列表（取出部门ID，名称，人数，排序），
     * EmployeArchives 为档案数组列表（取出头像，姓名，评价数，部门ID），
     * WorkItem 为档案当前职务信息（取出职务，入职时间） ",
     * tags={"EmployeArchive"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="string"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/EmployeArchiveList"
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
    public function EmployeList(Request $request)
    {
        $CompanyId = $request->param('CompanyId');

        if ($CompanyId) {
            $employelist = [];
            // 取出部门列表
            $employelist ['Departments'] = DepartmentService::getDepartmentListByCompanyId($CompanyId);
            // 取出档案列表
            $employelist ['ArchiveLists'] = EmployeArchive::with('WorkItem')->where('CompanyId', $CompanyId)->group('employe_archive.ArchiveId')->having('employe_archive.DeptId=WorkItem.DeptId')->order('IsDimission asc,DeptId desc,CreatedTime asc')->select();
            if ($employelist ['ArchiveLists']) {
                //取出所有离职报告
                $ArchiveComments = ArchiveComment::where(['CommentType' => CommentType::DepartureReport, 'CompanyId' => $CompanyId])->group('ArchiveId')->select();
                foreach ($employelist ['ArchiveLists'] as $key => $value) {
                    $employelist ['ArchiveLists'] [$key] ['DepartureReportNum'] = 0;
                    foreach ($employelist ['Departments'] as $v) {
                        if ($employelist ['ArchiveLists'] [$key] ['DeptId'] == $v['DeptId']) {
                            $employelist ['ArchiveLists'] [$key] ['WorkItem'] ['Department'] = $v['DeptName'];
                        }
                    }

                    foreach ($ArchiveComments as $k => $val) {
                        if ($employelist ['ArchiveLists'][$key]['ArchiveId'] == $val['ArchiveId']) {
                            $employelist ['ArchiveLists'] [$key] ['DepartureReportNum'] = 1;
                        }
                    }
                }
            }
            return $employelist;
        } else {
            return false;
        }
    }

}