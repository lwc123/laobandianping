//
//  PriceStrategyEntity.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(long, ActivityType) {
    ActivityType_CompanyOpen = 1,//公司开户费
    ActivityType_PrivateOpen = 2,//个人开户费
    ActivityType_BoughtComment = 3,//购买档案
    ActivityType_CompanyRenewal = 4//公司续费
};

typedef NS_ENUM(long, PriceStrategyAuditStatus) {
    PriceStrategyAuditStatus_PriceStrategyClose = 1,//关闭
    PriceStrategyAuditStatus_AuditStatusWait = 2,//等待中
    PriceStrategyAuditStatus_AuditStatusUnderway = 3,//进行中
    PriceStrategyAuditStatus_AuditStatusStale = 4//已过期
};


//支付活动返回的
@interface PriceStrategyEntity : JSONModel
@property (nonatomic,assign)long ActivityId;
@property (nonatomic,assign)ActivityType ActivityType;
@property (nonatomic, copy)NSString<Optional> * ActivityName;
@property (nonatomic,assign)double AndroidOriginalPrice;
@property (nonatomic,assign)double AndroidPreferentialPrice;
@property (nonatomic,assign)double IosOriginalPrice;
@property (nonatomic,assign)double IosPreferentialPrice;
@property (nonatomic, copy)NSString<Optional> * IosActivityDescription;

@property (nonatomic, copy)NSString<Optional> * ActivityDescription;
@property (nonatomic, copy)NSString<Optional> * ActivityHeadFigure;
@property (nonatomic, copy)NSString<Optional> * IosActivityHeadFigure;


@property (nonatomic, copy)NSString<Optional> * ActivityIcon;

@property (nonatomic,assign)BOOL IsOpen;
@property (nonatomic,assign)BOOL IsActivity;
@property (nonatomic,assign)PriceStrategyAuditStatus AuditStatus;

@property (nonatomic,strong)NSDate <Optional>*ActivityStartTime;
@property (nonatomic,strong)NSDate <Optional>*ActivityEndTime;
@property (nonatomic,strong)NSDate <Optional>*CreatedTime;
@property (nonatomic,strong)NSDate <Optional>*ModifiedTime;
@end

/*
 ActivityType {
 CompanyOpen (int, optional): 公司开户费 [ 1 ] ,
 PrivateOpen (int, optional): 个人开户费 [ 2 ] ,
 BoughtComment (int, optional): 购买档案 [ 3 ]
 }
 
 */

/*
 PriceStrategy {
 ActivityId (integer, optional): 活动ID ,
 ActivityType (integer): 参见枚举;ActivityType ,
 
 ActivityName (string, optional): 活动名称 ,
 
 AndroidOriginalPrice (integer, optional): Android开户原价 ,
 AndroidPreferentialPrice (integer, optional): Android开户优惠价 ,
 
 IosOriginalPrice (integer, optional): Ios开户原价 ,
 IosPreferentialPrice (integer, optional): Ios开户优惠价 ,
 
 ActivityDescription (string, optional): 活动说明 ,
 ActivityHeadFigure (string, optional): 活动头图 ,
 ActivityIcon (string, optional): 活动图标 ,
 
 IsOpen (boolean, optional): 是否开启活动 ,
 IsActivity (boolean, optional): 判断是否有活动 ,
 
 AuditStatus (integer, optional): 参见枚举;PriceStrategyAuditStatus ,
 ActivityStartTime (string, optional): 活动开始时间 ,
 ActivityEndTime (string, optional): 活动截止时间 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }
 */
