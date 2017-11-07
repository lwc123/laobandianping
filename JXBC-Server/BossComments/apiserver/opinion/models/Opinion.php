<?php

namespace app\opinion\models;

use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="Opinion",
 * description="口碑相关API，包括口碑和公司列表详情等"
 * )
 */

/**
 * @SWG\Definition(required={"CompanyId","PassportId","Content"})
 */
class Opinion extends OpinionBase
{

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $OpinionId;

    /**
     * @SWG\Property(type="integer", description="公司ID")
     */
    public $CompanyId;


    /**
     * @SWG\Property(type="integer", description="提交人")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="integer", description="修改人")
     */
    public $ModifiedId;

    /**
     * @SWG\Property(type="string", description="昵称")
     */
    public $NickName;

    /**
     * @SWG\Property(type="string", description="头像")
     */
    public $Avatar;

    /**
     * @SWG\Property(type="integer", description="显示状态，默认1显示，2隐藏")
     */
    public $AuditStatus;

    /**
     * @SWG\Property(type="string", description="入职日期，如：2015-01-01")
     */
    public $EntryTime;

    /**
     * @SWG\Property(type="string", description="离职日期，如：2017-01-01或者至今3000-01-01")
     */
    public $DimissionTime;

    /**
     * @SWG\Property(type="integer", description="工作年龄")
     */
    public $WorkingYears;

    /**
     * @SWG\Property(type="string", description="城市")
     */
    public $Region;

    /**
     * @SWG\Property(type="string", description="点评标签（数组）")
     */
    public $Labels;

    /**
     * @SWG\Property(type="string", description="点评标题")
     */
    public $Title;

    /**
     * @SWG\Property(type="string", description="点评内容")
     */
    public $Content;

    /**
     * @SWG\Property(type="integer", description="点评打分数")
     */
    public $Scoring;

    /**
     * @SWG\Property(type="integer", description="推荐给朋友分数，推荐：100分  不推荐：50分")
     */
    public $Recommend;

    /**
     * @SWG\Property(type="integer", description="公司前景分数，看好：100分  一般：80分  不看好：50分")
     */
    public $Optimistic;

    /**
     * @SWG\Property(type="integer", description="支持CEO分数，支持：100分  不支持：50分")
     */
    public $SupportCEO;

    /**
     * @SWG\Property(type="integer", description="点赞数")
     */
    public $LikedCount;

    /**
     * @SWG\Property(type="boolean", description="是否点赞")
     */
    public $IsLiked;

    /**
     * @SWG\Property(type="integer", description="阅读数")
     */
    public $ReadCount;

    /**
     * @SWG\Property(type="integer", description="回复数")
     */
    public $ReplyCount;

    /**
     * @SWG\Property(type="string", description="最后回复时间")
     */
    public $LastReplyTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    protected $insert = ['AuditStatus' => 1];

    protected $type = [
        'EntryTime' => 'datetime',
        'DimissionTime' => 'datetime',
        'LastReplyTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'CreatedTime' => 'datetime',
    ];

    public function company()
    {
        return $this->hasOne('Company','CompanyId','CompanyId');
    }

    public function replies()
    {
        return $this->hasMany('OpinionReply');
    }

    public function getLabelsAttr($value)
    {
        $label=[];
        if ($value){
            $label= json_decode($value,true);
        }
        return $label;

    }

    public function getCompanyAttr($value,$data)
    {
        return Company::get($data['CompanyId']);
    }


    //点评头像logo处理
    public function getAvatarAttr($value)
    {
        return  parent::getResourcesSiteRoot($value);
    }

}
