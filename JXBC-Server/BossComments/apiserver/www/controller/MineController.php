<?php
namespace app\www\controller;

use app\common\models\ErrorCode;
use app\common\models\Result;
use app\common\modules\DbHelper;
use app\workplace\models\ArchiveComment;
use app\workplace\models\CompanyMember;
use app\workplace\models\Company;
use app\workplace\models\Department;
use app\workplace\models\EmployeArchive;
use app\workplace\models\DictionaryEntry;
use app\workplace\models\MemberRole;
use app\workplace\models\WorkItem;
use app\workplace\services\ArchiveService;
use app\workplace\services\CompanyService;
use app\workplace\services\DepartmentService;
use app\common\modules\DictionaryPool;
use app\workplace\validate\IDCard;
use app\www\services\PaginationServices;
use think\Request;
use app\workplace\services\MemberService;

class MineController extends CompanyBaseController
{
    /**
     * 我的评价列表
     * @param Request $request
     * @return mixed
     */
    public function myListByAudit(Request $request)
    {
        $MyList = $request->param();
        if ($MyList) {
            $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
            $pagination->PageSize = 5;
            $seachvalue = 'CompanyId=' . $MyList['CompanyId'];
            $seachvalue .= '&AuditStatus=' . $MyList['AuditStatus'];
            $buildQueryFunc =function () use ($MyList) {
                $query = null;
                $query = ArchiveComment::with('EmployeArchive');
                $query->where('archive_comment.CompanyId', $MyList ['CompanyId'])->where(function ($query) use ($MyList) {
                    if ($MyList ['AuditStatus'] == 0) {
                        $query->where('AuditStatus', 'gt', 0);
                    } else {
                        $query->where('AuditStatus', $MyList ['AuditStatus']);
                    }
                })->where(function ($query) {
                    $query->where('archive_comment.PresenterId', $this->PassportId)->whereor("FIND_IN_SET($this->PassportId,AuditPersons)");
                });
                return  $query;
            };
            $pagination->TotalCount =  $buildQueryFunc($MyList)->count('CommentId');

            $page = PaginationServices::getPagination($pagination, $seachvalue, $request->action());
            $myCommentList =$buildQueryFunc()->order ( 'archive_comment.ModifiedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
           if(!empty($myCommentList)){
               $ArchiveId = [];
               foreach($myCommentList as $key => $val){
                   $ArchiveId[] = $val['ArchiveId'];
               }
               $WorkItem = WorkItem::where('ArchiveId','in', $ArchiveId)->select();
               foreach ($myCommentList as $key => $val) {
                   $myCommentList [$key] ['WorkCommentImages'] = [];
                   $myCommentList [$key] ['AuditPersons'] = [];
                   $myCommentList [$key] ['StageSection'] = DictionaryPool::getEntryNames('period', $val['StageSection']);
                   $myCommentList [$key] ['OperateRealName'] =  CompanyMember::getPassportRoleByCompanyId($val['CompanyId'], $val['OperatePassportId']);
                   foreach ($WorkItem as $keys => $vals) {
                       if($val['ArchiveId'] =$vals['ArchiveId'] ){
                           $myCommentList [$key] ['PostTitle']= $vals['PostTitle'];
                       }
                   }
               }
           }
            $this->assign('myCommentList', $myCommentList);
            $this->assign('page', $page);
            return $this->fetch();
        }
    }

    /**
     * 我的评价详情
     */
    public function myCommentDetail(Request $request)
    {
        return $this->fetch();
    }

    /**
     * 授权管理列表
     */
    public function MemberList(Request $request)
    {
        $CompanyId = $request->param('CompanyId');
        if ($CompanyId) {
            // 取出所有成员列表
            $memberlist = CompanyMember::where([
                'CompanyId' => $CompanyId
            ])->order('Role asc')->select();
            foreach ($memberlist as $key => $value) {
                switch ($value['Role']) {
                    case (MemberRole::Boss):
                        $memberlist [$key] ['RoleName'] = '公司法人';
                        break;
                    case (MemberRole::Manager):
                        $memberlist [$key] ['RoleName'] = '管理员';
                        break;
                    case (MemberRole::Executives):
                        $memberlist [$key] ['RoleName'] = '高管';
                        break;
                    case (MemberRole::FilingClerk):
                        $memberlist [$key] ['RoleName'] = '建档员';
                        break;
                }
            }
            $this->assign('memberlist', $memberlist);
            return $this->fetch();
        }
    }

    /**
     * 添加或者修改授权人
     * @param Request $request
     * @return Result
     */
    public function addMember(Request $request)
    {
        $Memberupdate = $request->put();
        if ($Memberupdate) {
            //添加
            if(empty($Memberupdate['MemberId'])){
                $Memberupdate ['PresenterId'] = $this->PassportId;
                $Member = MemberService::MemberAddService($Memberupdate);
                return $Member;
            }else{
                $Member = CompanyMember::update([
                        'Role' => $Memberupdate ['Role'],
                        'RealName' => $Memberupdate ['RealName'],
                        'JobTitle' => $Memberupdate ['JobTitle'],
                        'CompanyId' => $Memberupdate ['CompanyId'],
                        'PassportId' => $Memberupdate ['PassportId'],
                        'MemberId' => $Memberupdate ['MemberId']
                    ], [
                        'MemberId' => $Memberupdate ['MemberId']
                    ]);
                if($Member){
                    return array('Success'=>true);
                }else{
                    return array('Success'=>flase,'ErrorMessage'=>'修改失败');
                }
            }
        }
    }

    /**
     * 删除授权人
     * @param Request $request
     * @return bool
     * @throws \think\Exception
     */
    public function deleteMember(Request $request)
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
     * 部门管理
     */
    public function departmentList(Request $request)
    {
        $request = $request->param();
        if ($request) {
            $Department = DepartmentService::All($request);
            $this->assign('Department', $Department);
            return $this->fetch();
        }
    }

    /**
     * 部门管理 添加或者修改部门
     */
    public function adddepartment(Request $request)
    {
        $request = $request->put ();
        if ($request) {
            if(empty($request['DeptId'])){
                //添加
                $request ['PresenterId'] = $this->PassportId;
                $Department =DepartmentService::DepartmentCreate($request);
            }else{
               //修改
                $Department =DepartmentService::Update($request);
            }
            return $Department;

        }
    }

    /**
     * 删除部门
     * @param Request $request
     * @return Result
     */
    public function deletedepartment(Request $request) {
        $request = $request->put ();
        if ($request) {
            $Department =DepartmentService::Delete($request);
            return $Department;
        }
    }

    /**
     * 修改企业信息
     * @param Request $request
     * @return Result
     */
    public function companyUpdate(Request $request) {
        $CompanyId = $request->get('CompanyId');
        $CompanyInfo = Company::where("CompanyId", $CompanyId)->find();
        $DictionaryIndustry = DictionaryPool::getDictionaries('industry','');
        $DictionaryCompanySize = DictionaryPool::getDictionaries('CompanySize','');
        $DictionaryRegion = DictionaryEntry::where('DictionaryId',14)->order('Sequence desc,IsHotspot desc')->select();

        $this->assign('CompanyInfo', $CompanyInfo);
        $this->assign('DictionaryIndustry', $DictionaryIndustry);
        $this->assign('DictionaryCompanySize', $DictionaryCompanySize);
        $this->assign('DictionaryRegion', $DictionaryRegion);
        return $this->fetch();
    }

    /**
     * 修改企业信息 请求
     * @param Request $request
     * @return Result
     */
    public function updateCompanyRequest(Request $request) {
        // 获取员工档案JSON数据
        $request = $request->post();
        if($request){
            $CompanyLogo = empty($_FILES["CompanyLogo"]['tmp_name']) ? '' : base64EncodeImage($_FILES["CompanyLogo"]);
            if (empty($CompanyLogo)) {
                unset($request['CompanyLogo']);
            } else {
                $request['CompanyLogo'] = $CompanyLogo;
            }
            $request ['ModifiedId'] = $this->PassportId;
            $update = CompanyService::CompanyUpdate($request);
            return  $update;
        }

    }







}