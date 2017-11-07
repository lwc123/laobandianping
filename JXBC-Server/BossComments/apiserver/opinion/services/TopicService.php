<?php
/**
 * Created by PhpStorm.
 * User: 1
 * Date: 2017/4/17
 * Time: 14:06
 */

namespace app\opinion\services;
use app\opinion\models\Topic;
use app\opinion\models\TopicCompany;
use app\common\modules\ResourceHelper;
class TopicService
{

    /**
     *  专题列表  口碑首页
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicList()
    {
        $TopicList =  Topic::where('IsOpen',1)->order("TopicOrder desc")->select();
        return $TopicList;
    }

    /**
     *  专题列表  全部  后台
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicListAll()
    {
        $TopicList =  Topic::order("TopicOrder desc")->select();
        return $TopicList;
    }

    /**
     *  查找单个专题
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicFind($TopicId)
    {
        $TopicFind =  Topic::where('TopicId',$TopicId)->find();
        return $TopicFind;
    }

    /**
     *  查找单个专题 公司的个数
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicCompanyCount($TopicId)
    {
        $TopicCompanyCount =  TopicCompany::where('TopicId',$TopicId)->count();
        return $TopicCompanyCount;
    }

    /**
     *  专题公司列表
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicCompanyList($TopicId)
    {
       $TopicCompanyList =  TopicCompany::where('TopicId',$TopicId)->order("companyorder desc")->select();
        return $TopicCompanyList;
    }

    /**
     *  开启专题
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicOpen($TopicId)
    {
        $TopicOpen =  Topic::where('TopicId', $TopicId)->update(['IsOpen' => 1]);
        return $TopicOpen;
    }


    /**
     *  关闭专题
     * @access public
     * @param string
     * @return integer
     */
    public static function TopicClose($TopicId)
    {
        $TopicOpen =  Topic::where('TopicId', $TopicId)->update(['IsOpen' => 0]);
        return $TopicOpen;
    }

    /**专题添加
     * @param $Topic
     * @return bool
     */
    public static function TopicAdd($Topic)
    {
        if (empty ($Topic)) {
            exception('非法请求-0', 412);
        }
        $Topic['HeadFigure'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Topic['HeadFigure']);
        $Topic['BannerPicture'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Topic['BannerPicture']);
        $TopicAdd = Topic::create ( $Topic );
        if ($TopicAdd) {
            return true;
        } else {
            return false;
        }
    }

    /**专题修改
     * @param $Activity
     * @return bool
     */
    public static function TopicUpdate($Topic)
    {
        if (empty ($Topic)) {
            exception('非法请求-0', 412);
        }
        // 头图
        if (strstr($Topic ['HeadFigure'], Config('resources_site_root')) == false) {
            $Topic['HeadFigure'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Topic['HeadFigure']);
        } else {
            $Topic['HeadFigure']  = str_replace(Config('resources_site_root'), '', $Topic ['HeadFigure']);
        }
        // Banner图
        if (strstr($Topic ['BannerPicture'], Config('resources_site_root')) == false) {
            $Topic['BannerPicture'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Topic['BannerPicture']);
        } else {
            $Topic['BannerPicture']  = str_replace(Config('resources_site_root'), '', $Topic ['BannerPicture']);
        }
        $TopicAdd = Topic::update($Topic, ['TopicId' => $Topic['TopicId']]);
        if ($TopicAdd) {
            return true;
        } else {
            return false;
        }
    }


    public static function Detail($param)
    {
        if (empty ($param)||empty ($param['TopicId'])) {
            exception('非法请求-0', 412);
        }
        $Detail = Topic::get($param['TopicId']);
        if (empty($Detail)) {
            return null;
        }
         $list= TopicCompany::all(function($query) use ($param){
            $query->where('TopicId',$param['TopicId'])->page($param ['Page'], $param ['Size'])->order('CompanyOrder desc,CreatedTime desc');
        },'Company');
        $Company=[];
        if ($list){
            foreach ($list as $key=>$val){
                $Company[]=$val['Company'];
            }
        }

        $Detail['Companys'] =$Company;
        return $Detail;
    }
}
