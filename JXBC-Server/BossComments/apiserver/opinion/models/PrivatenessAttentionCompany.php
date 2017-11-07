<?php

namespace app\opinion\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={""})
 */
class PrivatenessAttentionCompany extends OpinionBase {

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $AttentionId;

    /**
     * @SWG\Property(type="integer", description="用户ID")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="integer", description="公司Id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="1自关，2老东家")
     */
    public $AttentionType;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;


    protected $insert = ['AttentionType' => 1];


}
