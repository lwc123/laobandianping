<?php
namespace app\www\controller;

use app\workplace\models\ArchiveComment;
use app\workplace\models\Company;
use app\workplace\models\Department;
use app\workplace\models\EmployeArchive;
use app\workplace\services\CompanyService;
use app\workplace\services\ConsoleService;
use think\Cache;
use think\Config;
use think\Request;
use think\Controller;

class CompanyDataController extends Controller
{

    /**更新公司所有数据，谨慎操作
     * @return mixed
     */
    public function Console()
    {
        $companys = Company::where(['AuditStatus' => 2])->select();
        foreach ($companys as $keys => $valus) {
            $Console ['EmployedNum'] = 0;
            $Console ['DimissionNum'] = 0;
            $Console ['StageEvaluationNum'] = 0;
            $Console ['DepartureReportNum'] = 0;
            $archives = EmployeArchive::field('ArchiveId,IsDimission,COUNT(ArchiveId) as Number')->where('CompanyId', $valus['CompanyId'])->group('IsDimission')->select();
            $comments = ArchiveComment::field('CommentType,COUNT(CommentId) as Number')->where(['AuditStatus' => 2, 'CompanyId' => $valus['CompanyId']])->group('CommentType')->select();

            foreach ($comments as $key => $value) {
                if ($value['CommentType'] == 0) {
                    $Console ['StageEvaluationNum'] = $value['Number'];
                }
                if ($value['CommentType'] == 1) {
                    $Console ['DepartureReportNum'] = $value['Number'];
                }
            }
            foreach ($archives as $key => $value) {
                if ($value['IsDimission'] == 0) {
                    $Console ['EmployedNum'] = $value['Number'];
                }
                if ($value['IsDimission'] == 1) {
                    $Console ['DimissionNum'] = $value['Number'];
                }
            }

            //更新公司信息
            $companycount = new Company;
            $companycount->save([
                'EmployedNum' => $Console ['EmployedNum'],
                'DimissionNum' => $Console ['DimissionNum'],
                'StageEvaluationNum' => $Console ['StageEvaluationNum'],
                'DepartureReportNum' => $Console ['DepartureReportNum']
            ], ['CompanyId' => $valus['CompanyId']]);
        }


        $archivesAll = EmployeArchive::all();
        foreach ($archivesAll as $keys => $valus) {
            //更新档案信息
            $CommentsNum = 0;
            $CommentsNum = ArchiveComment::where(['AuditStatus' => 2, 'ArchiveId' => $valus['ArchiveId']])->COUNT();
            $EmployeArchivecount = new EmployeArchive;
            $EmployeArchivecount->save([
                'CommentsNum' => $CommentsNum
            ], ['ArchiveId' => $valus['ArchiveId']]);
        }

        //更新各部门人数
        $DepartmentAll = Department::all();
        foreach  ($DepartmentAll as $key => $val) {
            $Departments=0;
            $Departments=EmployeArchive::where(['DeptId'=>$val['DeptId'],'IsDimission'=>0])->count();
            $Departmentcount = new Department;
            $Departmentcount->save([
                'StaffNumber' => $Departments
            ], ['DeptId' => $val['DeptId']]);
        }


        return '所有已认证公司数据更新成功';
    }
}


