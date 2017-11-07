<?php

namespace app\common\modules;
use think\Config;
use app\common\models\Pagination;

class DbHelper { 
    const UtcDateFormat = 'Y-m-d\TH:i:s\Z';
    const LocalDateFormat = 'Y-m-d H:i:s';
    private static $MaxDbDate = null;
    private static $ZeroDbDate = null;
    
	public static function BuildPagination($page=null,$size=null) {
		$result = new Pagination;
		if(empty($page) || intval($page) < 1) {
            $result->PageIndex = 1;
        } else {
            $result->PageIndex = intval($page);
        }
        if(empty($size) || intval($size) < 1) {
            $result->PageSize = 10;
        } else {
            $result->PageSize = intval($size);
        }
        $result->TotalCount = -1;
        
		return $result;
	}
 
	public static function getMaxDbDate() {
        if(empty($MaxDbDate)) {
            $maxUtcDate = (new \DateTime('3000-01-01', timezone_open('UTC')))->format(DbHelper::UtcDateFormat);
            $MaxDbDate = self::toLocalDateTime($maxUtcDate);
        }
        return $MaxDbDate;
    }
    
	public static function getZeroDbDate() {
        if(empty($ZeroDbDate)) {
            $zeroUtcDate = (new \DateTime('1970-01-01', timezone_open('UTC')))->format(DbHelper::UtcDateFormat);
            $ZeroDbDate = self::toLocalDateTime($zeroUtcDate);
        }
        return $ZeroDbDate;
    }  

    
	public static function toUtcDateTime($time) {
        if(is_string($time) && (strrchr($time,'Z')!="Z" || strlen($time)>=12)) {
            return (new \DateTime($time, timezone_open(Config::get('default_timezone'))))->setTimezone(timezone_open('UTC'))->format(DbHelper::UtcDateFormat);
        }
        return $time;
    }
	public static function toLocalDateTime($time) {
        if(is_string($time) && (strrchr($time,'Z')=="Z" || strlen($time)<12)) {
            return (new \DateTime($time, timezone_open('UTC')))->setTimezone(timezone_open(Config::get('default_timezone')))->format(DbHelper::LocalDateFormat);
        }
        return $time;
    }    
}
