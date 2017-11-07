<?php

namespace app\Admin\controller;
use app\opinion\models\Company;
use app\workplace\models\Company as workplaceCompany ;
use app\workplace\models\CompanyMember;
use think\Controller;
use think\View;
use think\Db;
use think\cache;
use think\Request;
use app\opinion\models\Opinion;
use app\opinion\services\OpinionService;
use app\common\modules\DictionaryPool;
use app\common\modules\DbHelper;
use app\admin\services\PaginationServices;
use app\opinion\services\CompanyService;
use app\opinion\models\CompanyClaimRecord;
use app\appbase\models\UserPassport;
use app\common\modules\ResourceHelper;


class OpinionController extends AdminBaseController
{

    /**
     * 创建口碑公司
     * @return
     */
    public function create(Request $request)
    {
        $DictionaryIndustry = DictionaryPool::getDictionaries('industry');
        $DictionaryCompanySize = DictionaryPool::getDictionaries('CompanySize');
        $DictionaryRegion = DictionaryPool::getDictionaries('city');
      //  return json($DictionaryRegion);
        $this->assign('DictionaryIndustry', $DictionaryIndustry);
        $this->assign('DictionaryCompanySize', $DictionaryCompanySize);
        $this->assign('DictionaryRegion', $DictionaryRegion);
        return $this->fetch();
    }

    /**
     * 创建口碑公司请求
     * @return
     */
    public function createRequest(Request $request)
    {
        $request =$request->param();

        if(!empty($request['ClaimCompanyId'])){
            $request['IsClaim'] = 2;
            $result= company::where("CompanyName",$request['CompanyName'])->value('CompanyName');
            if($result){
                echo "<script>alert('该口碑名字已存在');location.href='".$_SERVER['HTTP_REFERER']."'</script>";die;
            }
        }
        if (!empty($request['Labels'])) {
            $request['Labels']= json_encode(explode('|',$request['Labels']),JSON_UNESCAPED_UNICODE);
        }
       // return json($request);
        $create = new Company($request);
        $create->allowField(true)->save();
        if (empty($create)) {
            return false;
        }
        // 公司LOGO
        $request['CompanyLogo'] = empty($_FILES["CompanyLogo"]['tmp_name']) ? '' : base64EncodeImage($_FILES["CompanyLogo"]);
        if (!empty ($request ['CompanyLogo'])) {
            if (strstr($request ['CompanyLogo'], Config('resources_site_root')) == false) {
                $request ['CompanyLogo'] = ResourceHelper::OpinionCompanyLogo($create ['CompanyId'], $request ['CompanyLogo']);
            } else {
                $request ['CompanyLogo'] = str_replace(Config('resources_site_root'), '', $request ['CompanyLogo']);
            }
            Company::where("CompanyId",$create ['CompanyId'])->update(['CompanyLogo'=>$request ['CompanyLogo'] ]);
        }

        if(!empty($request['ClaimCompanyId'])){
            $Record = [];
            $Record['CompanyId'] = $request['ClaimCompanyId'];
            $Record['OpinionCompanyId'] = $create['CompanyId'];
            $Record['PassportId'] = 0;
            $Record['AuditStatus'] = 2;
            $createRecord = new CompanyClaimRecord($Record);
            $createRecord->allowField(true)->save();
        }
       echo "<script>alert('保存成功');location.href='/Opinion/CompanyDetail?CompanyId=".$create['CompanyId']."'</script>";
    }

    /**
     * 口碑公司列表   认领列表
     * @return
     */
    public function CompanyList(Request $request)
    {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $buildQueryFunc = function() use ($request) {
            $dbQuery = Company::where('CompanyId','>',0);
            if (!empty($request->get("CompanyName"))) {
                $dbQuery = $dbQuery->where('CompanyName', 'like', '%'.$request->get("CompanyName").'%')->whereOr('CompanyAbbr', 'like','%'.$request->get("CompanyName").'%');;
            }
            return $dbQuery;
        };

        $pagination->TotalCount =  $buildQueryFunc($request)->count();

        $list = $buildQueryFunc()->order('CreatedTime desc,CompanyId desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
       // return  json($list);
        //搜索条件
        $seachvalue = empty($request->get('CompanyName')) ? "" : "CompanyName=".$request->get('CompanyName');
        //方法名
        $action = 'CompanyList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign ( 'List', $list );
        $this->view->assign ( 'PageHtml', $pageHtml );
        $this->view->assign ( 'Pagination',  $pagination);

        if(empty($request->get("CompanyId"))){
            return  $this->fetch('CompanyList');
        }else{
                $workplaceCompany=  workplaceCompany::where('CompanyId',$request->get("CompanyId"))->find();

                $ClaimOpinion= CompanyClaimRecord::with('company')->where(["AuditStatus"=>1])->where('company_claim_record.CompanyId',$request->get("CompanyId"))->find();
                $this->view->assign ( 'workplaceCompany', $workplaceCompany );
                $this->view->assign ( 'ClaimOpinion', $ClaimOpinion );
                return  $this->fetch('relatedToCompany');

        }
    }

    /**
     * 口碑公司详情
     * @return
     */
    public function CompanyDetail(Request $request)
    {
        $CompanyId = $request->get("CompanyId");
        $Detail = Company::get($CompanyId);
        $this->view->assign ( 'Detail',  $Detail);
        return  $this->fetch();
    }

    /**
     *点评列表
     * @return
     */
    public function OpinionList(Request $request)
    {
        $queryParams= $request->get();
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $buildQueryFunc = function() use ($queryParams) {
            $dbQuery = Opinion::with('company');
            if (!empty($queryParams["CompanyName"])) {
                $dbQuery = $dbQuery->where('CompanyName', 'like', '%'.$queryParams["CompanyName"].'%')->whereOr('CompanyAbbr', 'like','%'.$queryParams["CompanyName"].'%');;
            }
            /*if (!empty($request->get("MobilePhone"))) {
                $dbQuery = $dbQuery->where('CompanyName', 'like', '%'.$request->get("CompanyName").'%')->whereOr('CompanyAbbr', 'like','%'.$request->get("CompanyName").'%');;
            }*/

            if( !empty($queryParams['MaxSignedUpTime'])){
                $queryParams['MaxSignedUpTime'] = date('Y-m-d',strtotime('+1 day',strtotime($queryParams['MaxSignedUpTime'])));
            }else{
                $queryParams['MaxSignedUpTime'] =   date('Y-m-d',strtotime('+1 day'));
            }
            if (!empty($queryParams['MinSignedUpTime'])) {
                $dbQuery = $dbQuery->where('Opinion.LastReplyTime', 'between time', [$queryParams['MinSignedUpTime'],$queryParams['MaxSignedUpTime']]);
            }
            return $dbQuery;
        };

        $pagination->TotalCount =  $buildQueryFunc($queryParams)->count();

        $list = $buildQueryFunc()->order('CreatedTime desc,CompanyId desc')->page($pagination->PageIndex, $pagination->PageSize)->select();
        //return  json($list);
        foreach($list as $key=>$val){
            $list[$key]['MobilePhone']=  UserPassport::where('PassportId',$val['PassportId'])->value('MobilePhone');
            $len = mb_strlen($val['Content'],'utf-8');
            if($len>18){
                $str1 = mb_substr($val['Content'],0,18,'utf-8');
                $list[$key]['Content'] = $str1.'......';
            }
        }
        //return  json($list);
        //搜索条件
        $MinSignedUpTime = empty($queryParams['MinSignedUpTime']) ? "" : $queryParams['MinSignedUpTime'];
        $MaxSignedUpTime = empty($queryParams['MaxSignedUpTime']) ? '' : $queryParams['MaxSignedUpTime'];
        $CompanyName = empty($queryParams['CompanyName']) ? "" : $queryParams['CompanyName'];
        $seachvalue = "MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&CompanyName=$CompanyName";
        //方法名
        $action = 'OpinionList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign ( 'List', $list );
        $this->view->assign ( 'PageHtml', $pageHtml );
        $this->view->assign ( 'Pagination',  $pagination);
        return  $this->fetch();
    }

    /**
     * 口碑详情(点评详情)
     * @return
     */
    public function OpinionDetail(Request $request)
    {
        $Detail= OpinionService::OpinionDetail($request->get("OpinionId"));
        $Detail['MobilePhone']=  UserPassport::where('PassportId',$Detail['PassportId'])->value('MobilePhone');
  /*      if(!empty($Detail['Replies'])){
            foreach($Detail['Replies'] as $key =>$val) {

                    $Detail['Replies'][$key][NULL] = [];
                $Detail['Replies'][$key]['MobilePhone']  = UserPassport::where('PassportId', $val['PassportId'])->value('MobilePhone');
            }
        }*/

       // return  json($Detail);
       $Detail['Labels']= implode(',',$Detail['Labels']);
      // return  json($Detail);
        $this->view->assign ( 'Detail',  $Detail);
        return  $this->fetch();
    }

    /**
     * 待认领口碑公司 列表
     * @return
     */
    public function ClaimList(Request $request)
    {
        $ClaimList= CompanyClaimRecord::with('company')->where(["AuditStatus"=>1])->select();
        foreach($ClaimList as $key =>$val) {
            $ClaimList[$key]['workplaceCompany']  = workplaceCompany::find($val['CompanyId']);
            $ClaimList[$key]['CompanyMember']  = CompanyMember::where(['CompanyId'=>$val['CompanyId'],'PassportId'=>$val['PassportId']])->find();
        }
        $this->view->assign ( 'ClaimList', $ClaimList );
        return  $this->fetch();
       // echo "<script>alert('待定');location.href='/Topic/TopicList'</script>";
    }

    /**关联审核
     * @return
     */
    public function OpinionClaim(Request $request)
    {
        $request=$request->get();
        if( empty($request['RealName']) ){
            $Detail= CompanyClaimRecord::with('company')->where("company_claim_record.CompanyId",$request['CompanyId'])->where("OpinionCompanyId",$request['OpinionCompanyId'])->where('AuditStatus',1)->find();
            $request['RealName']='';
            if($Detail){
                $request['RecordId'] = $Detail['RecordId'];
                $request['RealName']  = CompanyMember::where(['CompanyId'=>$request['CompanyId'],'PassportId'=>$Detail['PassportId']])->value("RealName");
                $request['PassportId'] = $Detail['PassportId'];
            }
        }
        if( empty($request['PassportId'])){
            $request['PassportId'] = 0;
        }
        if( empty($request['RecordId'])){
            $request['RecordId'] = '';
        }
        $this->view->assign ( 'Detail', $request );
        return  $this->fetch();
    }

    /**关联审核
     * @return
     */
    public function OpinionClaimAuditStatus(Request $request)
    {
        $request=$request->get();
        $Result =  OpinionService::ClaimAuditStatus($request);
        return json($Result);
    }

}