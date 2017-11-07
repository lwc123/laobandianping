<?php
namespace app\workplace\models;

use app\common\models\BaseModel; 

/**
 * @SWG\Tag(
 *   name="BoughtCommentRecord",
 *   description="购买背景调查记录API，包括已购买列表，搜索等"
 * )
 */
/**
 * @SWG\Definition(required={"ArchiveId"})
 */
class BoughtCommentRecord extends BaseModel {
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $RecordId;
    
	/**
	 * @SWG\Property(type="integer", description="购买人所属公司")
	 */
	public $CompanyId;     
 
	/**
	 * @SWG\Property(type="integer", description="购买人")
	 */
	public $PassportId; 
	
	/**
	 * @SWG\Property(type="integer", description="是否购买过阶段评价")
	 */
	public $BoughtStageEvaluation; 
	
	/**
	 * @SWG\Property(type="integer", description="是否购买过离职报告")
	 */
	public $BoughtDepartureReport;
	
	/**
	 * @SWG\Property(type="integer", description="档案所属公司ID")
	 */
	public $ArchiveCompanyId;
	
	/**
	 * @SWG\Property(ref="#/definitions/Company")
	 */
	public $ArchiveCompany;
	
	/**
	 * @SWG\Property(type="integer", description="档案ID")
	 */
	public $ArchiveId; 
 
	/**
	 * @SWG\Property(type="string", description="购买时间")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;

    public function EmployeArchive()
    {
        return $this->belongsTo('EmployeArchive','ArchiveId','ArchiveId');
    }

    public function Company()
    {
        return $this->belongsTo('Company','ArchiveCompanyId','CompanyId');
    }
	
}


