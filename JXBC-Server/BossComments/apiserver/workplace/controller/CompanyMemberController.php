<?php

namespace app\workplace\controller;

use app\common\controllers\CompanyApiController;
use app\workplace\models\CompanyMember as CompanyMemberModel;
use app\workplace\models\Message as MessageModel;
use think\Cache;
use think\Db;
use think\Request;
use app\workplace\models\NetCurl;
use app\workplace\models\CompanyMember;
use app\workplace\services\MemberService;
use app\workplace\models\MemberRole;

class CompanyMemberController extends CompanyApiController
{

    /**
     * @SWG\POST(
     * path="/workplace/CompanyMember/add",
     * summary="添加企业成员",
     * description="实现备注:Wait",
     * tags={"CompanyMember"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/CompanyMember"),
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
        // 获取添加授权人JSON数据
        $request = $request->put();
        if ($request) {
            $request ['PresenterId'] = $this->PassportId;
            $Member = MemberService::MemberAddService($request);
            return $Member;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/CompanyMember/update",
     * summary="修改企业成员",
     * description="实现备注:modify",
     * tags={"CompanyMember"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="修改成员",
     * required=true,
     * @SWG\Schema(ref="#/definitions/CompanyMember"),
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
    public function update(Request $request)
    {
        $Memberupdate = $request->put();
        if (empty($Memberupdate)) {
            return false;
        }
        CompanyMember::update([
            'Role' => $Memberupdate ['Role'],
            'RealName' => $Memberupdate ['RealName'],
            'MobilePhone' => $Memberupdate ['MobilePhone'],
            'JobTitle' => $Memberupdate ['JobTitle'],
            'CompanyId' => $Memberupdate ['CompanyId'],
            'PassportId' => $Memberupdate ['PassportId'],
            'MemberId' => $Memberupdate ['MemberId']
        ], [
            'MemberId' => $Memberupdate ['MemberId']
        ]);
        return true;

    }

    /**
     * @SWG\POST(
     * path="/workplace/CompanyMember/delete",
     * summary="删除企业成员",
     * description="实现备注:Delete",
     * tags={"CompanyMember"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="删除成员",
     * required=true,
     * @SWG\Schema(ref="#/definitions/CompanyMember"),
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
    public function delete(Request $request)
    {
        $Memberdelete = $request->put();
        if ($Memberdelete) {
            // 查找此用户是不是此公司老板或管理员
            $findBoss = CompanyMember::where([
                'CompanyId' => $Memberdelete ['CompanyId'],
                'PassportId' => $this->PassportId])->where('Role', 'in', [MemberRole::Boss, MemberRole::Manager])->find();
            // 删除
            if ($findBoss) {
                $delete = CompanyMember::where([
                    'MemberId' => $Memberdelete ['MemberId'],
                    'CompanyId' => $Memberdelete ['CompanyId']
                ])->where('Role', 'in', [MemberRole::Manager, MemberRole::Executives, MemberRole::FilingClerk])->delete();
                if ($delete == 1) {
                    return true;
                }
                return false;
            }
            return false;
        }
        return false;
    }


    /**
     * @SWG\Get(
     * path="/workplace/CompanyMember/CompanyMemberListByCompany",
     * summary="企业授权人列表",
     * description="实现备注:CompanyMemberList",
     * tags={"CompanyMember"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="企业授权人列表",
     * required=true,
     * type="integer",format="int64"
     * ),
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
    public function CompanyMemberListByCompany(Request $request)
    {
        $CompanyId = $request->param('CompanyId');
        if ($CompanyId) {
            // 取出所有成员列表
            $memberlist = CompanyMember::where(['CompanyId' => $CompanyId])->order('Role', 'asc')->select();
            foreach ($memberlist as $key => $value) {
                $memberlist [$key] ['UnreadMessageNum'] = 0;
            }
            return $memberlist;
        }
        return false;
    }
}
