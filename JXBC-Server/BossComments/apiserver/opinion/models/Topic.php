<?php

namespace app\opinion\models;
use app\common\models\BaseModel;
use think\Db;
use Think\Config;


/**
 * @SWG\Definition(required={""})
 */
class Topic extends OpinionBase {

    /**
    /**
     * @SWG\Property(type="integer", description="专题ID")
     */
    public $TopicId;

    /**
     * @SWG\Property(type="string", description="专题名字")
     */
    public $TopicName;

    /**
     * @SWG\Property(type="string", description="专题头图")
     */
    public $HeadFigure;

    /**
     * @SWG\Property(type="string", description="Banner图")
     */
    public $BannerPicture;

    /**
     * @SWG\Property(type="boolean", description="是否开启专题")
     */
    public $IsOpen;

    /**
     * @SWG\Property(type="integer", description="专题排序号")
     */
    public $TopicOrder;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;

    public function getHeadFigureAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }
    public function getBannerPictureAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }


}
