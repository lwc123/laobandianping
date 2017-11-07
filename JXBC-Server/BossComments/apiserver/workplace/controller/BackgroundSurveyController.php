<?php
namespace app\workplace\controller;

use app\workplace\models\ArchiveComment;
use app\workplace\models\BoughtCommentRecord;
use app\common\controllers\CompanyApiController;
use think\Request;
use app\workplace\models\EmployeArchive;
use app\workplace\services\BackgroundSurveyService;
use app\workplace\models\Company;

class BackgroundSurveyController  extends  CompanyApiController{

    /**
     * @SWG\GET(
     * path="/workplace/BackgroundSurvey/Purchased",
     * summary="已购买的背景调查记录",
     * description=" ",
     * tags={"BackgroundSurvey"},
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
     * ref="#/definitions/BoughtCommentRecord"
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
    public function Purchased(Request $request) {
        $list =$request->param ();
        if ($list) {
            $IDCardlist=BoughtCommentRecord::with('EmployeArchive')->where(['bought_comment_record.CompanyId' => $list['CompanyId']])->group('IDCard')->select();
            //return $IDCardlist;
            $list = BoughtCommentRecord::with('EmployeArchive,Company')->where(['bought_comment_record.CompanyId' => $list['CompanyId']])->group('ArchiveCompanyId')->group('ArchiveId')->select();
            $RealName=[];
            foreach ($IDCardlist as $key => $val) {
                $companys=[];
                $RealName[$key]['RealName'] = $val['EmployeArchive']['RealName'];
                foreach ($list as $k => $v) {
                    if ($RealName[$key]['RealName']==$v['EmployeArchive']['RealName']){
                        $companys[]=$v;
                        foreach ($companys as $keys =>$value){
                            $companys[$keys]['StageEvaluationNum']=$this->StageEvaluationNum($value['CompanyId'],$value['ArchiveId']);
                        }
                        unset($v['EmployeArchive']);
                    }
                }
                $RealName[$key]['companys']=json_decode( json_encode( $companys),true);
            }
            return $RealName;
        }
    }

    public function StageEvaluationNum($CompanyId,$ArchiveId) {
        $Stage=BoughtCommentRecord::where(['CompanyId' => $CompanyId,'ArchiveId' => $ArchiveId,'BoughtStageEvaluation' => 1])->find();
        $StageEvaluation=0;
        if($Stage){
            $StageEvaluation=ArchiveComment::where(['ArchiveId'=>$ArchiveId,'CommentType'=>0,'AuditStatus'=>2])->count('CommentId');
        }
        return $StageEvaluation;
    }


	/**
	 * @SWG\GET(
	 * path="/workplace/BackgroundSurvey/BoughtList",
	 * summary="已购买的背景调查记录（1.0版本）",
	 * description=" ",
	 * tags={"BackgroundSurvey"},
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
	 * ref="#/definitions/BoughtCommentRecord"
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
	public function BoughtList(Request $request) {
		$list =$request->param (); 
		if ($list) {
			$list=BoughtCommentRecord::where(['CompanyId'=>$list['CompanyId']])->group('ArchiveCompanyId')->group('ArchiveId')->order('CreatedTime desc')->select();
			foreach ($list as $key =>$val){
				$list[$key]['ArchiveCompanyName']=Company::where(['CompanyId'=>$val['ArchiveCompanyId']])->value('CompanyName');
				$list[$key]['RealName']=EmployeArchive::where(['ArchiveId'=>$val['ArchiveId']])->value('RealName');
			} 
			return $list;
		}
	}

	
	/**
	 * @SWG\GET(
	 * path="/workplace/BackgroundSurvey/Search",
	 * summary="查询背景调查报告",
	 * description=" ",
	 * tags={"BackgroundSurvey"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="integer"
	 * ), 
	 * @SWG\Parameter(
	 * name="RealName",
	 * in="query",
	 * description="真实姓名",
	 * required=true,
	 * type="string"
	 * ),
	 * @SWG\Parameter(
	 * name="IDCard",
	 * in="query",
	 * description="身份证号",
	 * required=true,
	 * type="string"
	 * ),
	 * @SWG\Response(
	 * response=200,
	 * description="",
	 * @SWG\Schema(
	 * ref="#/definitions/BackgroundSurvey"
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
		$Search =$request->param ();
		if ($Search) {
			$search=BackgroundSurveyService::Search($Search);
			return $search;
		}
	}
	
	/**
	 * @SWG\GET(
	 * path="/workplace/BackgroundSurvey/Detail",
	 * summary="背景调查报告详情",
	 * description=" ",
	 * tags={"BackgroundSurvey"},
	 * @SWG\Parameter(
	 * name="CompanyId",
	 * in="query",
	 * description="公司ID",
	 * required=true,
	 * type="integer"
	 * ),
	 * @SWG\Parameter(
	 * name="RecordId",
	 * in="query",
	 * description="购买记录ID",
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
	public function Detail(Request $request) {
		$Detail =$request->param ();
		if ($Detail) {
			$detail=BackgroundSurveyService::BoughtDetail($Detail);
			return $detail;
		}
	}	
	
	/**
	 * @SWG\GET(
	 * path="/workplace/BackgroundSurvey/SingleDetail",
	 * summary="背景调查报告详情(查看单个档案或者单个评价)",
	 * description=" ",
	 * tags={"BackgroundSurvey"},
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
	public function SingleDetail(Request $request) {
		$Detail =$request->param ();
		if ($Detail) {
			$detail=BackgroundSurveyService::SingleDetail($Detail);
			return $detail;
		}
	}
	
}