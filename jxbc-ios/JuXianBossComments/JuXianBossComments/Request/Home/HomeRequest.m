//
//  HomeRequest.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "HomeRequest.h"

@implementation HomeRequest

//    //#define API_User_MyLastContract [NSString stringWithFormat:@"%@/User/MyLastContract",API_HOST_Test]


+ (void)homeMyLastContractWithSuccess:(void(^)(ServiceContractEntity *model))success fail:(void (^)(NSError *error))fail{

    [WebAPIClient getJSONWithUrl:API_User_MyLastContract parameters:nil success:^(id result) {
        
        ServiceContractEntity * consultantProfile = [[ServiceContractEntity alloc] initWithDictionary:result error:nil];
        success(consultantProfile);
        
//        success(result);
        
    } fail:^(NSError *error) {
        
        fail(error);
        
    }];

}

//老板点评
+ (void)bossCommentsRequestWith:(BossCommentsEntity *)paramer success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_BossComment parameters:[paramer toDictionary] success:^(id result) {
        
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);

    }];

}

//查询评价
//+(void)checkCommentsWithIdCard:(NSString *)idCard andName:(NSString *)name andCompany:(NSString *)company andPageIndex:(NSNumber*)pageIndex withPageSize:(NSNumber*)pageSize success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail{
//
//    [WebAPIClient getJSONWithUrl:API_BossCheck(idCard, name, company, pageIndex, pageSize) parameters:nil success:^(id result) {
//        
////        if ([result isKindOfClass:[NSNull class]]) {
////            
////            success(result);
////        }else{
//        
//            TargetEmploye * employe = [[TargetEmploye alloc] initWithDictionary:result error:nil];
//
////            TargetEmploye * my = [[TargetEmploye alloc] init];
////            JSONModelArray * modelArray = [[JSONModelArray alloc] initWithArray:result modelClass:[my.Comments class]];
//            success(employe);
////        }
//        
//    } fail:^(NSError *error) {
//        
//        fail(error);
//        
//    }];
//
//}


+(void)checkCommentsWithIdCard:(NSString *)idCard andName:(NSString *)name andCompany:(NSString *)company andPageIndex:(NSNumber*)pageIndex withPageSize:(NSNumber*)pageSize success:(void(^)(TargetEmploye *model))success fail:(void (^)(NSError *error))fail{

    [WebAPIClient getJSONWithUrl:API_BossCheck(idCard, name, company, pageIndex, pageSize) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {

            success(result);
        }else{
        
        TargetEmploye * employe = [[TargetEmploye alloc] initWithDictionary:result error:nil];
        success(employe);
        }
     
    } fail:^(NSError *error) {
        
        fail(error);
        
    }];

}

@end
