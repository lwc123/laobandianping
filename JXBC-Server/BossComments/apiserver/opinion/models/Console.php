<?php

namespace app\opinion\models;

/**
 * @SWG\Definition(required={""})
 */
class Console extends OpinionBase {

    /**
    /**
     * @SWG\Property(type="integer", description="我的点评总数")
     */
    public $OpinionTotal;

    /**
     * @SWG\Property(type="integer", description="我的关注企业总数")
     */
    public $ConcernedTotal;

    /**
     * @SWG\Property(type="boolean", description="是否显示红点")
     */
    public $IsRedDot;

    public static function Console($PassportId){
        if (empty ($PassportId)) {
            exception('非法请求-0', 412);
        }
        $console=[];
        $console['OpinionTotal']=Opinion::where(['PassportId'=>$PassportId])->count();
        $console['ConcernedTotal']=Concerned::where(['Status'=> 1,'PassportId'=>$PassportId])->count();
        $console['IsRedDot']=true;
        return $console;
    }

}
