//
//  CompanyBankCard.h
//  JuXianBossComments
//
//  Created by wy on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompanyBankCard : JSONModel

@property (nonatomic,assign)long AccountId;

@property (nonatomic,assign)long CompanyId;

@property (nonatomic,assign)long PresenterId;

@property (nonatomic,copy)NSString <Optional>*CompanyName;
@property (nonatomic,copy)NSString <Optional>*BankCard;
@property (nonatomic,copy)NSString <Optional>*BankName;
@property (nonatomic,copy)NSString <Optional>*UseTime;
@property (nonatomic,strong)NSDate <Optional>*CreatedTime;
@property (nonatomic,strong)NSDate <Optional>*ModifiedTime;



//AccountId (integer, optional): ,
//CompanyId (integer): 公司Id ,
//CompanyName (string, optional): 公司名称 ,
//PresenterId (integer): 提交人ID ,
//BankCard (string): 银行账号 ,
//BankName (string): 开户银行 ,
//UseTime (string, optional): 使用时间 ,
//CreatedTime (string, optional): ,
//ModifiedTime (string, optional):
@end
