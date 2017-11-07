//
//  UserAuthentication.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/8/5.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "UserAuthentication.h"

@implementation UserAuthentication
//取Account
+ (AnonymousAccount*)GetCurrentAccount
{
//    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/myAccount.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
//    AnonymousAccount *Account = [[AnonymousAccount alloc] initWithDictionary:dic error:nil];
//    return Account;
}

+(void)SaveCurrentAccount:(AnonymousAccount *)account
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/myAccount.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:accountPath];
}

+(void)SaveCompanySummary:(CompanySummary *)companySummary
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/companySummary.data"];
    [NSKeyedArchiver archiveRootObject:companySummary toFile:accountPath];
}

+ (CompanySummary *)GetCompanySummary{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/companySummary.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
}

//存老板信息
+(void)SaveBossInformation:(CompanyMembeEntity *)account
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/bossInformation.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:accountPath];
}

//取老板信息
+ (CompanyMembeEntity *)GetBossInformation{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/bossInformation.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
}

//存当前用户的信息
+(void)SaveMyInformation:(CompanyMembeEntity *)myAccount
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/MyInformation.data"];
    [NSKeyedArchiver archiveRootObject:myAccount toFile:accountPath];
}

//取当前用户的信息
+ (CompanyMembeEntity *)GetMyInformation{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/MyInformation.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
}


//存支付实体
+(void)SavePayEntity:(PaymentResult *)paymentResult
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/paymentResult.data"];
    [NSKeyedArchiver archiveRootObject:paymentResult toFile:accountPath];
}

//取支付实体
+ (PaymentResult *)GetPaymentResult{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/paymentResult.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
}


//存合同信息
+ (void)saveUserContract:(PrivatenessServiceContract *)contract{

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/Contract.data"];
    [NSKeyedArchiver archiveRootObject:contract toFile:accountPath];
}
//取合同信息
+ (PrivatenessServiceContract *)getUserContract{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *accountPath = [path stringByAppendingString:@"/Contract.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
}



//判断
+ (BOOL)IsAuthenticated
{
    long passportId = [self GetPassportId];
    return passportId > 0;
}
//取PassportId
+ (long)GetPassportId
{
    long passportId = 0;
    AnonymousAccount* account = [self GetCurrentAccount];
    if(!(account == nil))
    {
        passportId = account.PassportId;
    }
    return passportId;
}

//存储profile
+ (void)saveProfileWithAccount:(JXAccountProfile *)account
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/profile.data"];
    [NSKeyedArchiver archiveRootObject:account toFile:rootPath];
}
+ (JXAccountProfile *)getTheProfile
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/profile.data"];
   return  [NSKeyedUnarchiver unarchiveObjectWithFile:rootPath];
}
+ (void)removeProfile
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/profile.data"];
    NSFileManager *manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:rootPath])
    {
        [manger removeItemAtPath:rootPath error:nil];
    }
}


//第三方登陆，保存UMSocialAccountEntity  登陆后的信息
+(void)saveAccountEntity:(UMSocialAccountEntity *)accountEntity
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/accountEntity.data"];
    [NSKeyedArchiver archiveRootObject:accountEntity toFile:rootPath];
}
+(UMSocialAccountEntity *)getAccountEntity
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/accountEntity.data"];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:rootPath];

}
+(void)removeAccountEntity
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/accountEntity.data"];
    NSFileManager *manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:rootPath])
    {
        [manger removeItemAtPath:rootPath error:nil];
    }
}
+(void)removeCurrentAccount
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *rootPath = [path stringByAppendingString:@"/myAccount.data"];
    NSFileManager *manger = [NSFileManager defaultManager];
    if ([manger fileExistsAtPath:rootPath])
    {
        [manger removeItemAtPath:rootPath error:nil];
    }
}
//切换猎人
+ (AccountEntity*)GetCurrentAccountEntity;
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ChangeAccountEntity.data"];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}
+ (void)SaveAccountEntity:(AccountEntity *)accountEntity;
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ChangeAccountEntity.data"];
    [NSKeyedArchiver archiveRootObject:accountEntity toFile:filePath];
}




@end
