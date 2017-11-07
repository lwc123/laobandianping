<?php

namespace app\opinion\models;
use app\common\models\BaseModel;
use think\Db;

/**
 * @SWG\Definition(required={""})
 */
class TopicCompany extends OpinionBase {

    /**
     * @SWG\Property(type="integer", description="关系ID")
     */
    public $TopicCompanyId;

    /**
     * @SWG\Property(type="integer", description="专题Id")
     */
    public $TopicId;

    /**
     * @SWG\Property(type="integer", description="公司Id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="公司排序")
     */
    public $CompanyOrder;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;


    // 定义一对一关联
    public function topic()
    {
        return $this->belongsTo('topic','TopicId');
    }

    public function Company()
    {
        return $this->hasOne('Company','CompanyId','CompanyId');
    }

}
