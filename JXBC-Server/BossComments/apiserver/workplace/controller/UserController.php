<?php

namespace app\workplace\controller;

use app\common\controllers\AuthenticatedApiController;
use app\workplace\models\ArchiveComment;
use app\workplace\models\AuditStatus;
use app\workplace\models\CompanyMember;
use app\workplace\models\Version;
use app\workplace\services\EnterpriseService;
use think\Config;
use think\Request;
use app\workplace\models\Company;

/**
 * @SWG\Tag(
 * name="User",
 * description="用户公司身份,验证公司是否存在API"
 * )
 */
class UserController extends AuthenticatedApiController
{
    /**
     * @SWG\Get(
     * path="/workplace/User/myRoles",
     * summary="公司身份列表",
     * description="",
     * tags={"User"},
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(
     * type="array",
     * @SWG\Items(ref="#/definitions/CompanyMember")
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

    public function myRoles()
    {
        $myRoles = CompanyMember::all(['company_member.PassportId' => $this->PassportId], ['myCompany']);
        if ($myRoles) {
            foreach ($myRoles as $keys => $value) {
                $myRoles [$keys] ['UnreadMessageNum'] = 0;
            }
            $UnreadMessageNum = ArchiveComment::field('CompanyId,COUNT(CommentId) as UnreadMessageNum')->where("FIND_IN_SET($this->PassportId,AuditPersons)")->where(['AuditStatus' => AuditStatus::Submited])->group('CompanyId')->select();
            foreach ($myRoles as $keys => $value) {
                foreach ($UnreadMessageNum as $key => $val) {
                    if ($value['CompanyId'] === $val['CompanyId']) {
                        $myRoles [$keys] ['UnreadMessageNum'] = $val['UnreadMessageNum'];
                    }
                }
            }
            return $myRoles;
        } else {
            //Config::set('default_return_type',"html");
            return [];
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/User/existsCompany",
     * summary="查看公司名是否存在",
     * description="true表示公司存在",
     * tags={"User"},
     * @SWG\Parameter(
     * name="CompanyName",
     * in="query",
     * description="公司名全称",
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
    public function existsCompany(Request $request)
    {
        $CompanyName = $request->param('CompanyName');
        $existsCompany = Company::where('CompanyName', $CompanyName)->find();
        if ($existsCompany) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * @SWG\POST(
     *     path="/workplace/User/createNewCompany",
     *     summary="(免费)开户",
     *     tags={"User"},
     *     @SWG\Parameter(
     *         name="body",
     *         in="body",
     *         description="开户信息",
     *         required=true,
     *         @SWG\Schema(ref="#/definitions/OpenEnterpriseRequest"),
     *     ),
     *     @SWG\Response(
     *         response=200,
     *         description="公司信息",
     *         @SWG\Schema(ref="#/definitions/Company")
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function createNewCompany(Request $request)
    {
        $request = $request->put();
        if ($request) {
            return EnterpriseService::createNewCompany($request, $this->PassportId);
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/User/existsVersion",
     * summary="检测是否有新版本",
     * tags={"User"},
     * @SWG\Parameter(
     * name="VersionCode",
     * in="query",
     * description="版本号",
     * required=true,
     * type="string"
     * ),
     * @SWG\Parameter(
     * name="AppType",
     * in="query",
     * description="操作系统：android或ios",
     * required=true,
     * type="string"
     * ),
     * @SWG\Response(
     *         response=200,
     *         description="版本信息",
     *         @SWG\Schema(ref="#/definitions/Version")
     *     ),
     *     @SWG\Response(
     *         response="412",
     *         description="不符合预期的输入参数",
     *         @SWG\Schema(
     *             ref="#/definitions/Error"
     *         )
     *     )
     * )
     */
    public function existsVersion(Request $request)
    {
        $request = $request->param();
        if ($request) {
            return Version::getVersion($request);
        }
    }
}