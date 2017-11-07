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
#import "AdditionalAction.h"
#import "AccountEntity.h"
@interface AccountSignResult : JSONModel

@property (nonatomic ,assign)SignStatus SignStatus;
/**是否创建了新账号 */
@property (nonatomic ,strong)NSString<Optional> *CreatedNewPassport;
@property (nonatomic ,strong)NSString<Optional> *ErrorMessage;
@property (nonatomic ,strong)AnonymousAccount<Optional> *Account;
/**注册或登录的后继行为*/
@property (nonatomic ,strong)AdditionalAction<Optional> *AdditionalAction;


@end
