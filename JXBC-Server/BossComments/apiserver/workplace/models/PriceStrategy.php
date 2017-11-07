<?php

namespace app\workplace\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="PriceStrategy",
 *   description="优惠活动Api"
 * )
 */
/**
 * @SWG\Definition(required={"ActivityType"})
 */
class PriceStrategy extends BaseModel {


    /**
     * @SWG\Property(type="integer", description="活动ID")
     */
    public $ActivityId;

    /**
     * @SWG\Property(type="integer", description="参见枚举;ActivityType")
     */
    public $ActivityType;

    /**
     * @SWG\Property(type="string", description="版本号")
     */
    public $Version;

    /**
     * @SWG\Property(type="string", description="活动名称")
     */
    public $ActivityName;

    /**
     * @SWG\Property(type="integer", description="Android开户原价")
     */
    public $AndroidOriginalPrice;

    /**
     * @SWG\Property(type="integer", description="Android开户优惠价")
     */
    public $AndroidPreferentialPrice;

    /**
     * @SWG\Property(type="integer", description="Ios开户原价")
     */
    public $IosOriginalPrice;

    /**
     * @SWG\Property(type="integer", description="Ios开户原价")
     */
    public $IosPreferentialPrice;

    /**
     * @SWG\Property(type="string", description="PC活动说明(默认)")
     */
    public $ActivityDescription;

    /**
     * @SWG\Property(type="string", description="Android活动说明")
     */
    public $AndroidActivityDescription;

    /**
     * @SWG\Property(type="string", description="Ios活动说明")
     */
    public $IosActivityDescription;


    /**
     * @SWG\Property(type="string", description="活动头图(默认Android)")
     */
    public $ActivityHeadFigure;

    /**
     * @SWG\Property(type="string", description="Ios活动头图")
     */
    public $IosActivityHeadFigure;


    /**
     * @SWG\Property(type="string", description="活动图标")
     */
    public $ActivityIcon;

    /**
     * @SWG\Property(type="boolean", description="是否开启活动")
     */
    public $IsOpen;

    /**
     * @SWG\Property(type="boolean", description="判断是否有活动")
     */
    public $IsActivity;

    /**
     * @SWG\Property(type="integer", description="参见枚举;PriceStrategyAuditStatus")
     */
    public $AuditStatus;

    /**
     * @SWG\Property(type="string", description="活动开始时间")
     */
    public $ActivityStartTime;

    /**
     * @SWG\Property(type="string", description="活动截止时间")
     */
    public $ActivityEndTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;


    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime',
        'ActivityStartTime'=> 'datetime',
        'ActivityEndTime'=> 'datetime'
    ];

    public function getActivityHeadFigureAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }
    public function getIosActivityHeadFigureAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }
    public function getActivityIconAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }

}
