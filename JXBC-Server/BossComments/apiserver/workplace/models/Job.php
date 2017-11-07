<?php
namespace app\workplace\models;
use app\common\models\BaseModel;
use think\Model;

/**
 * @SWG\Tag(
 *   name="Job",
 *   description="企业发布职位API"
 * )
 */
/**
 * @SWG\Definition(required={"CompanyId","JobName","SalaryRangeMin","SalaryRangeMax","JobLocation","ContactEmail","ContactNumber","JobDescription","JobCity"})
 */
class Job extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="发布职位ID")
     */
    public $JobId;

    /**
     * @SWG\Property(type="integer", description="公司ID")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="用户ID")
     */
    public $PassportId;


    /**
     * @SWG\Property(type="string", description="职位名称")
     */
    public $JobName;

    /**
     * @SWG\Property(type="string", description="期望薪资最小值")
     */
    public $SalaryRangeMin;

    /**
     * @SWG\Property(type="string", description="期望薪资最大值")
     */
    public $SalaryRangeMax;


    /**
     * @SWG\Property(type="string", description="经验要求code")
     */
    public $ExperienceRequire;

    /**
     * @SWG\Property(type="string", description="经验要求")
     */
    public $ExperienceRequireText;

    /**
     * @SWG\Property(type="string", description="教育要求code")
     */
    public $EducationRequire;

    /**
     * @SWG\Property(type="string", description="教育要求")
     */
    public $EducationRequireText;


    /**
     * @SWG\Property(type="string", description="工作城市code")
     */
    public $JobCity;

    /**
     * @SWG\Property(type="string", description="工作城市")
     */
    public $JobCityText;

    /**
     * @SWG\Property(type="string", description="工作地点")
     */
    public $JobLocation;

    /**
     * @SWG\Property(type="string", description="工作描述")
     */
    public $JobDescription;


    /**
     * @SWG\Property(type="string", description="接受简历的邮箱")
     */
    public $ContactEmail;

    /**
     * @SWG\Property(type="string", description="联系电话")
     */
    public $ContactNumber;

    /**
     * @SWG\Property(type="string", description="发布时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;

    /**
     * @SWG\Property(ref="#/definitions/CompanyMember")
     */
    public $CompanyMember;
    /**
     * @SWG\Property(ref="#/definitions/Company")
     */
    public $Company;

    // 定义一对一关联  公司和发布的职位
    public function Company()
    {
        return $this->belongsTo('Company','CompanyId');
    }
    // 定义一对一关联  公司和发布的职位
    public function CompanyMember()
    {
        return $this->belongsTo('CompanyMember','CompanyId');
    }



}