<?php
namespace app\workplace\controller;
use app\workplace\models\BizDict;
use think\Controller;
use think\Db;
use think\Request;
use think\Config;
use app\appbase\models\Enums;
use app\common\modules\DictionaryPool;

class BizDictController extends Controller
{


    /**
     * @SWG\GET(
     * path="/workplace/BizDict/getBizByCode",
     * summary="获取业务字典，使用CategoryCode和code获取单个字典值，使用code获取字典集合",
     * description="",
     * tags={"Dictionary"},
     * @SWG\Parameter(
     * name="Code",
     * in="query",
     * description="硕士(1),行业(industry),薪资水平(salary),城市(city),返聘意愿(panicked),时间段(period),离任原因(leaving)。多条件逗号隔开，例如：getBizByCode?Code=academic,industry,city",
     * required=true,
     * type="string"
     * ),
     *
     * @SWG\Parameter(
     * name="CategoryCode",
     * in="query",
     * description="分类code。学历(academic),行业(industry),薪资水平(salary),城市(city),返聘意愿(panicked),时间段(period),离任原因(leaving)例如：getBizByCode?Code=academic&CategoryCode=city",
     * required=false,
     * type="string"
     * ),
     *
     * @SWG\Response(
     * response=200,
     * description="Wait",
     * @SWG\Schema(ref="#/definitions/BizDict")
     * ),
     * @SWG\Response(
     * response="412",
     * description="错误提示",
     * @SWG\Schema(
     * ref="#/definitions/Error"
     * )
     * )
     * )
     */
    public function getBizByCode(Request $request){
        header("Expires: ".gmdate("D, d M Y H:i:s", time() + config("dictionary_expires"))." GMT");
        return DictionaryPool::getDictionaries($request->get('Code'));
        $code = $request->param('Code');
        $category_code = $request->param('CategoryCode');
        $code = explode(',',$code);

        $biz_data = array();

        foreach ($code as $key=>$value){

            if (!empty(trim($category_code))){

                $dictionary_id = BizDict::where('Code',$category_code)->value('DictionaryId');
                $biz_data[$category_code] = Db::table('dictionary_entry')->where('Code',htmlspecialchars(trim($value)))->where('DictionaryId',$dictionary_id)->cache(true)->find();

            }else{

                $dictionary_id = BizDict::where('Code',$value)->field('DictionaryId,Code,Name')->order('Sequence desc')->select();

                if (!empty($dictionary_id)){

                    foreach ($dictionary_id as $k=>$v){

                        $biz_data[$v['Code']] = Db::table('dictionary_entry')->where('DictionaryId',$v['DictionaryId'])->field('DictionaryId,Code,Name,Level,ParentId,RelativeKeys,IsHotspot')->cache(true)->order('Sequence desc')->select();
                    }

                }else{

                    $biz_data[$value] = Db::table('dictionary_entry')->where('Code',htmlspecialchars(trim($value)))->cache(true)->order('Sequence desc')->select();
                }

            }
        }




        return $biz_data;
    }

}