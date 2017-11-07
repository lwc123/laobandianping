<?php
namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="DictCategoryCode",
 * description="业务字典分类Code",
 * )
 */
/**
 * @SWG\Definition(required={"SuccessfulOpeningAccount"})
 */
class DictCategoryCode extends BaseModel{

    /**
     * @SWG\Property(type="string",description="学历")
     */
    public static $Academic;

    const Academic = 'academic';

    /**
     * @SWG\Property(type="string",description="行业")
     */
    public static $Industry;

    const Industry = 'industry';

    /**
     * @SWG\Property(type="string",description="薪资水平")
     */
    public static $Salary;

    const Salary = 'salary';

    /**
     * @SWG\Property(type="string",description="城市")
     */
    public static $City;

    const City = 'city';


    /**
     * @SWG\Property(type="string",description="返聘意愿")
     */
    public static $Panicked;

    const Panicked = 'panicked';


    /**
     * @SWG\Property(type="string",description="时间段")
     */
    public static $Period;

    const Period= 'period';


    /**
     * @SWG\Property(type="string",description="离任原因")
     */
    public static $Leaving;

    const Leaving= 'leaving';


}