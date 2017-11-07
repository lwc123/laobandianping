<?php

namespace app\appbase\models;

/**
 * @SWG\Definition(required={"SdkVersion","DeviceKey","DeviceKey","Device","Product","Brand"})
 */
class ClientDevice
{   
    /**
     * @SWG\Property(type="integer", description="设备系统Sdk版本")
     */
    public $SdkVersion;
    
    /**
     * @SWG\Property(type="string", description="设备唯一编号")
     */
    public $DeviceKey;    
    
    /**
     * @SWG\Property(type="string", description="设备名称")
     */
    public $Device;    

    /**
     * @SWG\Property(type="string", description="产品名称")
     */
    public $Product;
    
    /**
     * @SWG\Property(type="string", description="品牌")
     */
    public $Brand;    
}