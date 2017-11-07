//
//  MineDataRequest.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/12.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "MineDataRequest.h"

@implementation MineDataRequest
+(void)ChangeAvatarWithAvatarStream:(NSString*)AvatarStream withFileName:(NSString*)fileName success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{

    NSDictionary *params = @{@"AvatarStream":AvatarStream,@"PassportId":@1};
    [WebAPIClient postJSONWithUrl:API_User_ChangeAvatar parameters: params   success:^(id result)
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

+ (void)UserChangeProfileWith:(JXUserProfile*)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
{
    [WebAPIClient postJSONWithUrl:API_user_ChangeProfile parameters:[parameter toDictionary] success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];
}



+ (void)UserSummaryWithSuccess:(void(^)(UserSummaryModel *model))success fail:(void (^)(NSError *error))fail;
{
    [WebAPIClient getJSONWithUrl:API_User_Summary parameters:nil success:^(id result) {
        
        UserSummaryModel *entity = [[UserSummaryModel alloc]initWithDictionary:result error:nil];
        
        if (success) {
            AnonymousAccount * account = [UserAuthentication GetCurrentAccount];
            account.UserProfile = entity.UserProfile;
            
            [UserAuthentication SaveCurrentAccount:account];
            
            success(entity);
        }
        
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}


+ (void)InformationWithSuccess:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Company_Information parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[CompanyMembeEntity class]];
            success(modelArray);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//企业认证
+ (void)companyAuditWith:(CompanyAuditEntity *)parameter success:(void(^)(ResultEntity *))success fail:(void(^)(NSError* error))fail{
    
    [WebAPIClient postJSONWithUrl:API_CompanyAudit parameters:[parameter toDictionary] success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            ResultEntity *resultEntity = [[ResultEntity alloc] initWithDictionary:result error:nil];
            success(resultEntity);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//判断公司是否存在
+ (void)getExistsCompanyWith:(NSString *)CompanyName success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_Company_Exists(CompanyName) parameters:nil success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}


//企业认证信息详情 获取已提交认证信息
+ (void)getCompanyMyAuditInfoWithCompanyId:(long)companyId success:(void (^)(CompanyAuditEntity *auditEntity))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Company_myAuditInfo(companyId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            CompanyAuditEntity *auditEntity = [[CompanyAuditEntity alloc] initWithDictionary:result error:nil];
            success(auditEntity);
        }
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"%@",error.localizedDescription);
    }];

}

//开户返回的优惠价格
+ (void)getPriceStrategyCurrentActivityWith:(long)activityType withVersion:(NSString *)version success:(void (^)(PriceStrategyEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Price_Strategy(activityType,version) parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            PriceStrategyEntity *priceStrategyEntity = [[PriceStrategyEntity alloc] initWithDictionary:result error:nil];
            success(priceStrategyEntity);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//金库支付

+ (void)postWalletPayWithCompanyId:(long)companyId tradeCode:(NSString *)tradeCode Success:(void (^)(PaymentResult *))success fail:(void (^)(NSError *))fail{
    [WebAPIClient postJSONWithUrl:API_Wallet_pay(companyId,tradeCode) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            PaymentResult *paymentResult = [[PaymentResult alloc] initWithDictionary:result error:nil];
            success(paymentResult);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//判断用苹果内购还是第三方支付 -- 线上
+ (void)getPaywaysForAppleWithBizSource:(NSString *)bizSouce success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_Getpayways(bizSouce) parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//判断是苹果支付还是第三方支付 -- 线下
+ (void)getPaywaysForAppleTextWithBizSource:(NSString *)bizSouce success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_Getpayways_Text(bizSouce) parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];

}


//获取指定业务的苹果内购产品信息 API_GetIAPProduct
+ (void)getPaymentIAPProductWithBizSource:(NSString *)bizSource success:(void (^)(JXIapProductCodeEntity *))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_GetIAPProduct(bizSource) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JXIapProductCodeEntity *productCodeEntity = [[JXIapProductCodeEntity alloc] initWithDictionary:result error:nil];
            success(productCodeEntity);
        }        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//创建公司
+ (void)postCreateNewCompanyWith:(OpenEnterpriseRequest *)openEnterprise Success:(void (^)(CompanyModel *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_CreateNewCompany parameters:[openEnterprise toDictionary] success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            CompanyModel *company= [[CompanyModel alloc] initWithDictionary:result error:nil];
            success(company);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}


@end
