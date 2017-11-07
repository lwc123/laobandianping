<?php

namespace app\workplace\models;

use think\Model;

/**
 * @SWG\Tag(
 * name="JobQuery",
 * description="搜索职位API，包括职位名字，行业，地区，薪资范围等"
 * )
 */
/**
 * @SWG\Definition(required={""})
 */
class JobQuery extends BaseModel {

    /**
     * @SWG\Property(type="string", description="搜索期望薪资,如3k-8k,不能是元")
     */
    public $SalaryRange;

    /**
     * @SWG\Property(type="string", description="搜素职位名称")
     */
    public $JobName;

    /**
     * @SWG\Property(type="string", description="搜素地区")
     */
    public $JobCity;

    /**
     * @SWG\Property(type="string", description="搜索行业")
     */
    public $Industry;


    /**
     * @SWG\Property(ref="#/definitions/Company")
     */
    public $Company;


    /**
     * @SWG\Property(ref="#/definitions/Job")
     */
    public $Job;




}
