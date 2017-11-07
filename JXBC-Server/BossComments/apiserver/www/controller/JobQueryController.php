<?php
namespace app\www\controller;
use app\workplace\models\DictionaryEntry;
use app\common\modules\DictionaryPool;
use app\workplace\models\Job;
use think\Request;
use think\Config;
use think\Controller;
use app\common\modules\DbHelper;
use app\www\services\PaginationServices;

class JobQueryController extends PrivatenessBaseController
{
    public function index(Request $request)
    {
        $jobSearch = $request->param ();
        //搜索查询
        $queryBuilder=  function () use ($jobSearch) {
           $query = null;
           $query = Job::with('Company');
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
               // $SalaryRange = str_replace('k', '000', $jobSearch['SalaryRange']);
               if($jobSearch['SalaryRange']=='5000'){
                   $jobSearch['SalaryRange'] ='3000-5000';
               }
               if($jobSearch['SalaryRange']=='50000以上'){
                   $jobSearch['SalaryRange'] ='50000-999999999999';
               }
               $Salary = explode("-", $jobSearch['SalaryRange']);
               list($SalaryRangeMin, $SalaryRangeMax) = $Salary;
               $query = $query->where('SalaryRangeMin', 'egt', $SalaryRangeMin)->where('SalaryRangeMax', 'elt', $SalaryRangeMax);
           }
            $query =  $query->where('DisplayState',0);
           return $query;
        };
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $pagination->TotalCount =  $queryBuilder($jobSearch)->count();
        $JobQueryList = $queryBuilder()->order ( 'Job.CreatedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
        //搜索条件 分页
        $urlQuery = "JobCity=".$request->get("JobCity")."&Industry=".$request->get("Industry")."&JobName=".$request->get("JobName")."&SalaryRange=".$request->get("SalaryRange");
        $pageNavigation = PaginationServices::getPagination($pagination, $urlQuery, $request->action());
        $this->view->assign('PageNavigation', $pageNavigation);
        //字典转换
        $DictionaryIndustry = DictionaryPool::getDictionaries('industry','');
        $DictionarySalary = DictionaryPool::getDictionaries('salary','');
        $DictionaryRegion = DictionaryEntry::where('DictionaryId',14)->order('Sequence desc,IsHotspot desc')->select();
        $academic=  DictionaryPool::getDictionaries('academic', '');
        $Resume_WorkYear =  DictionaryPool::getDictionaries('Resume_WorkYear','');
        foreach($JobQueryList as $key=>$val){
            foreach($academic['academic'] as $k=>$value){
                if( $val['EducationRequire'] == $value['Code'] ){
                    $JobQueryList[$key]['EducationRequire'] = $value['Name'];
                }
            }
            foreach($Resume_WorkYear['Resume_WorkYear'] as $k=>$value){
                if( $val['ExperienceRequire'] == $value['Code'] ){
                    $JobQueryList[$key]['ExperienceRequire'] = $value['Name'];
                }
            }
         //薪资转换
            if(is_float($val['SalaryRangeMin']/1000)){
                $JobQueryList[$key]['SalaryRangeMin'] = number_format($val['SalaryRangeMin']/1000,1).'k';
            }else{
                $JobQueryList[$key]['SalaryRangeMin'] = ($val['SalaryRangeMin']/1000).'k';
            }

            if(is_float($val['SalaryRangeMax']/1000)){
                $JobQueryList[$key]['SalaryRangeMax'] = number_format($val['SalaryRangeMax']/1000,1).'k';
            }else{
                $JobQueryList[$key]['SalaryRangeMax'] = ($val['SalaryRangeMax']/1000).'k';
            }
            //时间转换
            $JobQueryList[$key]['time'] =getDealTime($val['CreatedTime']);
        }
        //字典
        $this->assign('JobQueryList', $JobQueryList);
        $this->assign('DictionaryIndustry', $DictionaryIndustry);
        $this->assign('DictionarySalary', $DictionarySalary);
        $this->assign('DictionaryRegion', $DictionaryRegion);
       //  return json_decode($JobQueryList);
        return $this->fetch ();
    }
    /**
     *
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
            //  return json($Detail);
            $this->assign('Detail', $Detail);
            return   $this->fetch();
        }
    }
}


