//
//  WalletEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(int, WalletType) {
    WalletType_None = 0,//未指定类型
    WalletType_Privateness = 1,//私人钱包
    WalletType_Organizatio = 2//机构钱包
    
};

@interface WalletEntity : JSONModel
@property (nonatomic,assign)long WalletId;
@property (nonatomic,assign)long WalletType;
@property (nonatomic,assign)long OwnerId;

@property (nonatomic,strong)NSNumber<Optional>*AvailableBalance;
@property (nonatomic,strong)NSNumber<Optional>*CanWithdrawBalance;
@property (nonatomic,copy)NSString<Optional>*FreezeFee;
@property (nonatomic,strong)NSDate<Optional>*CreatedTime;
@property (nonatomic,strong)NSDate<Optional>*ModifiedTime;

@end
/*
 Wallet {
 WalletId (long, optional): 钱包Id ,
 WalletType (integer, optional): 钱包类型，参见枚举[WalletType] ,
 OwnerId (integer): 钱包所有人(个人钱包：用户PassportId；
 机构钱包：所属机构的机构Id) ,
 AvailableBalance (number, optional): 可用余额 ,
 CanWithdrawBalance (number, optional): 可提现余额 ,
 FreezeFee (string, optional): 已冻结金额 ,
 CreatedTime (string, optional): 添加时间 ,
 ModifiedTime (string, optional): 修改时间
 }
 */
