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
#import "JXUserProfile.h"
@interface AccountSign : JSONModel


@property (nonatomic ,copy)NSString<Optional> *LoginName;
@property (nonatomic ,copy)NSString<Optional> *RealName;
@property (nonatomic, strong)NSString<Optional> * Nickname;
@property (nonatomic ,copy)NSString<Optional> *CurrentIndustry;
@property (nonatomic, copy)NSString<Optional> *CurrentJobCategory;
@property (nonatomic, copy)NSString<Optional> *CurrentCompany;
//企业名称
@property (nonatomic, copy)NSString<Optional> *EntName;
//法人代表
@property (nonatomic, copy)NSString<Optional> *LegalRepresentative;

@property (nonatomic ,copy)NSString<Optional> *MobilePhone;
@property (nonatomic ,copy)NSString<Optional> *Password;
/**短信验证码*/
@property (nonatomic ,copy)NSString<Optional> *ValidationCode;
/**注册选择的身份*/
@property (nonatomic ,assign)NSInteger SelectedProfileType;
/**注册邀请码*/
@property (nonatomic ,copy)NSString<Optional> *InviteCode;

@end
