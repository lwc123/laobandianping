<?php
namespace app\common\models;

/**
 * @SWG\Definition()
 */
class ErrorCode {
	
	/**
	 * @SWG\Property(type="string",description="修改失败")
	 */
	public $ModifyFailed;
	const ModifyFailed = "ModifyFailed";


    /**
     * @SWG\Property(type="string",description="提交失败")
     */
    public $SubmitFailed;
    const SubmitFailed = "SubmitFailed";

    /**
     * @SWG\Property(type="string",description="今日提交次数已超额")
     */
    public $MultipleCommit;
    const MultipleCommit = "MultipleCommit";
	
	/**
	 * @SWG\Property(type="string",description="验证码输入错误")
	 */
	public $ValidationCode;
	const ValidationCode = "ValidationCode";	
	
	/**
	 * @SWG\Property(type="string",description="发现身份证号匹配的员工档案姓名与您输入的姓名不一致")
	 */
	public $BackgroundSurvey_RealName;
	const BackgroundSurvey_RealName = "BackgroundSurvey_RealName";
	
	////////////////////////////公司档案CodeStart//////////////////////////////////////
	/**
	 * @SWG\Property(type="string",description="身份证号公司已存在")
	 */
	public $EmployeArchive_IDCard;
	const EmployeArchive_IDCard = "EmployeArchive_IDCard";

    /**
     * @SWG\Property(type="string",description="没填写身份证号")
     */
    public $Empty_IDCard;
    const Empty_IDCard = "Empty_IDCard";

    /**
     * @SWG\Property(type="string",description="身份证号不合法")
     */
    public $Wrongful_IDCard;
    const Wrongful_IDCard = "Wrongful_IDCard";
	
	/**
	 * @SWG\Property(type="string",description="修改失败")
	 */
	public $EmployeArchive_Update;
	const EmployeArchive_Update = "EmployeArchive_Update";
	
	////////////////////////////公司档案CodeEnd//////////////////////////////////////

	////////////////////////////公司部门CodeStart//////////////////////////////////////
	
	/**
	 * @SWG\Property(type="string",description="企业部门已存在")
	 */
	public $DepartmentExist;
	const DepartmentExist = "DepartmentExist";

	
	/**
	 * @SWG\Property(type="string",description="该部门下有员工档案，暂不能删除")
	 */
	public $DepartmentCannotDelete;
	const DepartmentCannotDelete	 = "DepartmentCannotDelete";
	
	
	/**
	 * @SWG\Property(type="string",description="该部门已经删除")
	 */
	public $DepartmentIsDelete;
	const DepartmentIsDelete	 = "DepartmentIsDelete";
	
	////////////////////////////部门CodeEnd//////////////////////////////////////
	
	/**
	 * @SWG\Property(type="string",description="提现金额不能大于可提现金额")
	 */
	public $DrawMoneyRequest_CanWithdrawBalance;
	const DrawMoneyRequest_CanWithdrawBalance	 = "DrawMoneyRequest_CanWithdrawBalance";

    /**
     * @SWG\Property(type="string",description="提现失败")
     */
    public $Withdraw_Failed;
    const Withdraw_Failed	 = "Withdraw_Failed";
	
	////////////////////////////个人CodeStart//////////////////////////////////////
	/**
	 * @SWG\Property(type="string",description="身份证号已被绑定")
	 */
	public $Privateness_IDCard;
	const Privateness_IDCard = "Privateness_IDCard";
	////////////////////////////个人CodeEnd//////////////////////////////////////
	
	////////////////////////////成员（授权人）CodeStart//////////////////////////////////////
	/**
	 * @SWG\Property(type="string",description="公司已有该成员")
	*/
	public $Member_existence;
	const Member_existence = "Member_existence";
	////////////////////////////成员（授权人）CodeEnd//////////////////////////////////////



    ////////////////////////////口碑 CodeStart//////////////////////////////////////
    /**
     * @SWG\Property(type="string",description="请选择要点评的公司")
     */
    public $CompanyId_Empty;
    const CompanyId_Empty = "CompanyId_Empty";

    /**
     * @SWG\Property(type="string",description="请填写内容")
     */
    public $Content_Empty;
    const Content_Empty = "Content_Empty";

    /**
     * @SWG\Property(type="string",description="请选择要评论的点评")
     */
    public $OpinionId_Empty;
    const OpinionId_Empty = "OpinionId_Empty";
    ////////////////////////////成员（授权人）CodeEnd//////////////////////////////////////
	
	
}