<?php

namespace app\workplace\services;

use app\workplace\models\ActivityType;
use app\workplace\models\PriceStrategy;
use think\Db;
use think\Request;
use app\workplace\models\PriceStrategyAuditStatus;

class PriceStrategyService
{
    /**
     *  价格策略  当前活动
     *
     * @access public
     * @param string $PostJob
     *            数据JSON
     * @return integer
     */
    public static function CurrentActivity($CurrentActivity)
    {
        if (empty ($CurrentActivity) || empty ($CurrentActivity ['ActivityType'])) {
            exception('非法请求-0', 412);
        }
        if(isset($CurrentActivity ['Version'])){
            $Version=$CurrentActivity ['Version'];
        }else{
            $Version='1.3.2';
        }
        $currentActivity = PriceStrategy::where(['ActivityType' => $CurrentActivity['ActivityType'], 'AuditStatus' => 3])->where('Version' ,'elt', $Version)->order('ActivityStartTime desc,ActivityId desc,IsActivity desc,Version desc')->find();

        if ($currentActivity){
            $currentActivity['IsOpen'] = true;
            $currentActivity['IsActivity'] = $currentActivity['IsActivity'] ==1 ?true:false;
        }else{
            $currentActivity['IsOpen'] = true;
            $currentActivity['IsActivity']=false;
        }
        return $currentActivity;
    }

    public static function GetLatestVersion(){
        return PriceStrategy::where(['ActivityType' => ActivityType::CompanyOpen, 'AuditStatus' => 3])->order('IsActivity desc,Version desc')->value('Version');
    }

}
