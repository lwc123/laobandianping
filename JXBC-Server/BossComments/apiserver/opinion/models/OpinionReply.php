<?php

namespace app\opinion\models;

use app\common\models\BaseModel;


/**
 * @SWG\Definition(required={"OpinionId","Content"})
 */

class OpinionReply extends OpinionBase
{

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $ReplyId;

    /**
     * @SWG\Property(type="integer", description="点评ID")
     */
    public $OpinionId;

    /**
     * @SWG\Property(type="integer", description="B端公司ID")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="C端口碑公司ID")
     */
    public $OpinionCompanyId;

    /**
     * @SWG\Property(type="integer", description="提交人")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="integer", description="修改人")
     */
    public $ModifiedId;

    /**
     * @SWG\Property(type="integer", description="评论类型，0个人回复，1公司回复")
     */
    public $ReplyType;

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
     * @SWG\Property(type="string", description="点评内容")
     */
    public $Content;


    /**
     * @SWG\Property(type="string", description="导入时间")
     */
    public $LeadingTime;

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
        'LeadingTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'CreatedTime' => 'datetime',
    ];

}
