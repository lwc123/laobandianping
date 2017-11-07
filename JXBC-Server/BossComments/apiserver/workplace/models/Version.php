<?php
namespace app\workplace\models;

use app\common\models\BaseModel;

/**
 * @SWG\Tag(
 *   name="Version",
 *   description="APP版本号"
 * )
 */

/**
 * @SWG\Definition(required={"VersionId"})
 */
class Version extends BaseModel
{
    /**
     * @SWG\Property(type="integer", description="ID")
     */
    public $VersionId;
    /**
     * @SWG\Property(type="string", description="系统，android或ios")
     */
    public $AppType;
    /**
     * @SWG\Property(type="integer", description="更新策略枚举，参考枚举UpgradeType")
     */
    public $UpgradeType;
    /**
     * @SWG\Property(type="string", description="当前版本号")
     */
    public $VersionCode;
    /**
     * @SWG\Property(type="string", description="版本名称")
     */
    public $VersionName;
    /**
     * @SWG\Property(type="string", description="最低支持版本号")
     */
    public $LowestSupportVersion;
    /**
     * @SWG\Property(type="string", description="升级说明")
     */
    public $Description;
    /**
     * @SWG\Property(type="string", description="下载地址")
     */
    public $DownloadUrl;
    /**
     * @SWG\Property(type="string", description="发布时间")
     */
    public $CreatedTime;

    /**
     * @SWG\Property(type="string", description="修改时间")
     */
    public $ModifiedTime;


    public static function getVersion($app_version_param){
        if (empty ($app_version_param) || !array_key_exists("AppType", $app_version_param) || !array_key_exists("VersionCode", $app_version_param)) {
            exception('非法请求-2', 412);
        }
        $server_version=Version::where('AppType',$app_version_param['AppType'])->find();

        if(empty($server_version)){
            exception('非法请求-3', 412);
        }

        if(strnatcmp($app_version_param['VersionCode'],$server_version['LowestSupportVersion'])<0){
             $server_version['UpgradeType']=3;
        }else{
            if(strnatcmp($app_version_param['VersionCode'],$server_version['VersionCode'])<0){
                 $server_version['UpgradeType']=2;
            }else{
                 $server_version['UpgradeType']=1;
            }
        }
        return $server_version;
    }


}