<?php

namespace app\common\modules;
use think\Config;
use think\Cache;

class CacheManager {
    const SMSCacheName = "workplace:sms";
    
    public static function getValueFromSMSCache($key) {        
        return Cache::get(CacheManager::FormatKeyForGroup(CacheManager::SMSCacheName,$key));
    }
    
    public static function FormatKeyForGroup($group, $key) {
        return "_".$group."_".$key;
    }
}
