//
//  UserMessage.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "JSONModel.h"
#import "AnonymousAccount.h"
#import "SignStatus.h"
@interface AccountSignResult : JSONModel

@property (nonatomic ,assign)SignStatus SignStatus;
@property (nonatomic ,strong)NSString<Optional> *CreatedNewPassport;
@property (nonatomic ,strong)NSString<Optional> *ErrorMessage;
@property (nonatomic ,strong)AnonymousAccount<Optional> *Account;

@end
