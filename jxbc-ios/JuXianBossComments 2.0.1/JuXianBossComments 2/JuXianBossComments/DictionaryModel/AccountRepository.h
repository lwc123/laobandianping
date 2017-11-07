//
//  AccountRepository.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//
// 有关账户的一些请求接口的 方法的分装 
#import <Foundation/Foundation.h>
#import "AccountSignResult.h"
#import "AccountSign.h"
#import "OpenAccountRequest.h"
@interface AccountRepository : NSObject

///获取用户设备的信息
+(void)createNew :(void(^)(AccountSignResult* result))success fail:(void(^)(NSError* error))fail;
///2.根据用户名+密码登陆
//+(void)signIn:(NSString *)name password:(NSString *)pwd success:(void(^)(AccountSignResult* result))success fail:(void(^)(NSError* error))fail;
///根据token判断是否直接进入登陆界面
+(void)signInByToken:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
///手机号发送验证码
+(void)signUpSendGetCode:(NSString *)mobilePhone success:(void(^)(id result))success fail:(void(^)(NSError* error))fail ;
///判断已存在手机号
+(void)isExistsMobilePhone:(NSString *)mobilePhone success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
///手机号注册
+(void)signUp:(NSString *)phone code:(NSString *)code pwd:(NSString *)pwd nickName:(NSString *)nickName success:(void(^)(AccountSignResult *result))success fail:(void(^)(NSError* error))fail;
+ (void)signUPWith:(AccountSign*)account success:(void(^)(AccountSignResult *result))success fail:(void(^)(NSError* error))fail;

//开户
+ (void)OpenAccountWith:(OpenAccountRequest*)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

#pragma mark-----第三方登陆
///第三方登陆
+(void)bindThirdPasspord :(NSString *)thirdPassportId platform:(NSString *)platform success:(void(^)(AnonymousAccount *result))success fail:(void(^)(NSError* error))fail;
+(void)signOut:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
///版本更新
+(void)checkVersion:(NSString *)absolute_Path success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
///清除account数据
+(void)ClearUser:(NSString *)phone success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

///2.根据用户名+密码登陆

+(void)signIn:(NSString *)name
     password:(NSString *)pwd
      success:(void(^)(AccountSignResult* result, NSString *platformAccountId, NSString *platformAccountPassword))success
         fail:(void(^)(NSError* error))fail;
//2.1 根据用户名+验证码登陆  快速登录
+(void)quickSignIn:(NSString *)name
              code:(NSString *)pwd
           success:(void(^)(AccountSignResult* result, NSString *platformAccountId, NSString *platformAccountPassword))success
              fail:(void(^)(NSError* error))fail;


//修改密码
+ (void)ChangePassWordWith:(AccountSign*)sign success:(void (^)(AccountSignResult* result))success fail:(void (^)(NSError* error))fail;

//设置密码
+ (void)ResetPassWordWith:(AccountSign*)sign success:(void (^)(AccountSignResult* result))success fail:(void (^)(NSError* error))fail;

// 切换到个人端
+ (void)changeCurrentToUserProfileSuccess:(void (^)(AccountEntity* result))success fail:(void (^)(NSError* error))fail;
// 切换到企业端
+ (void)changeCurrentToOrganizationProfileWithprofile:(JXOrganizationProfile *)organizationProfile success:(void (^)(AccountEntity* result))success fail:(void (^)(NSError* error))fail;

@end
