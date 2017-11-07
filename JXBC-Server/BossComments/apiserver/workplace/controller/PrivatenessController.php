<?php

namespace app\workplace\controller;

use app\workplace\models\CompanyMember;
use app\workplace\services\MessageService;
use think\Request;
use app\common\controllers\AuthenticatedApiController;
use app\workplace\models\PrivatenessServiceContract;
use app\workplace\models\EmployeArchive;
use app\workplace\services\PrivatenessService;
use app\workplace\models\Company;
use app\workplace\models\ArchiveComment;
use app\workplace\models\CommentType;
use app\workplace\models\Message;
use app\workplace\services\DrawMoneyRequestService;
use app\workplace\models\CompanyBankCard;
use app\workplace\services\HelperService;
use app\common\modules\PaymentEngine;
use app\common\modules\DbHelper;
use app\workplace\models\InvitedRegister;
use think\Config;

/**
 * @SWG\Tag(
 * name="Privateness",
 * description="个人用户相关API"
 * )
 */
class PrivatenessController extends AuthenticatedApiController {
    /**
     * @SWG\GET(
     * path="/workplace/Privateness/Summary",
     * summary="个人工作台+合同信息",
     * description="一个未读消息数，个人开通服务合同类",
     * tags={"Privateness"},
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/PrivatenessSummary")
     * ),
     * @SWG\Response(
     * response="412",
     * description="不符合预期的输入参数",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function Summary() {
        $PassportId = $this->PassportId;
        if ($PassportId) {
            $Summary ['UnreadMessageNum'] = Message::where(['ToPassportId'=>$this->PassportId,'IsRead'=>0])->count();;
            $PrivatenessServiceContract = PrivatenessServiceContract::where ( 'PassportId', $PassportId )->find ();
            if ($PrivatenessServiceContract) {
                $Summary ['PrivatenessServiceContract'] = $PrivatenessServiceContract;
            } else {
                $empty = new \StdClass ();
                $Summary ['PrivatenessServiceContract'] = $empty;
            }

            //获取银行卡信息
            $Summary['ExistBankCard'] = CompanyBankCard::ExistBankCard($PassportId,2)['ExistBankCard'];
            $Summary['myCompanys'] = CompanyMember::where(['PassportId' => $PassportId])->count();
            return $Summary;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/Privateness/ArchiveSummary",
     * summary="我的档案摘要信息",
     * description="根据注册手机号来匹配相关联的档案",
     * tags={"Privateness"},
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/PrivatenessArchiveSummary")
     * ),
     * @SWG\Response(
     * response="412",
     * description="不符合预期的输入参数",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function ArchiveSummary() {
        $PassportId = $this->PassportId;
        if ($PassportId) {
            $UserPassport = parent::GetPassport ();
            $ArchiveSummary ['ArchiveNum'] = EmployeArchive::where ( 'MobilePhone', $UserPassport ['MobilePhone'] )->count ( 'ArchiveId' );
            if ($ArchiveSummary ['ArchiveNum'] > 0) {
                // 查询档案IDS
                $ArchiveIdArray = EmployeArchive::where ( 'MobilePhone', $UserPassport ['MobilePhone'] )->column ( 'ArchiveId' );
                if (isset ( $ArchiveIdArray )) {
                    $ArchiveIds = implode ( ",", $ArchiveIdArray );
                    $ArchiveSummary ['StageEvaluationNum'] = ArchiveComment::where ( 'ArchiveId', 'in', $ArchiveIds )->where ( [
                        'CommentType' => CommentType::StageEvaluation,
                        'AuditStatus' => 2
                    ] )->count ( 'CommentId' );
                    $ArchiveSummary ['DepartureReportNum'] = ArchiveComment::where ( 'ArchiveId', 'in', $ArchiveIds )->where ( [
                        'CommentType' => CommentType::DepartureReport,
                        'AuditStatus' => 2
                    ] )->count ( 'CommentId' );
                } else {
                    $ArchiveSummary ['StageEvaluationNum'] = 0;
                    $ArchiveSummary ['DepartureReportNum'] = 0;
                }
            } else {
                $ArchiveSummary ['StageEvaluationNum'] = 0;
                $ArchiveSummary ['DepartureReportNum'] = 0;
            }
            return $ArchiveSummary;
        }
    }

    /**
     * @SWG\POST(
     * path="/workplace/Privateness/BindingIDCard",
     * summary="绑定我的身份证号",
     * description="合法验证",
     * tags={"Privateness"},
     * @SWG\Parameter(
     * name="IDCard",
     * in="query",
     * description="身份证号",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/Result")
     * ),
     * @SWG\Response(
     * response="412",
     * description="不符合预期的输入参数",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function BindingIDCard(Request $request) {
        $BindingIDCard = $request->param ();
        if ($BindingIDCard) {
            $BindingIDCard ['PassportId'] = $this->PassportId;
            $Binding = PrivatenessService::BindingIDCard ( $BindingIDCard );
            return $Binding;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/Privateness/myArchives",
     * summary="我的档案列表",
     * description="根据身份证号来匹配相关联的档案",
     * tags={"Privateness"},
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/PrivatenessmyArchives")
     * ),
     * @SWG\Response(
     * response="412",
     * description="不符合预期的输入参数",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function myArchives() {
        $myArchives = PrivatenessServiceContract::where ( 'PassportId', $this->PassportId )->find ();

        if ($myArchives) {
            $myArchivesList = EmployeArchive::where ( 'IDCard', $myArchives ['IDCard'] )->order('DimissionTime','desc')->select ();
            if ($myArchivesList) {
                foreach ( $myArchivesList as $key => $value ) {
                    $myArchivesList [$key] ['CompanyName'] = Company::where ( 'CompanyId', $value ['CompanyId'] )->value ( 'CompanyName' );
                    $myArchivesList [$key] ['StageEvaluationNum'] = ArchiveComment::where ( [
                        'CompanyId' => $value ['CompanyId'],
                        'ArchiveId' => $value ['ArchiveId'],
                        'CommentType' => CommentType::StageEvaluation,
                        'AuditStatus' => 2
                    ] )->count ( 'CommentId' );
                    $myArchivesList [$key] ['DepartureReportNum'] = ArchiveComment::where ( [
                        'CompanyId' => $value ['CompanyId'],
                        'ArchiveId' => $value ['ArchiveId'],
                        'CommentType' => CommentType::DepartureReport,
                        'AuditStatus' => 2
                    ] )->count ( 'CommentId' );
                }
            }
            return $myArchivesList;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/Privateness/ArchiveDetail",
     * summary="查看档案详情",
     * description="查看是否开通服务",
     * tags={"Privateness"},
     * @SWG\Parameter(
     * name="ArchiveId",
     * in="query",
     * description="档案ID",
     * required=true,
     * type="integer"
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/ArchiveComment")
     * ),
     * @SWG\Response(
     * response="412",
     * description="不符合预期的输入参数",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function ArchiveDetail(Request $request) {
        $Detail =$request->param ();
        if ($Detail) {
            $Detail['PassportId']=$this->PassportId;
            $detail=PrivatenessService::Detail($Detail);
            return $detail;
        }
    }
    /**
     * @SWG\POST(
     * path="/workplace/Privateness/DrawMoneyRequest",
     * summary="个人提现申请",
     * description="",
     * tags={"Privateness"},
     * @SWG\Parameter(
     * name="body",
     * in="body",
     * description="",
     * required=true,
     * @SWG\Schema(ref="#/definitions/DrawMoneyRequest")
     * ),
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/Result")
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
    public function DrawMoneyRequest(Request $request) {
        // 获取JSON数据
        $Request = $request->put ();
        if ($Request) {
            $Request ['PresenterId'] = $this->PassportId;
            $DrawMoneyRequest =DrawMoneyRequestService::DrawMoneyRequestCreate($Request);
            return $DrawMoneyRequest;
        }
    }

    /**
     * @SWG\GET(
     * path="/workplace/Privateness/BankCardList",
     * summary="个人银行卡列表",
     * description="",
     * tags={"Privateness"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/CompanyBankCard"
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
    public function BankCardList(Request $request) {
        $PresenterId = $this->PassportId;
        if ($PresenterId) {
            $BankCardList =CompanyBankCard::where(['PresenterId'=>$PresenterId,'CompanyId'=>0])->order('UseTime' ,'desc')->select();
            return $BankCardList;
        }
    }



    /**
     * @SWG\GET(
     * path="/workplace/Privateness/InviteRegister",
     * summary="个人邀请码",
     * description="",
     * tags={"Privateness"},
     * @SWG\Response(
     * response=200,
     * description="",
     * @SWG\Schema(
     * ref="#/definitions/InvitedRegister"
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
    public function InviteRegister() {
        $PassportId = $this->PassportId;
        if($PassportId){
            $findcode=InvitedRegister::where(['CompanyId'=>0,'PassportId'=>$PassportId])->find();
            if ($findcode){
                $InviterCode=$findcode['InviterCode'];
            }
            else{
                $createcode=InvitedRegister::create([
                    'CompanyId'=>0,
                    'PassportId'=>$PassportId,
                    'InviterCode'=>createCode($this->PassportId,0),
                    'ExpirationTime'=>DbHelper::getMaxDbDate()
                ]);
                $InviterCode=$createcode['InviterCode'];
            }
            $InviteRegister=InvitedRegister::where(['CompanyId'=>0,'PassportId'=>$this->PassportId])->find();

            $InviteRegister['InvitePremium']=(string)PaymentEngine::GetPrivatenessInviteRegisterPrice($PassportId);
            $InviteRegister['InviteRegisterUrl']=Config('site_root_www')."/m/Account/register?InviteCode=".$InviterCode;
            $InviteRegister['InviteRegisterQrcode']='http://www.kuaizhan.com/common/encode-png?large=true&data='.urlencode($InviteRegister['InviteRegisterUrl']);
            Config::set('default_return_type',"html");
            return json_encode($InviteRegister,JSON_UNESCAPED_SLASHES);
        }
    }

}