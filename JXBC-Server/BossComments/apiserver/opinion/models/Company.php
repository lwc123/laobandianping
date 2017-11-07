<?php

namespace app\opinion\models;

use app\common\models\BaseModel;
use think\console\command\optimize\Config;
use app\common\modules\DictionaryPool;


/**
 * @SWG\Definition(required={"CompanyId","Content"})
 */
class Company extends OpinionBase
{

    /**
     * @SWG\Property(type="integer", description="公司ID")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="是否被认领，1未认领，2已认领")
     */
    public $IsClaim;

    /**
     * @SWG\Property(type="integer", description="认领公司ID")
     */
    public $ClaimCompanyId;


    /**
     * @SWG\Property(type="integer", description="采集原ID")
     */
    public $CollectionCompanyId;


    /**
     * @SWG\Property(type="string", description="公司名称")
     */
    public $CompanyName;

    /**
     * @SWG\Property(type="string", description="公司简称")
     */
    public $CompanyAbbr;

    /**
     * @SWG\Property(type="string", description="公司CEO")
     */
    public $CompanyCEO;

    /**
     * @SWG\Property(type="string", description="公司LOGO")
     */
    public $CompanyLogo;


    /**
     * @SWG\Property(type="integer", description="是否可以评论，默认1开启，2关闭")
     */
    public $IsCloseComment;


    /**
     * @SWG\Property(type="string", description="公司总得分")
     */
    public $Score;

    /**
     * @SWG\Property(type="integer", description="推荐给朋友平均分")
     */
    public $Recommend;

    /**
     * @SWG\Property(type="integer", description="公司前景平均分")
     */
    public $Optimistic;

    /**
     * @SWG\Property(type="integer", description="支持CEO分数平均分")
     */
    public $SupportCEO;

    /**
     * @SWG\Property(type="string", description="城市")
     */
    public $Region;

    /**
     * @SWG\Property(type="string", description="规模")
     */
    public $CompanySize;

    /**
     * @SWG\Property(type="string", description="行业")
     */
    public $Industry;

    /**
     * @SWG\Property(type="integer", description="1热度计算，2企业自定义")
     */
    public $LabelType;

    /**
     * @SWG\Property(type="string", description="标签")
     */
    public $Labels;

    /**
     * @SWG\Property(type="string", description="产品")
     */
    public $Products;

    /**
     * @SWG\Property(type="string", description="图片")
     */
    public $Photos;

    /**
     * @SWG\Property(type="string", description="一句话介绍")
     */
    public $BriefIntroduction;

    /**
     * @SWG\Property(type="string", description="公司介绍")
     */
    public $Introduction;

    /**
     * @SWG\Property(type="string", description="公司地址")
     */
    public $Address;

    /**
     * @SWG\Property(type="integer", description="关注数")
     */
    public $LikedCount;

    /**
     * @SWG\Property(type="integer", description="阅读数")
     */
    public $ReadCount;

    /**
     * @SWG\Property(type="integer", description="点评数")
     */
    public $CommentCount;

    /**
     * @SWG\Property(type="integer", description="员工数")
     */
    public $StaffCount;

    /**
     * @SWG\Property(type="string", description="成立时间")
     */
    public $EstablishedTime;

    /**
     * @SWG\Property(type="boolean", description="是否老东家")
     */
    public $IsFormerClub;

    /**
     * @SWG\Property(type="boolean", description="是否关注")
     */
    public $IsConcerned;

    /**
     * @SWG\Property(type="boolean", description="是否显示红点")
     */
    public $IsRedDot;

    /**
     * @SWG\Property(type="string", description="分享链接（企业详情）")
     */
    public $ShareLink;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    protected $insert = ['IsCloseComment' => 1,'IsClaim' => 1,'LabelType' => 1];

    public function getLabelsAttr($value)
    {
        $label=[];
        if ($value){
            $label= json_decode($value,true);
        }
        return $label;

    }
    protected $type = [
        'EstablishedTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'CreatedTime' => 'datetime',
    ];
     //公司logo处理
    public function getCompanyLogoAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }

    public function getShareLinkAttr($value,$data)
    {
      return  Config('site_root_api').'/apppage/Opinion/CompanyDetail?CompanyId='.$data['CompanyId'];
    }

    public function getIsCloseCommentAttr($value)
    {
        if ($value==1){
            $value= true;
        }else{
            $value= false;
        }
        return $value;
    }

    public function getIsClaimAttr($value)
    {
        if ($value==2){
            $value= true;
        }else{
            $value= false;
        }
        return $value;
    }

    //城市处理
    public function getRegionAttr($value)
    {
        $Region= DictionaryPool::getEntryNames('city',$value);
        if($Region){
            return $Region;
        }else{
            return $value;
        }
    }
    //规模处理
    public function getCompanySizeAttr($value)
    {
        $CompanySize= DictionaryPool::getEntryNames('CompanySize',$value);
        if($CompanySize){
            return $CompanySize;
        }else{
            return $value;
        }
    }

    public function Opinions()
    {
        return $this->hasMany('Opinion');
    }


}
