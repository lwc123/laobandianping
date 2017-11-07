<?php
namespace app\workplace\models;

/**
 * @SWG\Definition()
 */
class BizTypes
{    
	/**
	 * @SWG\Property(type="string",description="钱包")
	 */
	public $Wallet;
	const Wallet = "Wallet";    
    
	/**
	 * @SWG\Property(type="string",description="公司")
	 */
	public $Company;
	const Company = "Company";  
    
	/**
	 * @SWG\Property(type="string",description="公司成员(授权)")
	 */
	public $CompanyMember;
	const CompanyMember = "CompanyMember";

    /**
	 * @SWG\Property(type="string",description="公司部门")
	 */
	public $CompanyDepartment;
	const CompanyDepartment = "CompanyDepartment"; 
    
	/**
	 * @SWG\Property(type="string",description="雇员档案")
	 */
	public $EmployeArchive;
	const EmployeArchive = "EmployeArchive";    
    
	/**
	 * @SWG\Property(type="string",description="档案-阶段评价")
	 */
	public $StageEvaluation;
	const StageEvaluation = "StageEvaluation";
    
	/**
	 * @SWG\Property(type="int",description="档案-离职报告")
	 */
	public $DepartureReport;
	const DepartureReport = "DepartureReport";
    
	/**
	 * @SWG\Property(type="int",description="背景调查")
	 */
	public $BackgroundSurvey;
	const BackgroundSurvey = "BackgroundSurvey";

	/**
	 * @SWG\Property(type="int",description="公司动态")
	 */
	public $BossTrend;
	const BossTrend = "BossTrend";
    
	/**
	 * @SWG\Property(type="int",description="职位")
	 */
	public $JobInfo;
	const JobInfo = "JobInfo";
 
}