<?php
namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="Event",
 * description="",
 * )
 */
/**
 * @SWG\Definition(required={"SuccessfulOpeningAccount"})
 */
class EventCode extends BaseModel{


    /**
     * @SWG\Property(type="integer",description="开户成功 <b>[ 1 ]</b>")
     */
    public static $SuccessfulOpeningAccount;
    const SuccessfulOpeningAccount = 'SuccessfulOpeningAccount';


    /**
     * @SWG\Property(type="int",description="普通企业邀请企业开户成功 <b>[ 2 ]</b>")
     */
    public static $OrdinarynvitedAccountSuccessfully;

    const OrdinarynvitedAccountSuccessfully = 'OrdinarynvitedAccountSuccessfully';


    /**
     * @SWG\Property(type="int",description="渠道代理邀请企业开户成功 <b>[ 3 ]</b>")
     */
    public static $AgentsAccountsSuccess;

    const AgentsAccountsSuccess = 'AgentsAccountsSuccess';

    /**
     * @SWG\Property(type="int",description="运营后台添加企业用户 <b>[ 4 ]</b>")
     */
    public static $AddUser;

    const AddUser = 'AddUser';

    /**
     * @SWG\Property(type="int",description="企业认证,运营审核通过 <b>[ 5 ]</b>")
     */
    public static $EnterpriseCertification;

    const EnterpriseCertification = 'EnterpriseCertification';


    /**
     * @SWG\Property(type="int",description="企业认证,运营审核通过,不创建老板账号 <b>[ 6 ]</b>")
     */
    public static $EnterpriseCertificationDotAccount;

    const EnterpriseCertificationDotAccount = 'EnterpriseCertificationDotAccount';

    /**
     * @SWG\Property(type="int",description="企业认证,运营审核通过并给老板创建账号<b>[ 7 ]</b>")
     */
    public static $EnterpriseCertificationCreateAccount;

    const EnterpriseCertificationCreateAccount = 'EnterpriseCertificationCreateAccount';

    /**
     * @SWG\Property(type="int",description="企业认证未通过 <b>[ 8 ]</b>")
     */
    public static $EnterpriseCertificationError;

    const EnterpriseCertificationError = 'EnterpriseCertificationError';

    /**
     * @SWG\Property(type="int",description="离职报告审核通过 <b>[9 ]</b>")
     */
    public static $DepartureReportpproval;

    const DepartureReportpproval = 'DepartureReportpproval';

    /**
     * @SWG\Property(type="int",description="提交阶段评价 <b>[ 10 ]</b>")
     */
    public static $Commitvaluation;

    const Commitvaluation = 'Commitvaluation';

    /**
     * @SWG\Property(type="int",description="提交离任报告 <b>[ 11 ]</b>")
     */
    public static $Outgoingeport;

    const Outgoingeport = 'Outgoingeport';

    /**
     * @SWG\Property(type="int",description="阶段评价审核通过 <b>[ 12 ]</b>")
     */
    public static $StageEvaluationApproval;

    const StageEvaluationApproval = 'StageEvaluationApproval';


    /**
     * @SWG\Property(type="int",description="阶段评价审核未通过 <b>[ 13 ]</b>")
     */
    public static $StageEvaluationAuditFailed;

    const StageEvaluationAuditFailed = 'StageEvaluationAuditFailed';


    /**
     * @SWG\Property(type="int",description="离职报告审核未通过 <b>[14 ]</b>")
     */
    public static $DepartureReportAuditFailed;

    const DepartureReportAuditFailed = 'DepartureReportAuditFailed';


    /**
     * @SWG\Property(type="int",description="购买背景调查 <b>[ 15 ]</b>")
     */
    public static $BuyBackgroundSurvey;

    const BuyBackgroundSurvey = 'BuyBackgroundSurvey';

    /**
     * @SWG\Property(type="int",description="添加授权人 <b>[ 16 ]</b>")
     */
    public static $AddAuthorized;

    const AddAuthorized = 'AddAuthorized';

    /**
     * @SWG\Property(type="int",description="企业建立员工档案 <b>[ 17 ]</b>")
     */
    public static $EmployeeFiles;

    const EmployeeFiles = 'EmployeeFiles';

    /**
     * @SWG\Property(type="int",description="个人用户开通会员 <b>[ 18 ]</b>")
     */
    public static $OpenVip;

    const OpenVip = 'OpenVip';


    /**
     * @SWG\Property(type="int",description="离职报告审核通过（个人） <b>[20 ]</b>")
     */
    public static $DepartureReportpprovalPersonal;

    const DepartureReportpprovalPersonal = 'DepartureReportpprovalPersonal';

    /**
     * @SWG\Property(type="int",description="阶段评价审核通过（个人） <b>[ 21 ]</b>")
     */
    public static $StageEvaluationApprovalPersonal;

    const StageEvaluationApprovalPersonal = 'StageEvaluationApprovalPersonal';

    /**
     * @SWG\Property(type="int",description="添加授权人（老板） <b>[ 22 ]</b>")
     */
    public static $AddAuthorizedBoss;

    const AddAuthorizedBoss = 'AddAuthorizedBoss';

    /**
     * @SWG\Property(type="int",description="添加授权人（已注册） <b>[ 23 ]</b>")
     */
    public static $AddAuthorizedAlready;

    const AddAuthorizedAlready = 'AddAuthorizedAlready';

    /**
     * @SWG\Property(type="int",description="企业认证,运营审核通过,不创建老板账号（老板） <b>[ 24]</b>")
     */
    public static $EnterpriseCertificationDotAccountBoss;

    const EnterpriseCertificationDotAccountBoss = 'EnterpriseCertificationDotAccountBoss';

    /**
     * @SWG\Property(type="int",description="口碑公司认领通过 <b>[ 25]</b>")
     */
    public static $OpinionClaimSuccess;

    const OpinionClaimSuccess = 'OpinionClaimSuccess';

    /**
     * @SWG\Property(type="int",description="口碑公司认领未通过 <b>[ 26]</b>")
     */
    public static $OpinionClaimFailed;

    const OpinionClaimFailed = 'OpinionClaimFailed';


    /**
     * @SWG\Property(type="int",description="公司新的点评 <b>[ 27]</b>")
     */
    public static $AddOpinion;

    const AddOpinion = 'AddOpinion';




}