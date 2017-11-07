<?php

namespace app\workplace\controller;
use think\Controller;
use app\common\controllers\CompanyApiController;
use app\workplace\models\CompanyMember;
use think\Db;
use think\Request;
use think\Model;
use app\workplace\models\Job;
use app\workplace\models\JobDisplayState;
use app\workplace\services\JobService;
use app\common\modules\DictionaryPool;


class JobController extends CompanyApiController {

    /**
     * @SWG\POST(
     * path="/workplace/Job/add",
     * summary="企业发布职位",
     * description="",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * @SWG\Schema(ref="#/definitions/Job")
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
    public function Add(Request $request) {
        $PostJobArray = $request->put ();
        if ($PostJobArray) {
            $PostJobArray ['PassportId'] = $this->PassportId;
            if($PostJobArray['CompanyId']==19){
                $PostJobArray ['DisplayState'] =  JobDisplayState::CloseJob;
            }else{
                $PostJobArray ['DisplayState'] =  JobDisplayState::OpenJob;
            }
            $status = JobService::JobCreate ( $PostJobArray );
            if($status){
                return $status['JobId'];
            }
        }
    }


    /**
     * @SWG\get(
     * path="/workplace/Job/Detail",
     * summary="职位详情",
     * description="",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
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
            $Detail = Job::get($JobId,['Company']);
            $Detail['EducationRequireText'] = DictionaryPool::getEntryNames('academic',$Detail['EducationRequire']);
            $Detail['ExperienceRequireText'] = DictionaryPool::getEntryNames('Resume_WorkYear',$Detail['ExperienceRequire']);
            $Detail['JobCityText'] = DictionaryPool::getEntryNames('city',$Detail['JobCity']);
            return  $Detail;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/Job/update",
     * summary="编辑职位",
     * description="",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/Job")
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
    public function Update(Request $request) {
        // 获取公司的ID
        $request = $request->put ();
        if ($request) {
            // 修改职位，获取修改用户ID
            $request ['PassportId'] = $this->PassportId;
            if($request['CompanyId']==19){
                $request ['DisplayState'] =  JobDisplayState::CloseJob;
            }else{
                $request ['DisplayState'] =  JobDisplayState::OpenJob;
            }
            $update = JobService::JobUpdate ( $request );
            return $update;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/Job/JobList",
     * summary="公司所发布的职位",
     * description=" ",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
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
    public function JobList(Request $request)
    {
        $JobList = $request->param();
        if ($JobList) {
            $jobList= Job::where('CompanyId', $JobList ['CompanyId'])->order('CreatedTime desc')->page($JobList['Page'],$JobList['Size'])->select();
            $biz_city = DictionaryPool::getDictionaries('city');
            foreach($jobList as $key=>$val){
                foreach($biz_city['city'] as $k=>$value){
                    if($val['JobCity']==$value['Code']){
                        $jobList[$key]['JobCity'] =$value['Name'];
                    }
                    $jobList[$key]['CompanyMember']=CompanyMember::getPassportRoleByCompanyId($JobList ['CompanyId'],$val['PassportId']);
                }
            }
            return $jobList;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/Job/CloseJob",
     * summary="关闭职位",
     * description="",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="JobId",
     * in="query",
     * description="发布职位的ID",
     * required=true,
     * type="integer"
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
    public function CloseJob(Request $request) {
        // 获取公司的职位ID
        $CloseJob = $request->param();
        if ($CloseJob) {
            $update = JobService::JobCloseUpdate ( $CloseJob );
            return $update;
        };
    }

    /**
     * @SWG\POST(
     * path="/workplace/Job/OpenJob",
     * summary="开启职位",
     * description="",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="JobId",
     * in="query",
     * description="发布职位的ID",
     * required=true,
     * type="integer"
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
    public function OpenJob(Request $request) {
        $OpenJob = $request->param();
        if ($OpenJob) {
            if($OpenJob['CompanyId']==19){
                return false;
            }
            $update = JobService::JobOpenUpdate ( $OpenJob );
            return $update;
        };
    }

    /**
     * @SWG\GET(
     * path="/workplace/Job/DeleteJob",
     * summary="删除职位",
     * description="",
     * tags={"Job"},
     * @SWG\Parameter(
     * name="CompanyId",
     * in="query",
     * description="公司ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Parameter(
     * name="JobId",
     * in="query",
     * description="发布职位的ID",
     * required=true,
     * type="integer"
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




}