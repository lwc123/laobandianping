<?php
namespace app\www\controller;
use app\workplace\models\Company;
use think\Config;
use think\Request;
use think\Controller;
use app\workplace\models\Job;
use app\common\modules\DbHelper;
use app\common\modules\DictionaryPool;
use app\www\services\PaginationServices;
use app\workplace\services\JobService;
use app\workplace\models\DictionaryEntry;
use app\workplace\models\CompanyMember;
use app\workplace\models\JobDisplayState;


class JobController extends CompanyBaseController
{
    /**
     * 企业发布职位  修改职位
     * @param Request $request
     * @return mixed
     */
    public function addJob(Request $request){
        $request = $request->param();
       $DictionaryRegion = DictionaryEntry::where('DictionaryId',14)->order('Sequence desc,IsHotspot desc')->select();
        $DictionaryEducation= DictionaryPool::getDictionaries('academic','');
        $DictionaryExperience = DictionaryEntry::where('DictionaryId',23)->order('Sequence asc')->select();
        $this->assign('DictionaryRegion', $DictionaryRegion);
        $this->assign('DictionaryEducation', $DictionaryEducation);
        $this->assign('DictionaryExperience', $DictionaryExperience);
        if(isset($request['JobId'])){
            $Detail = Job::get($request['JobId']);
            $Detail['JobDescription'] = str_replace("<br />", "\n",  $Detail['JobDescription']);
            $this->assign('Detail', $Detail);
            return   $this->fetch('update');
        }else{
            return   $this->fetch('addJob');
        }

    }

    /**
     * 企业发布职位/修改职务 请求
     * @param Request $request
     * @return mixed
     */
    public function add(Request $request){
        $request = $request->param();
        $request['PassportId'] = $this->PassportId;
        if(empty($request['JobId'])) {
            $status = JobService::JobCreate($request);
        }else{
            $status = JobService::JobUpdate ( $request );
        }
        if($status){
            $post = "/Job/jobList?CompanyId=".$request['CompanyId'];
            header ( "location:$post" );
        }

    }

    /**
     * 已有职位
     * @param Request $request
     * @return mixed
     */
    public function jobList(Request $request){
        $JobList = $request->param();
        if ($JobList) {
            $pagination = DbHelper::BuildPagination($request->get("Page"),$request->get("Size"));
            $pagination->TotalCount =  Job::where('Job.CompanyId', $JobList ['CompanyId'])->count();
            $pagination->PageSize=8;
            // echo  $pagination->TotalCount;die;
            $jobList= Job::where('Job.CompanyId', $JobList ['CompanyId'])->order('CreatedTime desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
            //搜索条件 分页
            $urlQuery = "CompanyId=".$JobList['CompanyId'];
            $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery, $request->action());
            $biz_city = DictionaryPool::getDictionaries('city', null);
            foreach($jobList as $key=>$val){
                if(is_float($val['SalaryRangeMin']/1000)){
                    $jobList[$key]['SalaryRangeMin'] = number_format($val['SalaryRangeMin']/1000,1).'k';
                }else{
                    $jobList[$key]['SalaryRangeMin'] = ($val['SalaryRangeMin']/1000).'k';
                }

                if(is_float($val['SalaryRangeMax']/1000)){
                    $jobList[$key]['SalaryRangeMax'] = number_format($val['SalaryRangeMax']/1000,1).'k';
                }else{
                    $jobList[$key]['SalaryRangeMax'] = ($val['SalaryRangeMax']/1000).'k';
                }
                foreach($biz_city['city'] as $k=>$value){
                    if($val['JobCity']==$value['Code']){
                        $jobList[$key]['JobCity'] =$value['Name'];
                    }
                }
                $jobList[$key]['CompanyMember']=CompanyMember::getPassportRoleByCompanyId($JobList ['CompanyId'],$val['PassportId']);
            }
            }
           $this->assign('PageNavigation', $pageNavigation);
           $this->assign('jobList', $jobList);
           return   $this->fetch();
    }

    /**
     * 开启 关闭职位
     * @param Request $request
     */
    public function OpenCloseJob(Request $request)
    {
        $Job = $request->param();
        if($Job['DisplayState'] == JobDisplayState::CloseJob){
            $update = JobService::JobOpenUpdate ( $Job );
        }else{
            $update = JobService::JobCloseUpdate ( $Job );
        }
        return $update;
    }

    /**
     * 删除职位
     * @param Request $request
     * @return bool
     * @throws \think\Exception
     */
    public function DeleteJob(Request $request) {
        $DeleteJob = $request->param();
        if ($DeleteJob) {
            $delete = Job::where ( ['JobId'=>$DeleteJob['JobId']])->delete();
            if($delete){
                return true;
            }else{
                return false;
            }
        };
    }

    /**
     *职位详情
     * @param Request $request
     * @return static
     */
    public function Detail(Request $request) {
        $JobId = $request->param ('JobId');
        if ($JobId) {
            $Detail = Job::get($JobId,['Company']);
            //薪资转换
            if(is_float($Detail['SalaryRangeMin']/1000)){
                $Detail['SalaryRangeMin'] = number_format($Detail['SalaryRangeMin']/1000,1).'k';
            }else{
                $Detail['SalaryRangeMin'] = ($Detail['SalaryRangeMin']/1000).'k';
            }

            if(is_float($Detail['SalaryRangeMax']/1000)){
                $Detail['SalaryRangeMax'] = number_format($Detail['SalaryRangeMax']/1000,1).'k';
            }else{
                $Detail['SalaryRangeMax'] = ($Detail['SalaryRangeMax']/1000).'k';
            }
            //时间转换
            $Detail['time'] =getDealTime($Detail['CreatedTime']);
            $Detail['JobDescription'] = str_replace("<br />", "\n",  $Detail['JobDescription']);
            //字典转换
            $Detail['EducationRequire'] = DictionaryPool::getEntryNames('academic',$Detail['EducationRequire']);
            $Detail['ExperienceRequire'] = DictionaryPool::getEntryNames('Resume_WorkYear',$Detail['ExperienceRequire']);
            $Detail['Company']['CompanySize'] = DictionaryPool::getEntryNames('CompanySize',$Detail['Company']['CompanySize']);
            $Detail['Company']['Region'] = DictionaryPool::getEntryNames('city',$Detail['Company']['Region']);
             //return json($Detail);
            $this->assign('Detail', $Detail);
            return   $this->fetch();
        }
    }
}
