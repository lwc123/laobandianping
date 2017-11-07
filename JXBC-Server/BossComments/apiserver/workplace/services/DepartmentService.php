<?php

namespace app\workplace\services;

use app\workplace\models\ArchiveComment;
use app\workplace\models\EmployeArchive;
use app\workplace\models\Message;
use think\Cache;
use think\Db;
use think\Request;
use app\workplace\models\Department;
use app\common\models\Result;
use app\common\models\ErrorCode;


class DepartmentService
{
    const CacheName = "Department";
    const CacheExpire = 24 * 60 * 60;

    public static function DepartmentCreate($Department)
    {
        if (empty ($Department) || empty ($Department ['DeptName']) || empty ($Department ['CompanyId'])) {
            exception('非法请求-0', 412);
        }

        //查询是否存在这个部门
        $findDepartment = Department::where(['DeptName' => $Department ['DeptName'], 'CompanyId' => $Department ['CompanyId']])->find();

        if (empty($findDepartment)) {
            $saveDepartment = Department::create($Department);
            $department_key = DepartmentService::CacheName . '-' . $Department ['CompanyId'];
            Cache::rm($department_key);
            return Result::success($saveDepartment['DeptId']);
        } else {
            return Result::error(ErrorCode::DepartmentExist, '部门已存在');
        }
    }


    public static function Update($Department)
    {
        if (empty ($Department) || empty ($Department ['DeptId']) || empty ($Department ['CompanyId'])) {
            exception('非法请求-0', 412);
        }

        //查询是否存在这个部门
        $findDepartment = Department::where(['DeptName' => $Department ['DeptName'], 'CompanyId' => $Department ['CompanyId']])->find();
        if ($findDepartment) {
            return Result::error(ErrorCode::DepartmentExist, '部门已存在');
        }
        $update = Department::update(['DeptName' => $Department ['DeptName'], 'DeptId' => $Department ['DeptId']]);
        $department_key = DepartmentService::CacheName . '-' . $Department ['CompanyId'];
        Cache::rm($department_key);
        if ($update) {
            return Result::success();
        } else {
            return Result::error(ErrorCode::ModifyFailed, '修改失败');
        }
    }


    public static function Delete($Department)
    {
        if (empty ($Department) || empty ($Department ['DeptId']) || empty ($Department ['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $StaffNumber = Department::where(['DeptId' => $Department ['DeptId'], 'CompanyId' => $Department ['CompanyId']])->value('StaffNumber');
        if ($StaffNumber > 0) {
            return Result::error(ErrorCode::DepartmentCannotDelete, '该部门下有员工档案，暂不能删除');
        } else {
            if (is_null($StaffNumber)) {
                return Result::error(ErrorCode::DepartmentIsDelete, '该部门已删除');
            }
            Department::destroy($Department ['DeptId']);
            $department_key = DepartmentService::CacheName . '-' . $Department ['CompanyId'];
            Cache::rm($department_key);
            return Result::success();
        }

    }

    /**API暂时还在用，==替换成缓存方法
     * @param $Department
     * @return false|\PDOStatement|string|\think\Collection
     */

    public static function All($Department)
    {
        if (empty ($Department) || empty ($Department ['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $list = Department::where(['CompanyId' => $Department ['CompanyId']])->select();
        return $list;
    }


    /**部门列表缓存
     * @param $companyId
     * @return mixed
     */
    public static function getDepartmentListByCompanyId($companyId)
    {
        $department_key = DepartmentService::CacheName . '-' . $companyId;
        $DepartmentList = Cache::get($department_key);
        if (empty($DepartmentList)) {
            $DepartmentList = Department::where(['CompanyId' => $companyId])->order('StaffNumber>0 desc,DeptId')->select();
            if ($DepartmentList) {
                Cache::set($department_key, $DepartmentList, DepartmentService::CacheExpire);
            }
        }
        return $DepartmentList;
    }

    /**部门当前在职人数计算方法,修改档案时调取
     *
     * @param $companyId
     */
    public static function CalculateDepartmentStaffNumber($companyId)
    {
        if ($companyId) {
            Db::startTrans();
            try {
                $Departmentcount = new Department;
                $department_list = Department::where('CompanyId', $companyId)->field('DeptId')->select();
                $archives = EmployeArchive::field('DeptId,COUNT(ArchiveId) as Number')->where(['CompanyId' => $companyId, 'IsDimission' => 0])->group('DeptId')->select();
                $Departments = [];
                foreach ($department_list as $key => $val) {
                    $Departments[$key]['DeptId'] = $val['DeptId'];
                    $Departments[$key]['StaffNumber'] = 0;
                    foreach ($archives as $k => $v) {
                        if ($v['DeptId'] == $val['DeptId']) {
                            $Departments[$key]['StaffNumber'] = $v['Number'];
                        }
                    }
                }
                $Departmentcount->saveAll($Departments);
                $department_key = DepartmentService::CacheName . '-' . $companyId;
                Cache::rm($department_key);
                // 提交事务
                Db::commit();
            } catch (\Exception $e) {
                // 回滚事务
                Db::rollback();
                exception($e->getMessage(), $e->getCode());
            }
        }
    }
}	
 