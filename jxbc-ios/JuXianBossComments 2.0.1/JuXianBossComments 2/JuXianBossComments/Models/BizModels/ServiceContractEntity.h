//
//  ServiceContractEntity.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JXUserProfile.h"
//#import "JXConsultantProfile.h"
#import "CareerServiceEntity.h"
//#import "JuXianTalentBank-Bridging-Header.h"

typedef enum {// Rejected = 99
    
    ContractStatusPaid = -1,
    ContractStatusServicing = 1,
    ContractStatusServiceEnd = 2,
    ContractStatusRateCompleted = 3,
    ContractStatusRejected = 99
}ContractStatusType;

@interface ServiceContractEntity : JSONModel

@property (nonatomic,copy)NSString<Optional> *ContractCode;
//@property (nonatomic,assign)long ServiceId;
@property (nonatomic,assign)long BuyerId;
//@property (nonatomic,assign)long SellerId;

@property (nonatomic,assign)ContractStatusType ContractStatus;

@property (nonatomic,strong)NSDate<Optional> *ServiceBeginTime;
@property (nonatomic,strong)NSDate<Optional> *ServiceEndTime;
@property (nonatomic,assign)double TotalFee;
@property (nonatomic,copy)NSString<Optional> *PaidWay;
@property (nonatomic,copy)NSString<Optional> *TradeCode;
@property (nonatomic,copy)NSString<Optional> *Id;
@property (nonatomic,assign)int PersistentState;
@property (nonatomic,assign)int ServicePeriod;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,strong)NSDate<Optional> *CreatedTime;


- (NSInteger) getServiceMonths;
@end


/*
 "ContractCode": "sample string 11",
 "BuyerId": 2,
 "ContractStatus": 0,
 "ServiceBeginTime": "2016-10-28T02:26:00Z",
 "ServiceEndTime": "2016-10-28T02:26:00Z",
 "ServicePeriod": 5,
 "TotalFee": 6.0,
 "PaidWay": "sample string 7",
 "TradeCode": "sample string 8",
 "CreatedTime": "2016-10-28T02:26:00Z",
 "ModifiedTime": "2016-10-28T02:26:00Z",
 "Id": "sample string 11",
 "PersistentState": 0
 
 */

