//
//  AccountRepository.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "AccountRepository.h"
#import "ApiEnvironment.h"
#import "WebAPIClient.h"
#import "JXAPIs.h"
#import "AccountSignResult.h"
#import "AnonymousAccount.h"
#import "AnonymousAccountToken.h"
#import "SuccessAndFail.h"
#import "PublicUseMethod.h"
#import "OpenAccountRequest.h"//开会

#import "UserAuthentication.h"
//#import "md5.h"

#define  AppUrl @"http://itunes.apple.com/lookup?id=662004496"
@implementation AccountRepository

//1.第一次新号登陆
+(void)createNew:(void(^)(AccountSignResult* result))success fail:(void(^)(NSError* error))fail
{
    //获取设备id号
    //1注意原来的方法不能用(官方已禁止),只能IOS8.0以后的方法.
    //创建设备对象
    NSUUID *deviceUID = [[UIDevice currentDevice] identifierForVendor];
    // 输出设备:id0885EF57-54CF-4E68-A5C9-E8754A055C03
    //2.手机型号 4,4s,5,5s,6,6p
    NSString *product = [[UIDevice currentDevice] model];
    //设备名称   iphone||andord
    NSString *deviceName = [[UIDevice currentDevice] systemName];
    //3. 设备sdk的版本号
    NSString *sdkVersion = [[UIDevice currentDevice] systemVersion];
    //4.手机名字:固定iPhone
    NSString *Product = [[UIDevice currentDevice] localizedModel];
    //5.当前设备
    NSString *Brand = @"Apple";
    //字典传输参数
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 当前应用版本号码 int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:deviceUID.UUIDString forKey:@"DeviceKey"];
    [dic setValue:product forKey:@"Device"];
    [dic setValue:Brand forKey:@"Brand"];
    [dic setValue:sdkVersion forKey:@"SdkVersion"];
    [dic setValue:Product forKey:@"Product"];
    
    
    NSLog(@"%@",dic);
    
    [WebAPIClient postJSONWithUrl:API_Account_CreateNew parameters:dic
                          success:^(id result)
     {
         NSString *AccessToken = [[[result objectForKey:@"Account"] objectForKey:@"Token"] objectForKey:@"AccessToken"];
         //保存信息
         //1.key
         //2.app的Version
         //3.token
         NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
         NSString *str_deviceUID = [NSString stringWithFormat:@"%@",[[result objectForKey:@"Account"] objectForKey:@"DeviceId"]];
         [userDefault setObject:str_deviceUID forKey:@"DeviceKey"];
         [userDefault setObject:appCurVersionNum forKey:@"version"];
         [userDefault setObject:AccessToken forKey:@"AccessToken"];
         [userDefault synchronize];
         
         //result此时就是一个dic
         AccountSignResult *message = [[AccountSignResult alloc] initWithDictionary:result error:nil];
         if (success)
         {
             success(message);
         }
     }
                             fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
         
     }];
}
//2.根据用户名+密码登陆
+(void)signIn:(NSString *)name
     password:(NSString *)pwd
      success:(void(^)(AccountSignResult* result, NSString *platformAccountId, NSString *platformAccountPassword))success
         fail:(void(^)(NSError* error))fail
{
    AccountSign *signInfo = [[AccountSign alloc] init];
    signInfo.MobilePhone = name;
    signInfo.Password = pwd;
    //需要的话md5加密
    //    NSString *pwd_str = [md5 getMd5_32Bit_String:pwd];
    //    signInfo.Password = pwd_str;
    NSLog(@"%@",API_Account_SignIn);
    //第二次请求数据==>提交JSON数据
    [WebAPIClient postJSONWithUrl:API_Account_SignIn parameters:[signInfo toDictionary]
                          success:^(id result)
     {
         
         NSLog(@"result===%@",result);

         NSDictionary * dic = result[@"ErrorMessage"];         
         AccountSignResult *message = [[AccountSignResult alloc] initWithDictionary:result error:nil];
         
         NSString * imId;
         NSString * imPwd;
         if (message.SignStatus == 1)
         {
             [UserAuthentication SaveCurrentAccount:message.Account];
         }
         if (success)
         {
             success(message, imId, imPwd);
         }
         
     }
                             fail:^(NSError *error)
     {
         NSLog(@"==+++++++%@",error);
         if (fail)
         {
             fail(error);
         }
     }];
}

//2.1 快速登录  根据用户名+验证码登陆
+(void)quickSignIn:(NSString *)name
     code:(NSString *)pwd
      success:(void(^)(AccountSignResult* result, NSString *platformAccountId, NSString *platformAccountPassword))success
         fail:(void(^)(NSError* error))fail
{
    AccountSign *signInfo = [[AccountSign alloc] init];
    signInfo.MobilePhone = name;
    signInfo.ValidationCode = pwd;
    //需要的话md5加密
    //    NSString *pwd_str = [md5 getMd5_32Bit_String:pwd];
    //    signInfo.Password = pwd_str;

    //第二次请求数据==>提交JSON数据
    [WebAPIClient postJSONWithUrl:API_Account_ShortcutSignIn parameters:[signInfo toDictionary]
                          success:^(id result)
     {
         AccountSignResult *message = [[AccountSignResult alloc] initWithDictionary:result error:nil];
         
         NSString * imId;
         NSString * imPwd;
         if (message.SignStatus == 1) {
             
             imId  = result[@"Account"][@"IMAccount"][@"PlatformAccountId"];
             imPwd = result[@"Account"][@"IMAccount"][@"PlatformAccountPassword"];
             //把IMAccount存到本地
             [[NSUserDefaults standardUserDefaults] setObject:imId forKey:@"imId"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             
         }
         
         if (message.SignStatus == 1)
         {
             [UserAuthentication SaveCurrentAccount:message.Account];
         }
         if (success)
         {
             success(message, imId, imPwd);
         }
     }
                             fail:^(NSError *error)
     {
         NSLog(@"==+++++++%@",error);
         if (fail)
         {
             fail(error);
         }
     }];
}


//3.根据token判断是否直接登陆
+(void)signInByToken:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    //第二次请求数据==>提交JSON数据
    [WebAPIClient postJSONWithUrl:API_Account_SignInByToken parameters:nil success:^(id result)
     {
         AccountSignResult *message = [[AccountSignResult alloc] initWithDictionary:result error:nil];
         //登陆成功之后才保存
         if (message.SignStatus == 1)
         {
             [UserAuthentication SaveCurrentAccount:message.Account];
         }
         if (success)
         {
             NSLog(@"%@",[result class]);
             success(result);
         }
     }fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:SignIn_Fail object:error userInfo:nil];
     }];
}
//用手机号发送验证码
+(void)signUpSendGetCode:(NSString *)mobilePhone success:(void(^)(id result))success fail:(void(^)(NSError* error))fail ;
{
    NSString *sendCode = [NSString stringWithFormat:[JXApiEnvironment Account_SendValidationCode_Endpoint], mobilePhone];
    
    [WebAPIClient postJSONWithUrl:sendCode parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
        [PublicUseMethod showAlertView:@"验证码发送失败"];

    }];
    
}
//判断账号是否已经注册
+(void)isExistsMobilePhone:(NSString *)mobilePhone success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    NSString *path = [NSString stringWithFormat:@"%@%@",API_Account_ExistsMobilePhone,mobilePhone];
    
    [WebAPIClient getJSONWithUrl:path parameters:nil success:^(id result)
     {
         NSLog(@"%@",[result class]);
         if (success)
         {
             success(result);
         }
     } fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
     }];
}
//提交注册
+ (void)signUPWith:(AccountSign*)account success:(void(^)(AccountSignResult *result))success fail:(void(^)(NSError* error))fail;
{
    [WebAPIClient postJSONWithUrl:API_Account_SignUp parameters:[account toDictionary] success:^(id result)
     {
         AccountSignResult *signResult = [[AccountSignResult alloc] initWithDictionary:result error:nil];
         if (success)
         {
             [UserAuthentication SaveCurrentAccount:signResult.Account];
             success(signResult);
         }
         NSLog(@"注册result:\n%@",signResult);
         
     } fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
     }];
}

//开户申请
+ (void)OpenAccountWith:(OpenAccountRequest*)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    [WebAPIClient postJSONWithUrl:API_Account_Open parameters:[parameter toDictionary] success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        
        fail(error);
    }];
}

//+ (void)OpenAccountWith:(OpenAccountRequest*)parameter success:(void(^)(AccountSignResult *result))success fail:(void(^)(NSError* error))fail;
//{    
//    [WebAPIClient postJSONWithUrl:API_Account_Open parameters:[parameter toDictionary] success:^(id result) {
//        
//        AccountSignResult *signResult = [[AccountSignResult alloc] initWithDictionary:result error:nil];
//        if (success)
//        {
//            [UserAuthentication SaveCurrentAccount:signResult.Account];
//            success(signResult);
//        }
//        NSLog(@"注册result:\n%@",signResult);
//    } fail:^(NSError *error) {
//        
//        if (fail)
//        {
//            fail(error);
//        }
//    }];
//    
//    
//    
////    [WebAPIClient postJSONWithUrl:API_Account_SignUp parameters:[account toDictionary] success:^(id result)
////     {
////         AccountSignResult *signResult = [[AccountSignResult alloc] initWithDictionary:result error:nil];
////         if (success)
////         {
////             [UserAuthentication SaveCurrentAccount:signResult.Account];
////             success(signResult);
////         }
////         NSLog(@"注册result:\n%@",signResult);
////         
////     } fail:^(NSError *error)
////     {
////         if (fail)
////         {
////             fail(error);
////         }
////     }];
////    
//}


+(void)signUp:(NSString *)phone code:(NSString *)code pwd:(NSString *)pwd nickName:(NSString *)nickName success:(void(^)(AccountSignResult *result))success fail:(void(^)(NSError* error))fail
{
    AccountSign *sign = [[AccountSign alloc] init];
    sign.MobilePhone = phone;
    sign.Password = pwd;
    sign.ValidationCode =code;
    sign.RealName = nickName;
    
    [WebAPIClient postJSONWithUrl:API_Account_SignUp parameters:[sign toDictionary] success:^(id result)
     {
         AccountSignResult *signResult = [[AccountSignResult alloc] initWithDictionary:result error:nil];
         if (success)
         {
             [UserAuthentication SaveCurrentAccount:signResult.Account];
             success(signResult);
         }
         NSLog(@"注册result:\n%@",signResult);
         
     } fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
     }];
}
#pragma mark-----第三方登陆
+(void)bindThirdPasspord :(NSString *)thirdPassportId platform:(NSString *)platform success:(void(^)(AnonymousAccount *result))success fail:(void(^)(NSError* error))fail
{
    ThirdPassport *account = [[ThirdPassport alloc] init];
    account.ThirdPassportId = thirdPassportId;
    account.Platform = platform;
    [WebAPIClient postJSONWithUrl:API_Account_BindThirdPassport parameters:[account toDictionary] success:^(id result)
     {
         AnonymousAccount *bindResult = [[AnonymousAccount alloc] initWithDictionary:result error:nil];
         if (success)
         {
             success(bindResult);
         }
     } fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
     }];
}
+(void)signOut: (void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    [WebAPIClient postJSONWithUrl:API_Account_SignOut parameters:nil success:^(id result)
     {
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AccessToken"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         [AccountRepository createNew:^(id result)
          {
              NSLog(@"%@",[result class]);
              
          } fail:^(NSError *error)
          {
              if (fail)
              {
                  fail(error);
              }
          }];
         
         if (success)
         {
             success(result);
         }
     } fail:^(NSError *error)
     {
         if (fail)
         {
             fail(error);
         }
     }];
}

#pragma mark---------单独封装请求方法因为无根API
//检测软件是否需要升级
+(void)checkVersion:(NSString *)absolute_Path success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    AFHTTPSessionManager *manager = [WebAPIClient CreateOperationManager];
    
    [manager GET:absolute_Path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success)
        {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    
    //    [manager GET:absolute_Path parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    //        if (success)
    //        {
    //            success(responseObject);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (fail) {
    //            fail(error);
    //        }
    //    }];
    
}
+(void)ClearUser:(NSString *)phone success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    NSString *path = [NSString stringWithFormat:@"%@%@",API_Account_ClearUser,phone];
    [WebAPIClient postJSONWithUrl:path parameters:nil success:^(id result)
     {
         if (success)
         {
             success(result);
         }
     } fail:^(NSError *error) {
         if (fail)
         {
             fail(error);
         }
     }];
}
//清理数据的测试方法

/*
 -(void)ClearUser
 {
 [AccountRepository ClearUser:@"13021951569" success:^(id result)
 {
 [self ClearUserSuccess:result];
 } fail:^(NSError *error) {
 [self ClearUserFail:error];
 }];
 }
 -(void)ClearUserSuccess:(id)result
 {
 NSLog(@"失败原因%@",result);
 }
 -(void)ClearUserFail:(NSError *)error
 {
 NSLog(@"失败原因%@",error);
 }
 */
+ (void)ChangePassWordWith:(AccountSign*)sign success:(void (^)(AccountSignResult* result))success fail:(void (^)(NSError* error))fail;
{
    [WebAPIClient postJSONWithUrl:[JXApiEnvironment Account_ResetPassword_Endpoint] parameters:[sign toDictionary] success:^(id result) {
        
        NSLog(@"%@",result);
        if (![result isKindOfClass:[NSNull class]]) {
            AccountSignResult *signResult = [[AccountSignResult alloc]initWithDictionary:result error:nil];
            success(signResult);
        }
        else
        {
            success(result);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

+ (void)ResetPassWordWith:(AccountSign*)sign success:(void (^)(AccountSignResult* result))success fail:(void (^)(NSError* error))fail;
{
    [WebAPIClient postJSONWithUrl:API_Account_ResetPassWord parameters:[sign toDictionary] success:^(id result) {
        NSLog(@"%@",result);
        if (![result isKindOfClass:[NSNull class]]) {
            AccountSignResult *signResult = [[AccountSignResult alloc]initWithDictionary:result error:nil];
            success(signResult);
        }
        else
        {
            success(result);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

@end
