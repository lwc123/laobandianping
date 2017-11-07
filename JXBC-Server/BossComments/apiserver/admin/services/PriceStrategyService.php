<?php

namespace app\admin\services;

use app\workplace\models\PriceStrategy;
use think\Request;
use think\config;
use think\db;
use app\common\modules\ResourceHelper;



class PriceStrategyService {
    public static function PriceStrategyAdd($Activity)
    {
        if (empty ($Activity)) {
            exception('非法请求-0', 412);
        }
        $Activity['ActivityIcon'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Activity['ActivityIcon']);
        $Activity['ActivityHeadFigure'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Activity['ActivityHeadFigure']);
        $Activity['IosActivityHeadFigure'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Activity['IosActivityHeadFigure']);
            $PriceStrategyAdd = PriceStrategy::create ( $Activity );
            if ($PriceStrategyAdd) {
                return true;
            } else {
                return false;
            }
    }

    public static function PriceStrategyUpdate($Activity)
    {
        if (empty ($Activity)) {
            exception('非法请求-0', 412);
        }
        // 头图Android
        if (strstr($Activity ['ActivityHeadFigure'], Config('resources_site_root')) == false) {
            $Activity['ActivityHeadFigure'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Activity['ActivityHeadFigure']);
        } else {
            $Activity['ActivityHeadFigure']  = str_replace(Config('resources_site_root'), '', $Activity ['ActivityHeadFigure']);
        }
        // 头图Ios
        if (strstr($Activity ['IosActivityHeadFigure'], Config('resources_site_root')) == false) {
            $Activity['IosActivityHeadFigure'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Activity['IosActivityHeadFigure']);
        } else {
            $Activity['IosActivityHeadFigure']  = str_replace(Config('resources_site_root'), '', $Activity ['IosActivityHeadFigure']);
        }
        // 图标
        if (strstr($Activity ['ActivityIcon'], Config('resources_site_root')) == false) {
            $Activity['ActivityIcon'] = ResourceHelper::SavePriceStrategyImage(date('Ymd'),$Activity['ActivityIcon']);
        } else {
            $Activity['ActivityIcon']  = str_replace(Config('resources_site_root'), '', $Activity ['ActivityIcon']);
        }

        $PriceStrategyAdd = PriceStrategy::update($Activity, ['ActivityId' => $Activity['ActivityId']]);
        if ($PriceStrategyAdd) {
            return true;
        } else {
            return false;
        }
    }
}