<?php
namespace app\workplace\models;
use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 * name="Dictionary",
 * description="业务字典",
 * )
 */
/**
 * @SWG\Definition(required={""})
 */

class EmployeArchiveErrorLog extends BaseModel
{

    /**
     * @SWG\Property(type="integer", description="档案错误记录id")
     */
    public $ErrorId;

    /**
     * @SWG\Property(type="integer", description="公司Id")
     */
    public $CompanyId;

    /**
     *  @SWG\Property(type="integer", description="提交人Id")
     */
    public $PresenterId;


    /**
     * @SWG\Property(type="string", description="错误code")
     */
    public $ErrorCode;

    /**
     * @SWG\Property(type="string", description="错误信息")
     */
    public $ErrorMsg;


    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;


    /**
     * @SWG\Property(type="string", description="别名，索引名？")
     */
    public $ModifiedTime;



}
