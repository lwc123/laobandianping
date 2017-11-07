<?php
namespace app\workplace\models;
use app\common\models\BaseModel;



/**
 * @SWG\Tag(
 * name="BossDynamic",
 * description="老板圈动态",
 * )
 */
/**
 * @SWG\Definition(required={"DynamicId","Img","Content"})
 */

class BossDynamic extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="动态id")
     */
    public $DynamicId;

    /**
     * @SWG\Property(ref="#/definitions/Company", description="公司id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="发布用户id")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string", description="图片地址(数组)")
     */
    public $Img;

    /**
     * @SWG\Property(type="string", description="动态内容字符串")
     */
    public $Content;

    /**
     * @SWG\Property(type="string", description="公司简称")
     */
    public $CompanyAbbr;

    /**
     * @SWG\Property(type="boolean", description="是否赞过")
     */
    public $IsLiked;

    /**
     * @SWG\Property(type="string", description="发布时间")
     */
    public $CreatedTime;


    /**
     * @SWG\Property(type="integer", description="评论数")
     */
    public $CommentCount;


    /**
 * @SWG\Property(ref="#/definitions/BossDynamicComment", description="评论内容列表")
 */
    public $Comment;


    /**
     * @SWG\Property(type="string", description="点赞数")
     */
    public $LikedNum;


    protected $type = [
        'CreatedTime'   => 'datetime',
        'ModifiedTime'  => 'datetime'
    ];


    public function getDynamicListByPassportId($passport_id,$start,$size){

        return BossDynamic::where('PassportId',$passport_id)->where('Status',1)->
        field('DynamicId,CompanyId,PassportId,Content,Img,CreatedTime,CommentCount,LikedNum,Status')->order('DynamicId DESC')->limit("$start,$size")->select();

    }
    // 关联公司信息
    public function getCompanyAttr($value,$data)
    {
        return  $this->Company()->cache(true)->find($data['CompanyId']);
    }

    public function Company()
    {
        return $this->belongsTo('Company','CompanyId');
    }
    // 关联评论信息
    public function getCommentAttr($value,$data)
    {
        $Comments= BossDynamicComment::getDynamicCommentList($data['DynamicId']);
        foreach ($Comments as $key =>$val){
            $Comments[$key]['CompanyAbbr']=$this->getCompanyAttr(null,$val)['CompanyAbbr'];
        }
        return $Comments;
    }


    public function getDynamicList($start,$size){

        return BossDynamic::where('Status',1)->field('DynamicId,CompanyId,PassportId,Content,Img,CreatedTime,CommentCount,LikedNum,Status')->order('DynamicId DESC')->limit("$start,$size")->select();
    }



}
