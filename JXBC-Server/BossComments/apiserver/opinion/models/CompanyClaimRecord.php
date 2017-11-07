<?php

namespace app\opinion\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={""})
 */
class CompanyClaimRecord extends OpinionBase {

    /**
     * @SWG\Property(type="integer", description="认领记录Id")
     */
    public $RecordId;

    /**
     * @SWG\Property(type="integer", description="口碑公司Id")
     */
    public $OpinionCompanyId;

    /**
     * @SWG\Property(type="integer", description="公司Id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="认领人ID")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string", description="拒绝认领理由")
     */
    public $RejectReason;

    /**
     * @SWG\Property(type="integer", description="1 提交认领  2通过认领  3拒绝认领")
     */
    public $AuditStatus;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;

    public function Company()
    {
        return $this->belongsTo('Company','OpinionCompanyId');
    }

    public function OpinionCompany()
    {
        return $this->hasOne('Company','CompanyId','OpinionCompanyId');
    }

    public static function CompanyClaimList($param){
        if (empty ($param) || empty ($param['CompanyId'])) {
            exception('非法请求-0', 412);
        }
        $list= CompanyClaimRecord::all(function($query) use ($param){
            $query->where(['AuditStatus'=>2,'company_claim_record.CompanyId'=>$param['CompanyId']])->order('CreatedTime desc,RecordId desc');
        },'OpinionCompany');
        $company=[];
        if ($list){
            foreach ($list as $key =>$val){
                $company[]=$val['OpinionCompany'];
            }
        }
        return $company;
    }

}
