<?php

namespace app\opinion\models;

use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="LabelLibrary",
 *   description="口碑标签API"
 * )
 */

/**
 * @SWG\Definition(required={"LabelName"})
 */
class  LabelLibrary extends OpinionBase
{
    /**
     * @SWG\Property(type="integer", description="标签Id")
     */
    public $LabelId;

    /**
     * @SWG\Property(type="integer", description="公司ID")
     */
    public $CompanyId;

    /**
     * @SWG\Property(type="integer", description="提交人ID")
     */
    public $PresenterId;

    /**
     * @SWG\Property(type="string", description="标签名字")
     */
    public $LabelName;

    /**
     * @SWG\Property(type="integer", description="标签热度")
     */
    public $LabelHot;

    /**
     * @SWG\Property(type="integer", description="标签排序")
     */
    public $LabelSort;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="")
     */
    public $ModifiedTime;


    /**
     * 企业标签热度计算
     * @param $Opinion
     * @param $LabelType
     */
    public static function Labels($Opinion,$LabelType)
    {
        if (empty ($Opinion) || empty ($Opinion ['CompanyId']) || empty ($Opinion ['Labels'])) {
            exception('非法请求-Labels', 412);
        }
        $saveLabel = [];
        $label_library = LabelLibrary::where(['CompanyId' => $Opinion ['CompanyId']])->select();
        if (empty($label_library)) {
            foreach ($Opinion ['Labels'] as $key=>$val){
                $saveLabel[$key]['CompanyId']=$Opinion ['CompanyId'];
                $saveLabel[$key]['LabelName']=$val;
            }
        }else{
            foreach ($Opinion ['Labels'] as $key=>$val){
                foreach ($label_library as $k=>$v){
                    if ($val===$v['LabelName']){
                        $saveLabel[$key]['LabelId']=$v ['LabelId'];
                        $saveLabel[$key]['LabelHot']=$v ['LabelHot']+1;
                    }else{
                        $saveLabel[$key]['CompanyId']=$Opinion ['CompanyId'];
                        $saveLabel[$key]['LabelName']=$val;
                    }
                }

            }
        }
        $data = new LabelLibrary;
        $data->saveAll($saveLabel);

        //是否更新热度
        if ($LabelType==1){
            $LabelHot=LabelLibrary::where(['CompanyId' => $Opinion ['CompanyId']])->order('LabelHot desc,ModifiedTime desc,CreatedTime desc')->limit(5)->select();
            if ($LabelHot){
                $hot=[];
                foreach ($LabelHot as $key=>$val){
                    $hot[$key]=$val['LabelName'];
                }
                $hotString=json_encode($hot,JSON_UNESCAPED_UNICODE);
                Company::update(['CompanyId' => $Opinion ['CompanyId'], 'Labels' => $hotString]);
            }
        }
    }


}