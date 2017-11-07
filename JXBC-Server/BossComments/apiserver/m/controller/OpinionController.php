<?php

namespace app\m\controller;
use app\common\controllers\PageController;
use app\opinion\models\Company;
use app\opinion\models\Topic;
use app\opinion\services\OpinionService;
use app\opinion\services\CompanyService;
use think\Request;
use app\common\models\ErrorCode;
use app\common\models\Result;
use think\Config;
use think\Cookie;
use app\common\controllers\AuthenticatedOpinionController;
use app\opinion\services\ConcernedService;
use app\opinion\services\TopicService;
use app\opinion\models\Liked;
use app\common\modules\DictionaryPool;
  
class OpinionController extends AuthenticatedOpinionController {
    /**
     * 公司列表
     * @param Request $request
     * @return mixed
     */
    public function CompanyList(Request $request) {
        $param = $request->param();
        if(empty($param['Page'])){
            $param['Page'] =1;
        }
        if(empty($param['Size'])){
            $param['Size'] =15;
        }
        $CompanyList=   CompanyService::CompanyList($param);
        if($param['Page']>1){
            return json($CompanyList);
        }else {
            $this->view->assign('CompanyList', $CompanyList);
            return $this->fetch();
        }

    }

    /**
     * 专题详情
     * @param Request $request
     * @return mixed
     */
    public function topicDetail(Request $request) {
        $param = $request->get();
        if(empty($param['Page'])){
            $param['Page'] =1;
        }
        if(empty($param['Size'])){
            $param['Size'] =15;
        }
        $param['PassportId'] = $this->PassportId;
        $CompanyList=   TopicService::Detail($param);
      // return   json($CompanyList);
        if($param['Page']>1){
            return json($CompanyList['Companys']);
        }else {
            $this->view->assign('TopicDetail', $CompanyList);
            return $this->fetch();
        }

    }

    /**
     * 公司搜索
     * @param Request $request
     * @return mixed
     */
    public function search(Request $request) {
        $param = $request->param();
        if (!empty($param['Keyword'])) {
            $list =Company::where('CompanyName','like', '%'.$param['Keyword'].'%')->whereOr('CompanyAbbr','like', '%'.$param['Keyword'].'%')->order('CreatedTime desc,CompanyId desc')->limit(15)->select();
            return $list;
        }
    }

    /**公司详情  添加
     * @param Request $request
     * @return mixed
     */
    public function create(Request $request)
    {
        $param = $request->get();
        if (empty($param['Page'])) {
            $param['Page'] = 1;
        }
        if (empty($param['Size'])) {
            $param['Size'] = 6;
        }
        $OpinionLables = DictionaryPool::getDictionaries('OpinionLables');
        //return  json($OpinionLables);
        $param['PassportId'] = $this->PassportId;
        $CompanyDetail = CompanyService::Detail($param);
        //return  json($CompanyDetail);
            $this->view->assign('CompanyDetail', $CompanyDetail);
           $this->view->assign('Lables', $OpinionLables);
            return $this->fetch();

    }
    /**公司详情
     * @param Request $request
     * @return mixed
     */
    public function CompanyDetail(Request $request) {
        $param = $request->param();
        if(empty($param['Page'])){
            $param['Page'] =1;
        }
        if(empty($param['Size'])){
            $param['Size'] =6;
        }
        $param['PassportId'] = $this->PassportId;
        $CompanyDetail =  CompanyService::Detail($param);
        ///return  json($CompanyDetail);
        if($param['Page']>1){
            return json($CompanyDetail['Opinions']);
        }else {
            $this->view->assign('CompanyDetail', $CompanyDetail);
            return $this->fetch();
        }

    }

    /**点评详情
     * @param Request $request
     * @return mixed
     */
    public function OpinionDetail(Request $request) {
        $param= $request->param();
        $param['PassportId'] = $this->PassportId;
        $OpinionDetail =  OpinionService::OpinionDetail($param);
        $this->view->assign ( 'OpinionDetail', $OpinionDetail );
       //  return  json($OpinionDetail);
        return $this->fetch();
    }

    /**添加点评
     * @param Request $request
     * @return mixed
     */
    public function createRequest(Request $request) {
        $request = $request->put();
        //return json($request);
        if (empty($request['CompanyId'])) {
            return json(Result::error(ErrorCode::CompanyId_Empty, '请选择要点评的公司'));
        }
        if (!empty($request['Labels'])) {
            $request['Labels']= explode(',',$request['Labels']);
        }
        $request['PassportId'] = $this->PassportId;
        $request['EntryTime'] = $request['EntryTime'].'-01-01';
        if( $request['DimissionTime']=='至今'){
            $request['DimissionTime'] ='3000-01-01';
        }else{
            $request['DimissionTime'] = $request['DimissionTime'].'-01-01';
        }
        $Result=OpinionService::OpinionCreate($request);
        return json($Result);
     /*  if($Result->Success==true){
           $post = Config::get("site_root_api")."/apppage/Opinion/addsuccess?OpinionId=".$Result->BizId;
           header ( "location:$post" );
       }*/
    }

    /**关注或者取消
     * @param Request $request
     * @return mixed
     */
    public function Concern(Request $request) {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        if($param['PassportId']>0){
            return ConcernedService::Concerned($param);
        }else{
            return json(Result::error(ErrorCode::CompanyId_Empty, '请先登录'));
        }
        }

    /**点赞   取消点赞
     * @param Request $request
     * @return mixed
     */
    public function liked(Request $request)
    {
        $param = $request->param();
        $param['PassportId'] = $this->PassportId;
        if($param['PassportId']>0){
            return Liked::Liked($param);
        }else{
           // return   111111111;
            return  Liked::TouristMarkLiked($param);
            /* $m = Cookie::get('IsLiked_'.$param['OpinionId']);
            return $m;*/
        }
    }


        public function _empty()
    {
        return $this->fetch();
    }
}


