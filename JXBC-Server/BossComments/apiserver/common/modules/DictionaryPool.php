<?php

namespace app\common\modules;
use think\Config;
use think\Cache;
use think\Log;
use app\workplace\models\BizDict;
use app\workplace\models\DictCategoryCode;
use app\workplace\models\DictionaryEntry;

class DictionaryPool {

    public static function refreshEntryCache(DictionaryEntry $entry){
        $categoryCode = BizDict::cache(self::getCategoryCodeKey($entry["DictionaryId"]))->where('DictionaryId',$entry["DictionaryId"])->value('Code');

        Cache::rm(self::getEntryNameKey($categoryCode,$entry["Code"]));
        Cache::rm(self::getEntriesKey($categoryCode));

        //缓存加载
        self::getEntryName($categoryCode,$entry["Code"]);
        self::getDictionaries($categoryCode);
    }

    public static function getEntryName($categoryCode,$entryCode){
        if (empty($categoryCode) || empty($entryCode)){
            return "";
        }
        $text = $entryCode;
        $dictionaryId = self::getCategoryId($categoryCode);
        $name=DictionaryEntry::cache(self::getEntryNameKey($categoryCode,$entryCode))->where(['Code'=>$entryCode,'DictionaryId'=>$dictionaryId])->value('Name');
        if($name){
            $text = $name;
        }
        return $text;
    }
    public static function  getEntryNames($categoryCode,$entryCodes,$separator=","){
        if (empty($categoryCode) || empty($entryCodes)){
            return "";
        }
        $codes = $entryCodes;
        if(!is_array($codes)) {
            $codes = explode(',',$entryCodes);
        }
        $names = [];
        foreach ($codes as $code){
            $names[] = self::getEntryName($categoryCode,$code);
        }

        if(!empty($names) && !empty($separator)) {
            $text = "";
            foreach($names as $item){
                $text.=$item.$separator;
            }
            $names = rtrim($text, $separator);
        }
        return $names;
    }

    public static function  getDictionaries($categoryCodes, $loadDictionary = false){
        if (empty($categoryCodes)){
            return null;
        }

        $codes = $categoryCodes;
        if(!is_array($codes)) {
            $codes = explode(',',$categoryCodes);
        }
        $dictionaries = [];
        foreach ($codes as $code){
            $dictionaries[$code] = self::getDictionaryEntries($code);
        }
        return $dictionaries;
    }

    public static function  getCategoryId($categoryCode){
        $dictionaryId = BizDict::cache(self::getCategoryIdKey($categoryCode))->where('Code',$categoryCode)->value('DictionaryId');
        return $dictionaryId;
    }

    private static function  getDictionaryEntries($categoryCode){
        if (empty($categoryCode)){
            return null;
        }

        $dictionaryId = self::getCategoryId($categoryCode);
        $entries=DictionaryEntry::cache(self::getEntriesKey($categoryCode))->where(['DictionaryId'=>$dictionaryId])->order("Sequence desc, Code asc")->select();

        return $entries;
    }

    private static function getCategoryIdKey($categoryCode) {
        return sprintf("Dic:CategoryId_%s",strtoupper($categoryCode));
    }
    private static function getCategoryCodeKey($dictionaryId) {
        return sprintf("Dic:CategoryCode_%s",$dictionaryId);
    }
    private static function getEntryNameKey($categoryCode, $entryCode) {
        return sprintf("Dic:EntryName_%s-%s",strtoupper($categoryCode), $entryCode);
    }
    private static function getDictionaryKey($categoryCode) {
        return sprintf("Dic:%s",strtoupper($categoryCode));
    }
    private static function getEntriesKey($categoryCode) {
        return sprintf("Dic:Entries_%s",strtoupper($categoryCode));
    }
}
