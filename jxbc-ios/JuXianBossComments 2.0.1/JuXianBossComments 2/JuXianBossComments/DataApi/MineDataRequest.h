//
//  MineDataRequest.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/12.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnonymousAccount.h"
#import "UserAuthentication.h"
#import "AccountEntity.h"
#import "UserSummaryModel.h"
//登录之后调
#import "CompanyMembeEntity.h"
#import "CompanyAuditEntity.h"

//优惠价格
#import "PriceStrategyEntity.h"
#import "JXIapProductCodeEntity.h"//苹果内购商品的信息
#import "OpenEnterpriseRequest.h"

@interface MineDataRequest : NSObject
//个人信息 用户头像上传
+(void)ChangeAvatarWithAvatarStream:(NSString*)AvatarStream withFileName:(NSString*)fileName success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
////个人的收藏
//+ (void)UserSummaryWithSuccess:(void(^)(UserSummaryModel *model))success fail:(void (^)(NSError *error))fail;
//修改个人信息
+ (void)UserChangeProfileWith:(JXUserProfile*)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//个人信息
+ (void)UserSummaryWithSuccess:(void(^)(UserSummaryModel *model))success fail:(void (^)(NSError *error))fail;
//获取公司信息
+ (void)InformationWithSuccess:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;
//企业提交认证
+ (void)companyAuditWith:(CompanyAuditEntity *)parameter success:(void (^)(ResultEntity *resultEntity))success fail:(void (^)(NSError *error))fail;
//判断公司是否存在
+ (void)getExistsCompanyWith:(NSString *)CompanyName success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//企业认证信息详情 获取已提交认证信息
+ (void)getCompanyMyAuditInfoWithCompanyId:(long)companyId success:(void (^)(CompanyAuditEntity *auditEntity))success fail:(void (^)(NSError *error))fail;

//开户返回的优惠价格
+ (void)getPriceStrategyCurrentActivityWith:(long)activityType withVersion:(NSString *)version success:(void (^)(PriceStrategyEntity *priceStrategyEntity))success fail:(void (^)(NSError *error))fail;

//金库支付
+ (void)postWalletPayWithCompanyId:(long)companyId tradeCode:(NSString *)tradeCode Success:(void (^)(PaymentResult *paymentResult))success fail:(void (^)(NSError *error))fail;

//判断用苹果内购还是第三方支付 -- 线上
+ (void)getPaywaysForAppleWithBizSource:(NSString *)bizSouce success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//判断是苹果支付还是第三方支付 -- 线下
+ (void)getPaywaysForAppleTextWithBizSource:(NSString *)bizSouce success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//获取指定业务的苹果内购产品信息
+ (void)getPaymentIAPProductWithBizSource:(NSString *)bizSource success:(void (^)(JXIapProductCodeEntity *productCodeEntity))success fail:(void (^)(NSError *error))fail;

//创建公司
+ (void)postCreateNewCompanyWith:(OpenEnterpriseRequest *)openEnterprise Success:(void(^)(CompanyModel * company))success fail:(void(^)(NSError* error))fail;

@end
