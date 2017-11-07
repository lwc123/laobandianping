<?php
namespace app\appbase\models;

/**
 * @SWG\Definition()
 */
class PayWays
{  
    /**
     * @SWG\Property(type="string",description="系统支付")
     */
    public $System;    
    const System = "System";
    /**
     * @SWG\Property(type="string",description="钱包支付")
     */
    public $Wallet; 
    const Wallet = "Wallet";
    /**
     * @SWG\Property(type="string",description="支付宝支付")
     */
    public $Alipay; 
    const Alipay = "Alipay";
    /**
     * @SWG\Property(type="string",description="微信支付")
     */
    public $Wechat;    
    const Wechat = "Wechat";

    /**
     * @SWG\Property(type="string",description="苹果内购")
     */
    public $AppleIAP;
    const AppleIAP = "AppleIAP";

    /**
     * @SWG\Property(type="string",description="APP支付")
     */
    public $Route_APP;
    const Route_APP = "APP";

    /**
     * @SWG\Property(type="string",description="H5支付")
     */
    public $Route_H5;
    const Route_H5 = "H5";

    /**
     * @SWG\Property(type="string",description="二维码支付")
     */
    public $Route_QRCODE;
    const Route_QRCODE = "QRCODE";
}
