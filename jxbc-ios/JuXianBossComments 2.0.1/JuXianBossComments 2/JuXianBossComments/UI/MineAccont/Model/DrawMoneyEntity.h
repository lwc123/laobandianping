//
//  DrawMoneyEntity.h
//  JuXianBossComments
//
//  Created by wy on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawMoneyEntity : JSONModel

@property (nonatomic,assign)long ApplyId;

@property (nonatomic,assign)long CompanyId;

@property (nonatomic,copy)NSString <Optional>*CompanyName;

@property (nonatomic,assign)long PresenterId;

@property (nonatomic,copy)NSString <Optional>*BankCard;

@property (nonatomic,copy)NSString <Optional>*BankName;

@property (nonatomic,strong)NSNumber<Optional>*MoneyNumber;

@property (nonatomic,assign)long AuditStatus;

@property (nonatomic,copy)NSString <Optional>*CreatedTime;

@property (nonatomic,copy)NSString <Optional>*ModifiedTime;


/*
    ApplyId (integer, optional): ,
    CompanyId (integer): 公司ID ,
    CompanyName (string, optional): 公司名称 ,
    PresenterId (integer, optional): 提交人ID ,
    BankCard (string): 银行账号 ,
    BankName (string): 开户银行 ,
    MoneyNumber (number): 提现金额 ,
    AuditStatus (integer, optional): 提现状态，0未申请，1申请中，2已完成，9被拒绝 ,
    CreatedTime (string, optional): ,
    ModifiedTime (string, optional):
*/
@end
