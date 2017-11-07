//
//  AccountSign.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/8/3.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "JSONModel.h"
#import "AnonymousAccount.h"
//#import "SignStatus.h"
@interface AccountSign : JSONModel

@property (nonatomic ,copy)NSString<Optional> *LoginName;
@property (nonatomic ,copy)NSString<Optional> *Password;
@property (nonatomic ,copy)NSString<Optional> *RealName;
@property (nonatomic, strong)NSString<Optional> * Nickname;
@property (nonatomic ,copy)NSString<Optional> *MobilePhone;
@property (nonatomic ,copy)NSString<Optional> *ValidationCode;
@property (nonatomic ,copy)NSString<Optional> *CurrentIndustry;
@property (nonatomic, copy)NSString<Optional> *CurrentJobCategory;

@end