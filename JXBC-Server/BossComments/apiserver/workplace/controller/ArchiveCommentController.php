<?php

namespace app\workplace\controller;

use app\workplace\models\ArchiveComment;
use app\common\controllers\CompanyApiController;
use app\workplace\models\ArchiveCommentLog;
use think\Request;
use think\Db;
use app\workplace\models\Message;
use app\workplace\models\Company;
use app\workplace\models\EmployeArchive;
use app\workplace\services\CommentService;
use app\workplace\models\CompanyMember;
use app\workplace\models\WorkItem;
use app\workplace\models\Department;
use app\workplace\services\NoticeByCommentService;
use app\workplace\models\CommentType;
use app\common\modules\DbHelper;
use app\common\modules\DictionaryPool;

class ArchiveCommentController extends CompanyApiController
{

    /**
     * @SWG\POST(
     * path="/workplace/ArchiveComment/add",
     * summary="添加档案评价/离职报告",
     * description="",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/ArchiveComment")
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(type="integer",format="int64")
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
        // 获取档案评价JSON数据
        $request = $request->put();
        if ($request) {
            // 添加评价
            $request ['PresenterId'] = $this->PassportId;
            $CommentId = CommentService::CommentCreate($request);
            return $CommentId;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/ArchiveComment/MyListByAudit",
     * summary="我提交的(和需要我审核的)评价列表",
     * description=" ",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="AuditStatus",
     * in="query",
     * description="审核状态筛选,0代表所有",
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
     * ref="#/definitions/ArchiveComment"
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
    public function myListByAudit(Request $request)
    {
        $MyList = $request->param();
        if ($MyList) {
            $myCommentList = ArchiveComment::all(function ($query) use ($MyList) {
                $query->where('employe_archive.CompanyId', $MyList ['CompanyId'])->where(function ($query) use ($MyList) {
                    if ($MyList ['AuditStatus'] == 0) {
                        $query->where('AuditStatus', 'gt', 0);
                    } else {
                        $query->where('AuditStatus', $MyList ['AuditStatus']);
                    }
                })->where(function ($query) {
                    $query->where('archive_comment.PresenterId', $this->PassportId)->whereor("FIND_IN_SET($this->PassportId,AuditPersons)");
                })->page($MyList ['Page'], $MyList ['Size'])->order('archive_comment.ModifiedTime desc');
            }, [
                'EmployeArchive'
            ]);
            foreach ($myCommentList as $key => $val) {
                $myCommentList [$key] ['WorkCommentImages'] = [];
                $myCommentList [$key] ['AuditPersons'] = [];
                $myCommentList [$key]['StageSection'] = DictionaryPool::getEntryNames('period', $val['StageSection']);
                $myCommentList [$key] ['OperateRealName'] = CompanyMember::where(['PassportId' => $val['OperatePassportId'], 'CompanyId' => $val['CompanyId']])->value('RealName');
            }
            return $myCommentList;
        }
    }

    /**
     * @SWG\get(
     * path="/workplace/ArchiveComment/Search",
     * summary="查询阶段评价(离职报告)列表",
     * description="姓名模糊搜索",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="CommentType",
     * in="query",
     * description="评价类型，参考枚举CommentType",
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
     * ref="#/definitions/ArchiveComment"
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
        $Comment = $request->param();
        $search = CommentService::CommentSearch($Comment);
        return $search;
    }

    /**
     * @SWG\POST(
     * path="/workplace/ArchiveComment/AuditPass",
     * summary="审核通过",
     * description=" ",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="CommentId",
     * in="query",
     * description="评价ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="IsSendSms",
     * in="query",
     * description="是否发送短信",
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
    public function AuditPass(Request $request)
    {
        $param=$request->param();
        if (isset($param['IsSendSms'])==false){
            $IsSendSms=true;
        }else{
            if ($param['IsSendSms']==='false'||$param['IsSendSms']===0){
                $IsSendSms=false;
            }else{
                $IsSendSms=true;
            }
        }
        return CommentService::AuditPass($request->param('CommentId'), $this->PassportId,$IsSendSms);

    }

    /**
     * @SWG\POST(
     * path="/workplace/ArchiveComment/AuditReject",
     * summary="审核拒绝",
     * description="必须传评价ID和拒绝原因",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/ArchiveComment")
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
    public function AuditReject(Request $request)
    {
        $CommentId = $request->put('CommentId');
        $RejectReason = $request->put('RejectReason');
        if ($CommentId && $RejectReason) {
            $AuditReject = ArchiveComment::get($CommentId);
            if ($AuditReject ['AuditStatus'] == 1) {
                ArchiveComment::update([
                    'CommentId' => $CommentId,
                    'AuditStatus' => 9,
                    'OperatePassportId' => $this->PassportId,
                    'RejectReason' => $RejectReason
                ]);
                // 发送拒绝信息
                NoticeByCommentService::ArchiveCommentToAuditPersonReject($CommentId, $this->PassportId);
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/ArchiveComment/Detail",
     * summary="评价详情(包含档案)",
     * description=" ",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="CommentId",
     * in="query",
     * description="评价ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/ArchiveComment"
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
        $CommentId = $request->param('CommentId');

        if ($CommentId) {
            // TODO:附加档案信息
            $Detail = ArchiveComment::get($CommentId, 'EmployeArchive');
            //处理字典信息
            $Detail['DimissionReasonText'] = DictionaryPool::getEntryNames('leaving', $Detail['DimissionReason']);
            $Detail['WantRecallText'] = DictionaryPool::getEntryNames('panicked', $Detail['WantRecall']);
            $Detail['StageSectionText'] = DictionaryPool::getEntryNames('period', $Detail['StageSection']);
            if ($Detail ['WorkCommentImages']) {
                $WorkCommentImages = explode(",", str_replace(array("[", "]"), "", $Detail ['WorkCommentImages']));
                foreach ($WorkCommentImages as $keys => $value) {
                    $CommentImages [] = Config('resources_site_root') . $value;
                }
                $Detail ['WorkCommentImages'] = $CommentImages;
            } else {
                $Detail ['WorkCommentImages'] = [];
            }
            if ($Detail ['WorkCommentVoice']) {
                $Detail ['WorkCommentVoice'] = Config('resources_site_root') . $Detail ['WorkCommentVoice'];
            }

            $Detail ['AuditPersons'] = explode(",", $Detail ['AuditPersons']);
            $CompanyId = EmployeArchive::where('ArchiveId', $Detail ['ArchiveId'])->value("CompanyId");
            $Detail ['OperateRealName'] = CompanyMember::where(['PassportId' => $Detail['OperatePassportId'], 'CompanyId' => $CompanyId])->value('RealName');
            $WorkItem = WorkItem::get([
                'DeptId' => $Detail ['EmployeArchive'] ['DeptId'],
                'ArchiveId' => $Detail ['EmployeArchive'] ['ArchiveId']
            ]);
            if ($WorkItem) {
                $WorkItem ['Department'] = Department::where('DeptId', $WorkItem ['DeptId'])->value('DeptName');
                $Detail ['EmployeArchive'] ['WorkItem'] = $WorkItem;
            }

            foreach ($Detail ['AuditPersons'] as $keys => $value) {
                $CompanyMember = CompanyMember::where('PassportId', $value)->where('CompanyId', $CompanyId)->find();
                if ($CompanyMember) {
                    $CompanyMember['UnreadMessageNum'] = 0;
                    $Member [] = $CompanyMember;
                } else {
                    $Member = [];
                }
            }
            // return $CompanyMember;
            unset ($Detail ['AuditPersons']);
            $Detail ['AuditPersonList'] = $Member;
            return $Detail;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/ArchiveComment/update",
     * summary="修改档案评价/离职报告",
     * description="",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/ArchiveComment")
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
        // 获取档案评价JSON数据
        $request = $request->put();
        if ($request) {
            // 修改评价，获取修改用户ID
            $request ['PresenterId'] = $this->PassportId;
            $update = CommentService::CommentUpdate($request);
            return $update;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/ArchiveComment/Summary",
     * summary="评价详情",
     * description=" ",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="CommentId",
     * in="query",
     * description="评价ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/ArchiveComment"
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
        $CommentId = $request->param('CommentId');
        if ($CommentId) {
            $Summary = ArchiveComment::get($CommentId);
            if ($Summary ['WorkCommentImages']) {
                $WorkCommentImages = explode(",", str_replace(array(
                    "[",
                    "]"
                ), "", $Summary ['WorkCommentImages']));
                foreach ($WorkCommentImages as $keys => $value) {
                    $CommentImages [] = Config('resources_site_root') . $value;
                }
                $Summary ['WorkCommentImages'] = $CommentImages;
            } else {
                $Summary ['WorkCommentImages'] = [];
            }
            if ($Summary ['WorkCommentVoice']) {
                $Summary ['WorkCommentVoice'] = Config('resources_site_root') . $Summary ['WorkCommentVoice'];
            }
            $Summary ['AuditPersons'] = explode(",", $Summary ['AuditPersons']);
            //审核人姓名
            $CompanyId = EmployeArchive::where('ArchiveId', $Summary ['ArchiveId'])->value("CompanyId");
            $Summary ['OperateRealName'] = CompanyMember::where(['PassportId' => $Summary['OperatePassportId'], 'CompanyId' => $CompanyId])->value('RealName');
            foreach ($Summary ['AuditPersons'] as $keys => $value) {
                $CompanyMember = CompanyMember::where('PassportId', $value)->where('CompanyId', $CompanyId)->find();
                if ($CompanyMember) {
                    $Member [] = $CompanyMember;
                } else {
                    $Member = [];
                }
            }
            unset ($Summary ['AuditPersons']);
            $Summary ['AuditPersonList'] = $Member;
            return $Summary;
        }
    }

    /**
     * @SWG\get(
     * path="/workplace/ArchiveComment/All",
     * summary="此档案所有评价(+报告)列表",
     * description="从H5档案详情页面进入",
     * tags={"ArchiveComment"},
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
     * ref="#/definitions/ArchiveComment"
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
    public function All(Request $request)
    {
        $Comment = $request->param();
        $All = CommentService::CommentAll($Comment);
        return $All;
    }


    /**
     * @SWG\GET(
     * path="/workplace/ArchiveComment/existsStageSection",
     * summary="查看此档案已添加的年份区间评价",
     * description="",
     * tags={"ArchiveComment"},
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
     * type="string"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/ExistsStageSection")
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
    public function existsStageSection(Request $request)
    {
        $existsStageSection = $request->param();
        if ($existsStageSection) {
            $result = CommentService::existsStageSection($existsStageSection);
            return $result;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/ArchiveComment/loglist",
     * summary="评价修改记录列表",
     * description="",
     * tags={"ArchiveComment"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="CommentId",
     * in="query",
     * description="评价ID",
     * required=true,
     * type="string"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/ArchiveCommentLog")
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
    public function loglist(Request $request)
    {
        $param = $request->param();
        if ($param) {
            $result = ArchiveCommentLog::getList($param);
            return $result;
        }
    }
}	

 