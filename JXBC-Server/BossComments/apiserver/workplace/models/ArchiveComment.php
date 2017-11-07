<?php

namespace app\workplace\models;
use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 * name="ArchiveComment",
 * description="档案评价和离职报告API"
 * )
 */
/**
 * @SWG\Definition(required={"ArchiveId"})
 */
class ArchiveComment extends BaseModel {
	
	/**
	 * @SWG\Property(type="integer", description="公司ID")
	 */
	public $CompanyId;
	
	/**
	 * @SWG\Property(type="integer", description="档案ID")
	 */
	public $ArchiveId;
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $CommentId;
	
	/**
	 * @SWG\Property(type="integer", description="提交人")
	 */
	public $PresenterId;
	
	/**
	 * @SWG\Property(type="integer", description="修改人")
	 */
	public $ModifiedId;
	 
	/**
	 * @SWG\Property(type="integer", description="是否离职报告，0否，1是")
	 */
	public $CommentType;
	
	/**
	 * @SWG\Property(type="integer", description="审核状态，0未审核，1审核中，2已审核，9被退回")
	 */
	public $AuditStatus;
	 
	/**
	 * @SWG\Property(type="string", description="评价年份")
	 */
	public $StageYear;
	
	/**
	 * @SWG\Property(type="string", description="年份区间")
	 */
	public $StageSection;
	
	
	/**
	 * @SWG\Property(type="integer", description="工作能力")
	 */
	public $WorkAbility;
	
	
	/**
	 * @SWG\Property(type="integer", description="工作态度")
	 */
	public $WorkAttitude;
 
	
	/**
	 * @SWG\Property(type="integer", description="工作业绩")
	 */
	public $WorkPerformance;
	
	
	/**
	 * @SWG\Property(type="string", description="评价文字")
	 */
	public $WorkComment;
	
	/**
	 * @SWG\Property(type="string", description="评价图片")
	 */
	public $WorkCommentImages;
	 
	
	/**
	 * @SWG\Property(type="string", description="评价录音")
	 */
	public $WorkCommentVoice;
	
	/**
	 * @SWG\Property(type="integer", description="评价录音秒值")
	 */
	public $WorkCommentVoiceSecond;
	
	/**
	 * @SWG\Property(type="string", description="离职时间")
	 */
	public $DimissionTime;
	 
	/**
	 * @SWG\Property(type="string", description="离职原因")
	 */
	public $DimissionReason;
	
	/**
	 * @SWG\Property(type="string", description="离职薪水")
	 */
	public $DimissionSalary;
	
	
	
	/**
	 * @SWG\Property(type="string", description="离职原因补充")
	 */
	public $DimissionSupply;
	
	
	/**
	 * @SWG\Property(type="integer", description="交接及时性")
	 */
	public $HandoverTimely;
	
	/**
	 * @SWG\Property(type="integer", description="交接全面性")
	 */
	public $HandoverOverall;
	
	/**
	 * @SWG\Property(type="integer", description="交接后续支持")
	 */
	public $HandoverSupport;
	 
	/**
	 * @SWG\Property(type="string", description="返聘意愿")
	 */
	public $WantRecall;
 
    /**
	 * @SWG\Property(type="string", description="审核人Id列表")
	 */
 
	public $AuditPersons;
	
	/**
	 * @SWG\Property(type="string", description="操作人姓名")
	 */
	public $OperateRealName;
	
	/**
	 * @SWG\Property(type="string", description="驳回原因")
	 */
	public $RejectReason;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(ref="#/definitions/EmployeArchive")
	 */
	public $EmployeArchive;
	
	protected $type = [
			'CreatedTime'   => 'datetime',
			'ModifiedTime'  => 'datetime',
			'DimissionTime'  => 'datetime',
	];
	// 定义一对一关联
	public function EmployeArchive()
	{
		return $this->belongsTo('EmployeArchive','ArchiveId')->field('RealName,CompanyId');
	}
 
	public function getWorkCommentVoiceAttr($value)
	{
		if($value){
		return  parent::getResourcesSiteRoot($value);
		}
	}
	
	public function setWorkCommentVoiceAttr($value)
	{
		if($value){
		return  parent::setResourcesSiteRoot($value);
		}
	}
}
