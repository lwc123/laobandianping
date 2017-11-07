//
//  JXIapProductCodeEntity.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JXIapProductCodeEntity : JSONModel
@property (nonatomic, copy) NSString<Optional> *Name;
@property (nonatomic, copy) NSString<Optional> *ProductCode;
@property (nonatomic, strong) NSNumber<Optional> *GoldCoins;
@property (nonatomic, assign) double Price;
@end
/*
 Name (long): 业务名称 ,
 ProductCode (integer): 苹果内购[产品ID] ,
 Price (number, optional): 支付价格 ,
 GoldCoins (number, optional): 金币数量
 */
