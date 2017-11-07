<?php

namespace app\Admin\controller;
use think\Controller;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\Admin\controller\AdminBaseController;
use app\common\modules\DbHelper;
use app\workplace\models\Company;
use app\opinion\models\Company as opinionCompany;
use app\workplace\models\CompanyMember;
use app\workplace\models\CompanyAuditRequest;
use app\workplace\models\ServiceContract;
use app\workplace\models\AuditStatus;
use app\workplace\services\CompanyService;
use app\common\modules\DictionaryPool;
use app\admin\services\PaginationServices;
use app\workplace\models\DictionaryEntry;
use app\appbase\models\UserPassport;
use app\workplace\models\InvitedRegister;
use app\admin\models\Channel;
use app\opinion\models\CompanyClaimRecord;


class CompanyController extends AuthenticatedController
{

    /**
     * 企业列表
     * @param Request $request 搜索条件
     * @return mixed
     */
    public function companyList(Request $request)
    {
        $queryParams = $request->get();
        //return json($queryParams);
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        //判断搜索条件是否为空
        $MinSignedUpTime = empty($queryParams['MinSignedUpTime']) ? "" : $queryParams['MinSignedUpTime'];
        $MaxSignedUpTime = empty($queryParams['MaxSignedUpTime']) ? '' : $queryParams['MaxSignedUpTime'];
        $CompanyName = empty($queryParams['CompanyName']) ? "" : $queryParams['CompanyName'];
        $RealName = empty($queryParams['RealName']) ? "" : $queryParams['RealName'];
        if (!isset($queryParams['ContractStatus']) || strlen($queryParams['ContractStatus']) == 0) {
               $ContractStatus = '';
        } else {
            if ($queryParams['ContractStatus'] == 2) {
                $ContractStatus = 2;
            } else {
                $ContractStatus = 1;
            }
        }
        if (!isset($queryParams['InternalChannel']) || strlen($queryParams['InternalChannel']) == 0) {
              $InternalChannel = '';
        } else {
             $InternalChannel = $queryParams['InternalChannel'];
        }

        if (!isset($queryParams['AuditStatus']) || strlen($queryParams['AuditStatus']) == 0) {
            $AuditStatus = '';
        } else {
            $AuditStatus = $queryParams['AuditStatus'];
        }

        $CompanyList = Company::findByQuery($queryParams, $pagination);
        foreach ($CompanyList as $key => $value) {
            //公司开户人注册时间
            $CompanyList[$key]['OpenUser'] = UserPassport::where('PassportId', $value['PassportId'])->field('CreatedTime')->find();
            if(!empty($value['ChannelCode'])){
                $IsExistCode = InvitedRegister::where('InviterCode', $value['ChannelCode'])->find();
                if ($IsExistCode) {
                    $CompanyList[$key]['IsExistCode'] = true;
                } else {
                    $CompanyList[$key]['IsExistCode'] = false;
                }
            }

            //判断企业是否合同过期
            if (!empty($value['ServiceEndTime'])) {
                if (substr($value['ServiceEndTime'],0,4) == '3000') {
                    $CompanyList[$key]['IsServiceEndTime'] = true;
                } else {
                    if (strtotime($value['ServiceEndTime']) < time()) {
                        $CompanyList[$key]['IsServiceEndTime'] = false;
                    }
                }
            }
        }

        //搜索条件
        $seachvalue = "MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&CompanyName=$CompanyName&ContractStatus=$ContractStatus&RealName=$RealName&InternalChannel=$InternalChannel&AuditStatus=$AuditStatus";
       //方法名
        $action = 'companyList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
        $this->view->assign('CompanyList', $CompanyList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        $this->view->assign('ContractStatus', $ContractStatus);
        $this->view->assign('InternalChannel', $InternalChannel);
        $this->view->assign('AuditStatus', $AuditStatus);
        return $this->fetch();
    }

    /**
     * 企业数据汇总
     * @param Request $request 搜索条件
     * @return mixed
     */
    public function CompanyDataList(Request $request)
    {
        $queryParams = $request->get();
        //return json($queryParams);
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        //判断搜索条件是否为空
        $MinSignedUpTime = empty($queryParams['MinSignedUpTime']) ? "" : $queryParams['MinSignedUpTime'];
        $MaxSignedUpTime = empty($queryParams['MaxSignedUpTime']) ? '' : $queryParams['MaxSignedUpTime'];
        $CompanyName = empty($queryParams['CompanyName']) ? "" : $queryParams['CompanyName'];

        $CompanyList = Company::findByQuery($queryParams, $pagination);

        foreach ($CompanyList as $key => $value) {
            //公司开户人注册时间
            $CompanyList[$key]['OpenUser'] = UserPassport::where('PassportId',$value['PassportId'])->field('CreatedTime')->find();
            $CompanyList[$key]['adminUserNum'] = CompanyMember::where('CompanyId',$value['CompanyId'])->where('role','NEQ',1)->count();
            //判断企业是否合同过期
            if (!empty($value['ServiceEndTime'])) {
                if (substr($value['ServiceEndTime'],0,4) == '3000') {
                    $CompanyList[$key]['IsServiceEndTime'] = true;
                } else {
                    if (strtotime($value['ServiceEndTime']) < time()) {
                        $CompanyList[$key]['IsServiceEndTime'] = false;
                    }
                }

            }
        };

        //搜索条件
        $seachvalue = "MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&CompanyName=$CompanyName&data=CompanyData";
        //方法名
        $action = 'CompanyDataList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
        $this->view->assign('CompanyList', $CompanyList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        // return json($CompanyList);
        return $this->fetch();
    }

    /**
     * 到期的企业列表
     * @param Request $request 搜索条件
     * @return mixed
     */
    public function DueCompanyList(Request $request)
    {
        $queryParams = $request->get();
        //return json($queryParams);
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        //判断搜索条件是否为空
        $MinSignedUpTime = empty($queryParams['MinSignedUpTime']) ? "" : $queryParams['MinSignedUpTime'];
        $MaxSignedUpTime = empty($queryParams['MaxSignedUpTime']) ? '' : $queryParams['MaxSignedUpTime'];
        $MinServiceEndTime = empty($queryParams['MinServiceEndTime']) ? "" : $queryParams['MinServiceEndTime'];
        $MaxServiceEndTime = empty($queryParams['MaxServiceEndTime']) ? '' : $queryParams['MaxServiceEndTime'];
        $CompanyName = empty($queryParams['CompanyName']) ? "" : $queryParams['CompanyName'];

        $CompanyList = Company::findByQuery($queryParams, $pagination);

        foreach ($CompanyList as $key => $value) {
            //判断企业是否合同过期
            if (!empty($value['ServiceEndTime'])) {
                if (substr($value['ServiceEndTime'],0,4) == '3000') {
                    $CompanyList[$key]['IsServiceEndTime'] = true;
                } else {
                    if (strtotime($value['ServiceEndTime']) < time()) {
                        $CompanyList[$key]['IsServiceEndTime'] = false;
                    }
                    $days = ceil((strtotime(DbHelper::toLocalDateTime($value['ServiceEndTime']))-time())/86400);
                    $CompanyList[$key]['days']  = $days;
                }
            }
        };

        //搜索条件
        $seachvalue = "MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&CompanyName=$CompanyName&data=dueCompany&MinServiceEndTime=$MinServiceEndTime&MaxServiceEndTime=$MaxServiceEndTime";
        //方法名
        $action = 'DueCompanyList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
        $this->view->assign('CompanyList', $CompanyList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        //return json($CompanyList);
        return $this->fetch();
    }
    /**
     * 公司详情
     *
     * @param Request $request 公司ID
     *
     */
    public function Detail(Request $request)
    {
        $CompanyId = $request->get('CompanyId');
        //公司详情
        $CompanyDetail = Company::find([$CompanyId]);
        $CompanyDetail['OpenInfor'] = CompanyMember::where(['CompanyId' => $CompanyId, 'PassportId' => $CompanyDetail['PassportId']])->find();
        $CompanyDetail['CompanySize'] = DictionaryPool::getEntryNames('CompanySize', $CompanyDetail['CompanySize']);
        $CompanyDetail['Region'] = DictionaryPool::getEntryNames('city', $CompanyDetail['Region']);
        //判断注册的方式
        if (!empty($CompanyDetail['ChannelCode'])) {
            $IsExist = InvitedRegister::where('InviterCode', $CompanyDetail['ChannelCode'])->find();
            if ($IsExist) {
                $CompanyDetail['ExistInviterCode'] = true;
                if ($IsExist['CompanyId'] == 0) {
                    $CompanyDetail['ExistCompany'] = false;
                    $CompanyDetail['UserPassport'] = UserPassport::where('PassportId', $IsExist['PassportId'])->find();
                } else {
                    $CompanyDetail['ExistCompany'] = true;
                    $CompanyDetail['Company'] = Company::where('CompanyId', $IsExist['CompanyId'])->find();
                }
            } else {
                $CompanyDetail['ExistInviterCode'] = false;
                $Channel = Channel::where('ChannelCode', $CompanyDetail['ChannelCode'])->find();
                if($Channel)
                  $CompanyDetail['Channel'] = $Channel;
                }
        }
        //公司执照
        $CompanyDetail['CompanyAudit'] = CompanyAuditRequest::where(['CompanyId' => $CompanyId])->find();
        //开户金额
        $CompanyDetail['ServiceContract'] = ServiceContract::where(['CompanyId' => $CompanyId])->find();
        $CompanyDetail['ServiceContract']['TotalFee'] = substr($CompanyDetail['ServiceContract']['TotalFee'],1);
        //公司开户人信息
        $CompanyDetail['CompanyMember'] = CompanyMember::where(['CompanyId' => $CompanyId])->order('CreatedTime desc')->limit(1)->find();
        $CompanyDetail['OpenUser'] = UserPassport::where('PassportId', $CompanyDetail['PassportId'])->field('CreatedTime')->find();
        // return json($CompanyDetail);die;
        $this->view->assign('CompanyDetail', $CompanyDetail);

        //授权管理员信息
        $RoleList = CompanyMember::where('CompanyId', $CompanyId)->select();
        $this->view->assign('RoleList', $RoleList);

        //认领口碑公司列表

        $ClaimList=   CompanyClaimRecord::where(["AuditStatus"=>2])->where('CompanyId', $CompanyId)->select();
        if($ClaimList){
            foreach($ClaimList as $key =>$val){
                $ClaimList[$key]['opinionCompany'] = opinionCompany::where('CompanyId',$val['OpinionCompanyId'])->find();
            }
        }
       // return json($ClaimList);die;
        $this->view->assign('ClaimList', $ClaimList);

        return $this->fetch();
    }

    /**
     * 修改公司页面
     * @param Request $request
     * @return 修改页面
     */
    public function update(Request $request)
    {
        // 获取JSON数据
        $CompanyId = $request->get('CompanyId');
        $CompanyInfo = Company::where("CompanyId", $CompanyId)->find();
        $DictionaryIndustry = DictionaryPool::getDictionaries('industry');
        $DictionaryCompanySize = DictionaryPool::getDictionaries('CompanySize');
        $DictionaryRegion = DictionaryPool::getDictionaries('city');
        //公司执照
      // $CompanyInfo['dictionary'] = $dictionary;
       // print_r($dicItionary);die;
        $this->assign('CompanyInfo', $CompanyInfo);
        $this->assign('DictionaryIndustry', $DictionaryIndustry);
        $this->assign('DictionaryCompanySize', $DictionaryCompanySize);
        $this->assign('DictionaryRegion', $DictionaryRegion);
        return $this->fetch();
    }


    /**
     * 修改公司请求 图片处理
     * @param Request $request 修改公司的信息
     */
    public function updateRequest(Request $request)
    {
        $request = $request->post();
        if ($request) {
            $CompanyLogo = empty($_FILES["CompanyLogo"]['tmp_name']) ? '' : base64EncodeImage($_FILES["CompanyLogo"]);
            if (empty($CompanyLogo)) {
                unset($request['CompanyLogo']);
            } else {
                $request['CompanyLogo'] = $CompanyLogo;
            }
            $request ['ModifiedId'] = 1;
            $update = CompanyService::CompanyUpdate($request);
            if ($update) {
                $this->success('修改成功', 'Company/companyList');
            } else {
                $this->error('修改失败');
            }
        }
    }

    /**
     * 审核列表
     *
     * @param Request $request 搜索条件
     * @return array  搜索列表
     *
     */
    public function auditList(Request $request)
    {
        $queryParams = $request->get();
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));

        //判断搜索条件是否为空
        $MinSignedUpTime = empty($queryParams['MinSignedUpTime']) ? "" : $queryParams['MinSignedUpTime'];
        $MaxSignedUpTime = empty($queryParams['MaxSignedUpTime']) ? '' : $queryParams['MaxSignedUpTime'];
        $CompanyName = empty($queryParams['CompanyName']) ? "" : $queryParams['CompanyName'];
        $AuditStatus = "";
        if (!isset($queryParams['AuditStatus']) || strlen($queryParams['AuditStatus']) == 0) {
            $AuditStatus = '';
        } else {
                $AuditStatus =  $queryParams['AuditStatus'];
        }
        $CompanyList = CompanyAuditRequest::findAuditByQuery($queryParams, $pagination);
        //搜素条件
        $seachvalue = "MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&CompanyName=$CompanyName&AuditStatus=$AuditStatus";
        //分页
        $action = 'auditList';
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign('CompanyList', $CompanyList);
        $this->view->assign('pageHtml', $pageHtml);
        $this->view->assign('TotalCount', $pagination->TotalCount);
        $this->view->assign('AuditStatus', $AuditStatus);
        return $this->fetch();
    }

    /**
     * 认证通过
     *
     * @param Request $request
     */
    public function auditRequest(Request $request)
    {
        $passAuditRequest = $request->get();
        if ($passAuditRequest) {
           $AuditPass = CompanyService::AuditCompany($passAuditRequest);
            if ($AuditPass['Success']==true) {
                echo 1;
            } else {
                echo 0;
            }
        }
    }



}


