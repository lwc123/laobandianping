<?php

namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="CompanyAuditRequest",
 *   description="申请企业认证,主要功能：申请被拒绝，请求已提交信息"
 * )
 */
/**
 * @SWG\Definition(required={"MobilePhone","Licence","Images","Company"})
 */
class  CompanyAuditRequest extends BaseModel {

	/**
	 * @SWG\Property(ref="#/definitions/Company")
	 */
	public $Company;
    
	/**
	 * @SWG\Property(type="string", description="驳回理由")
	 */
	public $RejectReason;
	 
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $ApplyId;
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $ApplicantId;
	
	/**
	 * @SWG\Property(type="integer", description="法人手机号")
	 */
	public $MobilePhone;
	 
	/**
	 * @SWG\Property(type="string", description="营业执照")
	 */
	public $Licence;
 
	/**
	 * @SWG\Property(type="string", description="身份证照片")
	 */
	public $Images;
	
	/**
	 * @SWG\Property(type="integer", description="参见枚举：AuditStatus")
	 */
	public $AuditStatus;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
	
	
	public function getImagesAttr($value)
	{
		if($value){
            $value=explode(",",str_replace(array("[","]"),"",$value));
            foreach ($value as $key){
                $keys[]= parent::getResourcesSiteRoot($key);
            }
            return $keys;
        }

	}
	

	public function getLicenceAttr($value)
	{
        if($value){
            return  parent::getResourcesSiteRoot($value);
        }

	}
    // 定义一对一关联
    public function company()
    {
        return $this->belongsTo('company','CompanyId');
    }
    /**
     * 审核列表
     */
    public static function findAuditByQuery($companyQuery, $pagination) {
        //$pagination = Pagination::Create($userQuery['Page'], $userQuery['Size']);
        $buildQueryFunc = function() use ($companyQuery) {
            $query = null;
            $query = CompanyAuditRequest::with('company');
            if (!isset($companyQuery['AuditStatus']) || strlen($companyQuery['AuditStatus'])==0) {

                $query = $query->where('company_audit_request.AuditStatus=1 or company_audit_request.AuditStatus=9' );
            } else {
                $query = $query->where('company_audit_request.AuditStatus',$companyQuery['AuditStatus']);
            }
            if (!empty($companyQuery['CompanyName'])) {
                $query = $query->where('CompanyName', 'like','%'.$companyQuery['CompanyName'].'%')->whereOr('CompanyAbbr', 'like','%'.$companyQuery['CompanyName'].'%');
            }

            if( !empty($companyQuery['MaxSignedUpTime'])){
                $companyQuery['MaxSignedUpTime'] = date('Y-m-d',strtotime('+1 day',strtotime($companyQuery['MaxSignedUpTime'])));
            }else{
                $companyQuery['MaxSignedUpTime'] =   date('Y-m-d',strtotime('+1 day'));
            }
            if (!empty($companyQuery['MinSignedUpTime'])) {
                $query = $query->where('company_audit_request.CreatedTime', 'between time', [$companyQuery['MinSignedUpTime'],$companyQuery['MaxSignedUpTime']]);
            }
            return $query;
        };
        $pagination->TotalCount =  $buildQueryFunc($companyQuery)->count();
        return $buildQueryFunc()->order ( 'company_audit_request.CreatedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
    }
 
}
