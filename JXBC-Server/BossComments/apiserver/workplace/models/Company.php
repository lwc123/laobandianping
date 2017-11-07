<?php

namespace app\workplace\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;
use app\workplace\models\CompanyMember;
use think\Db;
use app\workplace\models\AuditStatus;

/**
 * @SWG\Tag(
 *   name="Company",
 *   description="企业相关API，包括工作台等"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyName"})
 */
class Company extends BaseModel {
    
    public static function createNew($name, $creatorId) {        
        $company = Company::where(['CompanyName' => $name])->find();
        if($company) {
            exception('您输入的公司已开通服务！请联系该公司管理员', 4102);
        }

        $CompanyLogo = '/_files/company-default/' . rand(1,10). '.png';
        $company = new Company([ 
            'CompanyName' => $name,
            'PassportId' => $creatorId,
            'CompanyLogo' => $CompanyLogo
        ]);
        $company->allowField(true)->save();
        return $company;
    }
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CompanyName;
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $CompanyId;
	
	/**
	 * @SWG\Property(type="integer", description="")
	 */
	public $PassportId;
	
	/**
	 * @SWG\Property(type="string", description="公司简称")
	 */
	public $CompanyAbbr;
	
	
	/**
	 * @SWG\Property(type="string", description="法人姓名")
	 */
	public $LegalName;
	
	/**
	 * @SWG\Property(type="string", description="省市城市")
	 */
	public $Region;
	
	
	/**
	 * @SWG\Property(type="string", description="企业规模")
	 */
	public $CompanySize;
	
	
	/**
	 * @SWG\Property(type="string", description="所属行业")
	 */
	public $Industry;
	 
	/**
	 * @SWG\Property(type="string", description="企业LOGO")
	 */
	public $CompanyLogo;
	 
	/**
	 * @SWG\Property(type="integer", description="认证状态，参考枚举AuditStatus")
	 */
	public $AuditStatus;

    /**
     * @SWG\Property(type="integer", description="在职人数")
     */
    public $EmployedNum;

    /**
     * @SWG\Property(type="integer", description="离职人数")
     */
    public $DimissionNum;

    /**
     * @SWG\Property(type="integer", description="阶段评价数")
     */
    public $StageEvaluationNum;

    /**
     * @SWG\Property(type="integer", description="离职报告数")
     */
    public $DepartureReportNum;

    /**
     * @SWG\Property(type="string", description="合同终止时间")
     */
    public $ServiceEndTime;
	  
	/**
	 * @SWG\Property(type="string", description="合同状态")
	 */
	public $ContractStatus;
	
	/**
	 * @SWG\Property(type="boolean", description="是否存在公司银行卡")
	 */
	public $ExistBankCard;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $CreatedTime;
	
	/**
	 * @SWG\Property(type="string", description="")
	 */
	public $ModifiedTime;
	 
	/**
	 * 自动完成
	 */
    protected $type = [
        'CreatedTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'ServiceEndTime' => 'datetime'
    ];
	protected $insert = ['AuditStatus' => 0,'ContractStatus' => 0];

	public function getCompanyLogoAttr($value)
	{ 
		if($value){
		return  parent::getResourcesSiteRoot($value);}
		else{
		return parent::getResourcesSiteRoot('/default/company.png');
		}
	}
	
	public function setCompanyLogoAttr($value)
	{
		return  parent::setResourcesSiteRoot($value);
	}
 


    /**
     * 公司列表
     */
    /*public static function findByQuery($companyQuery, $pagination) {
        //$pagination = Pagination::Create($userQuery['Page'], $userQuery['Size']);
        $buildQueryFunc = function() use ($companyQuery) {
            $query = null;
            if (!isset($companyQuery['ContractStatus']) || strlen($companyQuery['ContractStatus'])==0) {
                $query = Company::with('CompanyMember');
            } else {
                $query = Company::with('CompanyMember');
                if($companyQuery['ContractStatus'] == '2') {
                    $query = $query->where('ContractStatus',2);
                } else {
                    $query = $query->where('ContractStatus',1);
                }
            }
            if (!empty($companyQuery['CompanyName'])) {
                $query = $query->where('CompanyName', 'like','%'.$companyQuery['CompanyName'].'%')->whereOr('CompanyAbbr', 'like','%'.$companyQuery['CompanyName'].'%');
            }
            if (!empty($companyQuery['MinSignedUpTime']) || !empty($companyQuery['MaxSignedUpTime'])) {
                $query = $query->where('Company.CreatedTime', 'between time', [$companyQuery['MinSignedUpTime'],$companyQuery['MaxSignedUpTime']]);
            }
            return $query;
        };
        $pagination->TotalCount =  $buildQueryFunc($companyQuery)->count();
        return $buildQueryFunc()->order ( 'company.CreatedTime desc' )->page($pagination->PageIndex, $pagination->PageSize)->select();
    }*/
    public static function findByQuery($companyQuery, $pagination) {
            $where = [];
            //是否开户
            if (isset($companyQuery['ContractStatus']) && strlen($companyQuery['ContractStatus'])!=0) {
                if($companyQuery['ContractStatus'] == '2') {
                    $where['ContractStatus'] = 2;
                } else {
                    $where['ContractStatus'] = 1;
                }
            }
          //数据统计
            if (!empty($companyQuery['data']) && ($companyQuery['data'] =='CompanyData' ||  $companyQuery['data'] =='dueCompany')) {
                $where['AuditStatus'] =AuditStatus::AuditPassed;
                if( $companyQuery['data'] =='dueCompany'){
                    $where['ContractStatus'] = 1;
                    $where['Company.ServiceEndTime'] = ['between time', [0,date('Y-m-d',strtotime('+16 day'))]];
                }
            }

           //注册方式
            if (isset($companyQuery['InternalChannel']) && strlen($companyQuery['InternalChannel'])!=0) {
                if($companyQuery['InternalChannel'] == 0) {
                    $where['ChannelCode'] = '';
                } else if($companyQuery['InternalChannel'] == 1) {
                    $where['InternalChannel'] = $companyQuery['InternalChannel'];
                }else if($companyQuery['InternalChannel'] == 2) {
                    $where['InternalChannel'] =0 .' and length(ChannelCode)>0';
                }
            }
            //认证状态
            if (isset($companyQuery['AuditStatus']) && strlen($companyQuery['AuditStatus'])!=0) {
                    $where['AuditStatus'] = $companyQuery['AuditStatus'];
            }
            $whereOr=[];
            if (!empty($companyQuery['CompanyName'])) {
                $where['CompanyName'] = ['like','%'.$companyQuery['CompanyName'].'%'];
                $whereOr['CompanyAbbr'] = ['like','%'.$companyQuery['CompanyName'].'%'];
            }
            if (!empty($companyQuery['RealName'])) {
                $where['RealName'] = ['like','%'.$companyQuery['RealName'].'%'];
            }
            //开户时间
            if( !empty($companyQuery['MaxSignedUpTime'])){
                $companyQuery['MaxSignedUpTime'] = date('Y-m-d',strtotime('+1 day',strtotime($companyQuery['MaxSignedUpTime'])));
            }else{
                $companyQuery['MaxSignedUpTime'] =   date('Y-m-d',strtotime('+16 day'));
            }
            if( !empty($companyQuery['MinSignedUpTime'])){
                $where['Company.CreatedTime'] = ['between time', [$companyQuery['MinSignedUpTime'],$companyQuery['MaxSignedUpTime']]];
            }
         //到期时间

        if( !empty($companyQuery['MinServiceEndTime'])){
            if( !empty($companyQuery['MaxServiceEndTime'])){
                $companyQuery['MaxServiceEndTime'] = date('Y-m-d',strtotime('+1 day',strtotime($companyQuery['MaxServiceEndTime'])));
            }else{
                $companyQuery['MaxServiceEndTime'] =  date('Y-m-d',strtotime('+16 day',strtotime($companyQuery['MinServiceEndTime'])));
            }
            $where['Company.ServiceEndTime'] = ['between time', [$companyQuery['MinServiceEndTime'],$companyQuery['MaxServiceEndTime']]];
        }

        $pagination->TotalCount = Db::table('Company')->alias('a')->join('company_member w','a.CompanyId = w.CompanyId and a.PassportId=w.PassportId')->where($where)->whereOr($whereOr)->count();
        $Companylist=Db::table('Company')->alias('a')->join('company_member w','a.CompanyId = w.CompanyId and a.PassportId=w.PassportId')->where($where)->whereOr($whereOr)
            ->order('a.CreatedTime desc')
            ->page($pagination->PageIndex, $pagination->PageSize)
            ->select();

        return $Companylist;
    }



    // 定义一对一关联
    public function CompanyMember()
    {
        return $this->belongsTo('CompanyMember','CompanyId');
    }

    // 定义一对多关联
    public function companymembers()
    {
        return $this->hasMany('CompanyMember','CompanyId');
    }

    public function archives()
    {
        return $this->hasMany('EmployeArchive','CompanyId');
    }

//    public function companymembers()
//    {
//        return $this->hasone('CompanyMember','CompanyId');
//    }
//    public function CompanyBankCards()
//    {
//        return $this->hasone('CompanyBankCard','CompanyId');
//    }

    // 定义一对一关联
    public function company_audit_request()
    {
        return $this->belongsTo('company_audit_request','CompanyId');
    }

    // 定义一对一关联
    public function service_contract()
    {
        return $this->belongsTo('service_contract','CompanyId');
    }

    // 定义一对一关联
    public function DrawMoneyRequest()
    {
        return $this->belongsTo('draw_money_request','CompanyId');
    }


}
