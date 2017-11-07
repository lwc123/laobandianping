<?php

namespace app\opinion\models;
use think\Config;
use think\db\Query;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={""})
 */
class CompanyBrowseRecord extends OpinionBase {

    /**
     * @SWG\Property(type="integer", description="浏览口碑公司记录Id")
     */
    public $BrowseId;

    /**
     * @SWG\Property(type="integer", description="口碑公司Id")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="用户ID")
     */
    public $PassportId;

    /**
     * @SWG\Property(type="string", description="查看时间")
     */
    public $BrowseTime;

    /**
     * @SWG\Property(type="string", description="创建时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;

    protected $type = [
        'BrowseTime' => 'datetime',
        'ModifiedTime' => 'datetime',
        'CreatedTime' => 'datetime',
    ];


    public static function BrowseRecord($Browse){
        if (empty ($Browse)) {
            exception('非法请求-0', 412);
        }
        $BrowseRecord=CompanyBrowseRecord::where(['PassportId'=>$Browse['PassportId'],'CompanyId'=>$Browse['CompanyId']])->find();
        if (empty($BrowseRecord)){
            $Browse['BrowseTime']=date('Y-m-d H:i:s',time());
            $create = new CompanyBrowseRecord($Browse);
            $create->allowField(true)->save();
        }else{
            $BrowseRecord['BrowseTime']=date('Y-m-d H:i:s',time());
            $BrowseRecord->save();
        }
    }

}
