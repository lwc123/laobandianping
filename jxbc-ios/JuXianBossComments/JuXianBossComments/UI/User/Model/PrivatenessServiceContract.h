//
//  PrivatenessServiceContract.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PrivatenessServiceContract : JSONModel


@property (nonatomic,strong)NSNumber<Optional> *ContractId;
@property (nonatomic,strong)NSNumber<Optional> * PassportId;
@property (nonatomic,copy)NSString<Optional> * RealName;
@property (nonatomic,copy)NSString<Optional> * IDCard;

@property (nonatomic,copy)NSString<Optional> * ContractStatus;
@property (nonatomic,strong)NSDate<Optional> * ServiceBeginTime;
@property (nonatomic,strong)NSDate<Optional> * ServiceEndTime;
@property (nonatomic,strong)NSNumber<Optional> * TotalFee;
@property (nonatomic,copy)NSString<Optional> * PaidWay;
@property (nonatomic,copy)NSString<Optional> * TradeCode;

@property (nonatomic,copy)NSString<Optional> * AdditionalInfo;
@property (nonatomic,strong)NSDate<Optional> * CreatedTime;
@property (nonatomic,strong)NSDate<Optional> * ModifiedTime;
@end
/*
 PrivatenessServiceContract {
 ContractId (integer, optional): ,
 PassportId (integer, optional): 用户ID ,
 
 RealName (string, optional): 真实姓名 ,
 IDCard (string, optional): 身份证号 ,
 ContractStatus (string, optional): 合同状态，1未生效，2生效，3过期 ,
 ServiceBeginTime (string, optional): 签约日期 ,
 ServiceEndTime (string, optional): 终止日期 ,
 
 TotalFee (integer, optional): 支付费用 ,
 PaidWay (string, optional): 支付渠道 ,
 TradeCode (string, optional): 合同号 ,
 AdditionalInfo (string, optional): 附加信息 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }
 */
