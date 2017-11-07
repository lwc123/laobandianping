<?php

namespace app\common\modules;
use think\Config;
use think\log;

class ResourceHelper {
    const AvatarBasicDirectory = "_files/avatar";
    const OpenEnterpriseRequestBasicDirectory = "_files/open-enterprise-request";
    const EmployeArchiveBasicDirectory = "_files/employe-archive";
    const EmployeArchiveCommentBasicDirectory = "_files/employe-archive-comment";
    const BossDynamicBasicDirectory = '_files/boss-dynamic';
    const PriceStrategyBasicDirectory = '_files/price-strategy';
    const EmployeArchiveExcelDirectory = '_files/employe-archive-excel';
    const OpinionCompanyLogoDirectory = '_files/opinion-company';

    
	public static function ToAbsoluteUri($path) {
		$absoluteUri = $path;
        if (substr($absoluteUri,0,5) != "http:") {
            $absoluteUri = Config::get("resources_site_root").$path;
        }
        return $absoluteUri;
	}
    public static function OpinionCompanyLogo($companyId, $imageStream) {
        return self::SaveBizFile(ResourceHelper::OpinionCompanyLogoDirectory, $companyId, $imageStream, "jpg");
    }

    public static function SaveEmployeArchiveExcel($bizId, $fileStream) {
        return self::SaveBizFile(ResourceHelper::EmployeArchiveExcelDirectory, $bizId, $fileStream, "xlsx");
    }

    public static function SavePriceStrategyImage($bizId, $imageStream) {
        return self::SaveBizFile(ResourceHelper::PriceStrategyBasicDirectory, $bizId, $imageStream, "jpg");
    }

    public static function SaveAvatar($passportId, $imageStream) {
        return self::SaveBizFile(ResourceHelper::AvatarBasicDirectory, $passportId, $imageStream, "jpg");
    }

    public static function SaveOpenEnterpriseRequestImage($companyId, $imageStream) {        
        return self::SaveBizFile(ResourceHelper::OpenEnterpriseRequestBasicDirectory, $companyId, $imageStream, "jpg");
    }
    
    public static function SaveEmployeArchiveImage($bizId, $imageStream) {        
        return self::SaveBizFile(ResourceHelper::EmployeArchiveBasicDirectory, $bizId, $imageStream, "jpg");
    }


    public static function SaveBossDynamicImage($bizId, $imageStream) {
        return self::SaveBizFile(ResourceHelper::BossDynamicBasicDirectory, $bizId, $imageStream, "jpg");
    }


    public static function SaveArchiveCommentImage($bizId, $imageStream) {        
        return self::SaveBizFile(ResourceHelper::EmployeArchiveCommentBasicDirectory, $bizId, $imageStream, "jpg");
    }    
    
    public static function SaveArchiveCommentVoice($bizId, $voiceStream) {
    	return self::SaveBizFile(ResourceHelper::EmployeArchiveCommentBasicDirectory, $bizId, $voiceStream, "mp3");
    }
    
    public static function SaveBizFile($basicDirectory, $bizId, $streamData, $fileExtension) {
        $forlder = "/".$basicDirectory."/".strval(floor($bizId/1000)+1) . '/'.fmod($bizId,1000).'/';
        $fileName = $bizId."-".md5($streamData).'.'.$fileExtension;
        $physicalForlder = Config::get("resources_physical_root").$forlder;
       // echo $physicalForlder;die;
		if (! file_exists ( $physicalForlder )) {
			mkdir ( $physicalForlder, 0700, true );
		}
		$physicalFile = $physicalForlder.$fileName;
		if(config("app_debug")) {
            Log::Info("save file to ".$physicalFile);
        }
		if (file_put_contents ( $physicalFile, base64_decode ( $streamData ) )) {
			return $forlder.$fileName;
		} else {
            exception('保存文件失败', 500); 
        }        
    }
}
