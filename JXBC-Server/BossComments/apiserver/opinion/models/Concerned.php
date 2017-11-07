<?php

namespace app\opinion\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={""})
 */
class Concerned extends OpinionBase {

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $ConcernedId;

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
    public $ConcernedType;

    /**
     * @SWG\Property(type="integer", description="1关注，2取关")
     */
    public $Status;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;


    protected $insert = ['ConcernedType' => 1,'Status' => 1];

    public function company()
    {
        return $this->hasOne('Company','CompanyId','CompanyId');
    }

    public function getConcernedTypeAttr($value)
    {
        if ($value==2){
            $value= true;
        }else{
            $value= false;
        }
        return $value;
    }

}
