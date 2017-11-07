<?php
namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"CommentId"})
 */
class ArchiveCommentLog extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $LogId;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $PresenterId;

    /**
     * @SWG\Property(type="integer", description="")
     */
    public $CommentId;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;

    /**
     * @SWG\Property(ref="#/definitions/CompanyMember",description="修改人信息")
     */
    public $CompanyMember;


    public static  function getList($data)
    {
        $list=ArchiveCommentLog::where(['CompanyId'=>$data['CompanyId'],'CommentId'=>$data['CommentId']])->select();
        if (empty($list)){
            return $list;
        }
        foreach ($list as $key => $val){
            $list[$key]['CompanyMember']=CompanyMember::getPassportRoleByCompanyId($val['CompanyId'],$val['PresenterId']);
        }
        return $list;
    }

}

