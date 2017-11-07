<?php

namespace app\workplace\services;

use app\workplace\models\Job;
use app\workplace\models\Company;
use think\Db;
use think\Request;
use app\workplace\models\JobDisplayState;

class JobService
{
    /**
     * 企业发布职位  添加
     *
     * @access public
     * @param string $PostJob
     *            数据JSON
     * @return integer
     */
    public static function JobCreate($PostJob)
    {
        if (empty ($PostJob) || empty ($PostJob ['CompanyId']) || empty ($PostJob ['PassportId'])) {
            exception('非法请求-0', 412);
        }
        //删除自定义的属性
        unset($PostJob['CompanyMember']);
        unset($PostJob['Company']);
        unset($PostJob['ExperienceRequireText']);
        unset($PostJob['EducationRequireText']);
        unset($PostJob['JobCityText']);
        //添加发布职位的信息
        $SavePostJob = Job::create($PostJob);
        //返回添加的ID
        return $SavePostJob;
    }

    /**
     *企业发布的职位关闭
     *
     * @access public
     * @param array $JobClose
     * @return boolean
     */
    public static function JobCloseUpdate($JobClose)
    {
        if (empty ($JobClose) || empty ($JobClose ['CompanyId']) || empty ($JobClose ['JobId'])) {
            exception('非法请求-0', 412);
        };
        $JobId = $JobClose ['JobId'];
        // 修改职位显示状态
        $JobCloseUpdate = Job::update(['DisplayState' => JobDisplayState::CloseJob], ['JobId' => $JobId]);
        if ($JobCloseUpdate) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *企业发布的职位开启
     *
     * @access public
     * @param array $JobOpen
     * @return boolean
     */
    public static function JobOpenUpdate($JobOpen)
    {
        if (empty ($JobOpen) || empty ($JobOpen ['CompanyId']) || empty ($JobOpen ['JobId'])) {
            exception('非法请求-0', 412);
        };
        $JobId = $JobOpen ['JobId'];
        // 修改职位显示状态
        $JobOpenUpdate = Job::update(['DisplayState' => JobDisplayState::OpenJob], ['JobId' => $JobId]);
        if ($JobOpenUpdate) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *企业修改职位
     *
     * @access public
     * @param array $PostJob
     * @return boolea
     */
    public static function JobUpdate($PostJob)
    {
        if (empty ($PostJob) || empty ($PostJob ['CompanyId']) || empty ($PostJob ['JobId'])) {
            exception('非法请求-0', 412);
        }
        // $PostJob中只提取职位表信息
        unset($PostJob['CompanyMember']);
        unset($PostJob['Company']);
        unset($PostJob['ExperienceRequireText']);
        unset($PostJob['EducationRequireText']);
        unset($PostJob['JobCityText']);
        $updatePostJob = $PostJob;
        //去掉不能修改的属性
        unset ($updatePostJob ['Company']);
        // 修改职位信息
        $Updatejob = Job::update($updatePostJob);
        if ($Updatejob) {
            return true;
        } else {
            return false;
        }
    }

    /**
     *搜素职位
     *
     * @access public
     * @param array $jobSearch
     * @return array
     */

    public static function JobQueryRequest($jobSearch)
    {
        $JobQueryList = Job::all(function ($query) use ($jobSearch) {

            $jobSearch['Page'] = isset($jobSearch['Page']) ? $jobSearch['Page'] : "1";
            $jobSearch['Size'] = isset($jobSearch['Size']) ? $jobSearch['Size'] : "5";

            if (!empty($jobSearch['JobCity'])) {
                $query = $query->where('Job.JobCity', $jobSearch ['JobCity']);
            }
            if (!empty($jobSearch['Industry'])) {
                $query = $query->where('company.Industry', $jobSearch ['Industry']);
            }
            if (!empty($jobSearch['JobName'])) {
                $query = $query->where('Job.JobName', 'like', '%' . $jobSearch ['JobName'] . '%');
            }
            if (!empty($jobSearch['SalaryRange'])) {
                $SalaryRange = str_replace('k', '000', $jobSearch['SalaryRange']);
                $Salary = explode("-", $SalaryRange);
                list($SalaryRangeMin, $SalaryRangeMax) = $Salary;
                $query = $query->where('SalaryRangeMin', 'egt', $SalaryRangeMin)->where('SalaryRangeMax', 'elt', $SalaryRangeMax);
            }
            $query = $query->where('DisplayState', 0)->order('Job.CreatedTime desc')->page($jobSearch ['Page'], $jobSearch ['Size']);

            return $query;
        }, ['Company']);
        return $JobQueryList;
    }

}
