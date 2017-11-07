#import <JSONModel/JSONModel.h>


typedef NS_ENUM(int, TradeType) {
    TradeType_PersonalToPersonal = 1,// 个人对个人交易[ 1 ]
    TradeType_PersonalToOrganization, //个人对公交易 [ 2 ] ,
    TradeType_OrganizationToPersonal,//公对私交易 [ 3 ]
    TradeType_OrganizationToOrganization// 公对公交易 [ 4 ]
};

@interface PaymentEntity : JSONModel

/**交易编号(服务器生成) */
@property (nonatomic,copy)NSString<Optional> *TradeCode;

@property (nonatomic,assign)NSInteger TradeMode;

//买家标识(对私交易：当前用户PassportId, 不需要设置；开通服务传-1
//对公交易：所属机构的机构Id),必须传入该值 ,
@property (nonatomic,strong)NSNumber<Optional> * BuyerId;
//交易发起人
@property (nonatomic,assign)long OwnerId;

@property (nonatomic,copy)NSString<Optional> *PayWay;
@property (nonatomic,copy)NSString *BizSource;
//商品类别
@property (nonatomic,copy)NSString<Optional> *CommodityCategory;
//商品标识 ,
@property (nonatomic,copy)NSString<Optional> *CommodityCode;
//商品数量 
@property (nonatomic,strong)NSNumber<Optional> *CommodityQuantity;
@property (nonatomic,copy)NSString<Optional> *CommoditySubject;
@property (nonatomic,copy)NSString<Optional> *MemberSevier;
//交易类型
@property (nonatomic,assign)NSInteger TradeType;

//商品摘要描述 (收益的时候显示)
@property (nonatomic,copy)NSString<Optional> *CommoditySummary;
//总金额
@property (nonatomic,assign)double TotalFee;
//商品扩展信息(JSON),开户时参数示例：当初传的时候是josnStr
@property (nonatomic,copy)NSString<Optional> *CommodityExtension;

@property (nonatomic,copy)NSString<Optional> *SignedParams;
@end
