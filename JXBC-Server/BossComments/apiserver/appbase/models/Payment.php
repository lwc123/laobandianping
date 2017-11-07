<?php

namespace app\appbase\models;
use app\common\models\BaseModel;

/**
 * @SWG\Definition(required={"OwnerId","TradeType","TradeMode","PayWay","BizSource","CommoditySubject","TotalFee","BizSource","BuyerId"})
 */
class Payment extends BaseModel
{   
    /**
     * @SWG\Property(description="交易编号(服务器生成)", type="string")
     */    
    public $TradeCode;

    /**
     * @SWG\Property(description="父交易编号(A购买B时，A有一条交易记录，B会产生一个以A交易号为父交易编号的交易记录)", type="string")
     */
    public $ParentTradeCode;

    /**
     * @SWG\Property(description="交易所有人(对私交易：当前用户PassportId, 不需要设置；<br/>对公交易：所属机构的机构Id),必须传入该值", type="integer", format="int64")
     */
    public $OwnerId;
    
    /**
     * @SWG\Property(description="交易类型，参见枚举[TradeType]", type="integer")
     */
    public $TradeType;
    
    /**
     * @SWG\Property(description="交易模式，参见枚举[TradeMode]", type="integer")
     */
    public $TradeMode;    

    /**
     * @SWG\Property(description="交易路径，可选项参见常量定义[PayWays]", type="string")
     */    
    public $PayWay;
    
    /**
     * @SWG\Property(description="交易路径，可选项参见常量定义[PayWays]", type="string")
     */    
    public $PayRoute;    
    
    /**
     * @SWG\Property(description="业务来源，可选项参见常量定义[BizSources]", type="string")
     */    
    public $BizSource; 
    
    /**
     * @SWG\Property(description="总金额", type="number")
     */    
    public $TotalFee;     

    /**
     * @SWG\Property(description="商品类别", type="string")
     */    
    public $CommodityCategory; 
    /**
     * @SWG\Property(description="商品标识", type="string")
     */    
    public $CommodityCode; 
    /**
     * @SWG\Property(description="商品数量", type="integer")
     */    
    public $CommodityQuantity; 
    /**
     * @SWG\Property(description="商品标题", type="string")
     */    
    public $CommoditySubject; 
    /**
     * @SWG\Property(description="商品摘要描述", type="string")
     */    
    public $CommoditySummary;    
    /**
     * @SWG\Property(description="商品扩展信息(JSON),<br/>开户时参数示例：参加数据定义[OpenEnterpriseRequest]", type="string")
     */    
    public $CommodityExtension;    
    
    /**
     * @SWG\Property(description="支付成功后的跳转地址", type="string")
     */    
    public $ReturnUrl;     
    
    /**
     * @SWG\Property(description="交易发起人,买家PassportId", type="integer")
     */
    public $BuyerId;    
    /**
     * @SWG\Property(description="交易发起人,卖家PassportId", type="integer")
     */
    public $SellerId;     

    /**
     * @SWG\Property(type="string")
     */    
    public $ClientIP; 
}