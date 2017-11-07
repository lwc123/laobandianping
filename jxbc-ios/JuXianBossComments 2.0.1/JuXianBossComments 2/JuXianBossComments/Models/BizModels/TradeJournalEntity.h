
//
//  GratuityJournalEntity.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/24.
//  Copyright © 2016年 Max. All rights reserved.
//

//#import <JSONModel/JSONModel.h>
#import "PaymentEntity.h"

@interface TradeJournalEntity : PaymentEntity

//订单id
@property (nonatomic,copy)NSString<Optional> *TargetBizTradeCode;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

/*
@property (nonatomic,copy)NSString *TradeCode;
@property (nonatomic,assign)int TradeMode;
@property (nonatomic,copy)NSString *Title;
@property (nonatomic,assign)double TotalFee;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,assign)int CommodityQuantity;
@property (nonatomic,copy)NSString *BizSource;
 */
@end
