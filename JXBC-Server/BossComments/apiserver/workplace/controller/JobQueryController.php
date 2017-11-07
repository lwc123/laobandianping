<?php

namespace app\workplace\controller;

use think\Controller;
use think\Request;
use app\common\controllers\AuthenticatedApiController;
use app\workplace\services\JobService;
use app\workplace\models\Job;
use app\common\modules\DictionaryPool;

class JobQueryController extends AuthenticatedApiController {
//class JobQueryController  {
    /**
     * @SWG\GET(
     * path="/workplace/JobQuery/Search",
     * summary="搜索职位列表",
     * description="职位名称模糊搜索",
     * tags={"JobQuery"},
     * @SWG\Parameter(
     * name="JobName",
     * in="query",
     * description="职位名称",
     * type="string"
     * ),
     * @SWG\Parameter(
     * name="JobCity",
     * in="query",
     * description="地区",
     * type="string"
     * ),
     * @SWG\Parameter(
     * name="Industry",
     * in="query",
     * description="行业名称",
     * type="string"
     * ),
     * @SWG\Parameter(
     * name="SalaryRange",
     * in="query",
     * description="期望薪资",
     * type="string"
     * ),
     * @SWG\Parameter(
     * name="Page",
     * in="query",
     * description="页码",
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="Size",
     * in="query",
     * description="每页个数",
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * type="array",
     * @SWG\Items(ref="#/definitions/Job")
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
    public function Search(Request $request) {
        $JobQuery = $request->param ();
        $search = JobService::JobQueryRequest ( $JobQuery );
        foreach($search as $key=>$val){
            $search[$key]['EducationRequireText'] = DictionaryPool::getEntryNames('academic',$val['EducationRequire']);
            $search[$key]['ExperienceRequireText'] = DictionaryPool::getEntryNames('Resume_WorkYear',$val['ExperienceRequire']);
            $search[$key]['JobCityText'] = DictionaryPool::getEntryNames('city',$val['JobCity']);
        };
        return $search;
    }

    /**
     * @SWG\get(
     * path="/workplace/JobQuery/Detail",
     * summary="职位详情",
     * description="",
     * tags={"JobQuery"},
     * @SWG\Parameter(
     * name="JobId",
     * in="query",
     * description="发布的职位ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/Job"
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

    public function Detail(Request $request) {
        $JobId = $request->param ('JobId');
        if ($JobId) {
            $Detail =  Job::get($JobId,['Company']);
            $Detail['EducationRequire'] = DictionaryPool::getEntryNames('academic',$Detail['EducationRequire']);
            $Detail['ExperienceRequire'] = DictionaryPool::getEntryNames('Resume_WorkYear',$Detail['ExperienceRequire']);
            $Detail['Company']['CompanySize'] = DictionaryPool::getEntryNames('CompanySize',$Detail['Company']['CompanySize']);
            $Detail['JobCity'] = DictionaryPool::getEntryNames('city',$Detail['JobCity']);
            return $Detail;
        }
    }

}