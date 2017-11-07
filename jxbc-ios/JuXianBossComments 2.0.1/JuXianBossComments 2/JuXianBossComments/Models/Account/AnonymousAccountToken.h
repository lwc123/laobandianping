//
//  Token.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//
#import <JSONModel/JSONModel.h>

@interface AnonymousAccountToken : JSONModel

@property (nonatomic ,assign)int TokenId;
@property (nonatomic ,assign)long PassportId;
@property (nonatomic ,copy)NSString *AccessToken;
@property (nonatomic ,strong)NSString *ExpiresTime;
@property (nonatomic ,assign)BOOL IsExpired;
@property (nonatomic, strong)NSNumber<Optional>* AccountId;
@end
