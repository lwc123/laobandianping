//
//  UserAuthentication.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/8/5.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnonymousAccountToken.h"
#import "AnonymousAccount.h"
#import "AccountEntity.h"
#import "CompanyMembeEntity.h"
#import "PrivatenessServiceContract.h"//合同
#import "CompanySummary.h"

@class JXAccountProfile,UMSocialAccountEntity;
@interface UserAuthentication : NSObject

+(void)SaveCompanySummary:(CompanySummary *)companySummary;
+ (CompanySummary *)GetCompanySummary;

//第三方登陆，保存UMSocialAccountEntity  登陆后的信息
+(void)saveAccountEntity:(UMSocialAccountEntity *)accountEntity;
+(UMSocialAccountEntity *)getAccountEntity;
+(void)removeAccountEntity;
+(void)removeCurrentAccount;



//非第三方登陆
+ (AnonymousAccount*)GetCurrentAccount;
+ (void)SaveCurrentAccount:(AnonymousAccount*) account;
+ (BOOL)IsAuthenticated;
+ (long)GetPassportId;
+ (void)saveProfileWithAccount:(JXAccountProfile *)account;
+ (JXAccountProfile *)getTheProfile;
+ (void)removeProfile;

//保存猎人人才相互切换返回的结果
+ (AccountEntity*)GetCurrentAccountEntity;

+ (void)SaveAccountEntity:(AccountEntity *)accountEntity;

//登录注册的时候 创建一个JXUserProfile model对象  传入  ---你需要的数据  调用
//每次当用户改变自身信息的时候 条用一次该方法 (也需要创建对象之后在调用)
//+(void)SaVeUserInfoWith:(JXUserProfile*)userProfile;

//存老板信息
+(void)SaveBossInformation:(CompanyMembeEntity *)bossInformatio;
//取老板信息
+ (CompanyMembeEntity *)GetBossInformation;

//取当前用户的信息
+ (CompanyMembeEntity *)GetMyInformation;
//存当前用户的信息
+(void)SaveMyInformation:(CompanyMembeEntity *)myAccount;

//存合同信息
+ (void)saveUserContract:(PrivatenessServiceContract *)contract;
//取合同信息
+ (PrivatenessServiceContract *)getUserContract;


//存支付实体
+(void)SavePayEntity:(PaymentResult *)paymentResult;

//取支付实体
+ (PaymentResult *)GetPaymentResult;


@end
