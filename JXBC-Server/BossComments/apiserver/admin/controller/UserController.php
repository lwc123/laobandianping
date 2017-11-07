<?php

namespace app\Admin\controller;
use think\Controller;
use think\View;
use think\Db;
use think\Config;
use think\Request;
use app\Admin\controller\AdminBaseController;
use app\appbase\models\UserPassport;
use app\common\modules\DbHelper;
use app\workplace\models\CompanyMember;
use app\workplace\models\Company;
use app\workplace\models\MemberRole;
use app\admin\services\PaginationServices;
use app\workplace\models\Feedback;
use app\workplace\models\InvitedRegister;
use app\admin\models\Channel;
use app\appbase\models\SignedUpInfo;




class UserController extends AuthenticatedController {
    //用户列表
    public function UserList(Request $request) {
        $queryParams = $request->get();
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        //判断搜索条件是否为空
        $MinSignedUpTime =empty( $queryParams['MinSignedUpTime'])? "":$queryParams['MinSignedUpTime'];
        $MaxSignedUpTime =empty($queryParams['MaxSignedUpTime'])?'':$queryParams['MaxSignedUpTime'];
        $Invited = "";
        if (!isset($queryParams['Invited']) || strlen($queryParams['Invited'])==0) {
            $Invited ='';
        }else{
            $Invited =$queryParams['Invited'];
        }
        if (!isset($queryParams['ProfileType']) || strlen($queryParams['ProfileType'])==0) {
                $ProfileType ='';
        }else{
                $ProfileType =$queryParams['ProfileType'];
        }
       // print_r($queryParams);die;

        $userList = UserPassport::findByQuery($queryParams, $pagination);

        foreach($userList as $key =>$val){
            $userList[$key]['CompanyNum']=0;
            $userList[$key]['CompanyNum'] = Company::where('PassportId',$val['PassportId'])->count();
        }

        //搜索条件
        $seachvalue ="MinSignedUpTime=$MinSignedUpTime&MaxSignedUpTime=$MaxSignedUpTime&ProfileType=$ProfileType&Invited=$Invited";
        //方法名
        $action = 'UserList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);

        $this->view->assign ( 'userList', $userList );
        $this->view->assign ( 'pageHtml', $pageHtml );
        $this->view->assign ( 'MinSignedUpTime', $MinSignedUpTime );
        $this->view->assign ( 'MaxSignedUpTime', $MaxSignedUpTime );
        $this->view->assign ( 'TotalCount', $pagination->TotalCount );
        $this->view->assign ( 'Invited', $Invited );
       return  $this->fetch();
    }
    //用户详情
    public function Detail(Request $request)
    {
        $PassportId  = $request->get('uid');
        $userDetail= UserPassport::with('UserProfile,SignedUpInfo')->find($PassportId);
        //被邀请的企业
        if(strlen($userDetail['SignedUpInfo']['InviteCode'])>0){
                $IsExist = InvitedRegister::where('InviterCode',$userDetail['SignedUpInfo']['InviteCode'])->find();
                if($IsExist){
                    $userDetail['ExistInviterCode'] =true;
                    if($IsExist['CompanyId']==0){
                        $userDetail['ExistCompany'] =false;
                        $userDetail['UserPassport'] = UserPassport::where('PassportId',$IsExist['PassportId'])->find();
                    }else{
                        $userDetail['ExistCompany'] =true;
                        $userDetail['Company'] = Company::where('CompanyId',$IsExist['CompanyId'])->find();
                    }
                }else{
                    $userDetail['ExistInviterCode'] =false;
                    $userDetail['Channel'] = Channel::where('ChannelCode',$userDetail['SignedUpInfo']['InviteCode'])->find();
                }
        }
        $InvitedCompany= Db::table('Invited_Register')->alias('a')->join('Company b ','b.ChannelCode= a.InviterCode')->where('a.PassportId',$PassportId)->select();
        if($InvitedCompany){
            $this->assign('InvitedCompany', $InvitedCompany);
       }
        //用户所在的公司
            $myCompany =  CompanyMember::where('PassportId',$PassportId)->select();
        // 取出用户所在公司列表
           foreach($myCompany as $key=>$value){
               $myCompany[$key]['Company'] =Company::where('CompanyId',$value['CompanyId'])->field('CompanyId,CompanyName,AuditStatus,CreatedTime')->find();
           }
      //  return json($userDetail);
        return  $this->fetch('Detail',['userDetail'=>$userDetail,'myCompany'=>$myCompany]);
    }

    /**
     *  用戶意見反饋
     * @param Request $request
     * @return mixed
     */
    public function feedbackList(Request $request)
    {
        $pagination = DbHelper::BuildPagination($request->get("Page"), $request->get("Size"));
        $feedbackList =  Feedback::order('CreatedTime desc')->page($pagination->PageIndex,$pagination->PageSize)->select();
        $pagination->TotalCount =Feedback::count();
        $seachvalue ="";
        //方法名
        $action = 'feedbackList';
        //分页
        $pageHtml =  PaginationServices::getPagination($pagination,$seachvalue,$action);
        // 取出用户所在公司信息
        foreach($feedbackList as $key=>$value){
            $feedbackList[$key]['Company'] =Company::where('CompanyId',$value['CompanyId'])->field('CompanyName')->find();
            $feedbackList[$key]['CompanyMember'] =CompanyMember::getPassportRoleByCompanyId($value['CompanyId'],$value['PassportId']);
        }
        $this->assign('feedbackList', $feedbackList);
        $this->assign('pageHtml', $pageHtml);
        $this->assign('TotalCount',   $pagination->TotalCount);
        return  $this->fetch();
       // return  json($feedbackList);
    }

    /**
     *  把未读修改成已读
     * @param Request $request
     * @return mixed
     */
    public function IsRead(Request $request)
    {
        $FeedbackId  = $request->get('FeedbackId');
        $IsRead =  Feedback::update(['IsProcess'=>1],['FeedbackId'=>$FeedbackId]);
        if($IsRead){
           return true;
        }
    }



}


