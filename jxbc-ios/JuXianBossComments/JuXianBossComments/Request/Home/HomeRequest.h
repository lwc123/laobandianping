//
//  HomeRequest.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceContractEntity.h"
//老板点评的model
#import "BossCommentsEntity.h"
//#import "JSONModelArray.h"

@interface HomeRequest : NSObject

//点击查询判断是否可以查询
+ (void)homeMyLastContractWithSuccess:(void(^)(ServiceContractEntity *model))success fail:(void (^)(NSError *error))fail;

//老板点评
+ (void)bossCommentsRequestWith:(BossCommentsEntity *)paramer success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//查询BossCommentsEntity
//+(void)checkCommentsWithIdCard:(NSString *)idCard andName:(NSString *)name andCompany:(NSString *)company andPageIndex:(NSNumber*)pageIndex withPageSize:(NSNumber*)pageSize success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;



+(void)checkCommentsWithIdCard:(NSString *)idCard andName:(NSString *)name andCompany:(NSString *)company andPageIndex:(NSNumber*)pageIndex withPageSize:(NSNumber*)pageSize success:(void(^)(TargetEmploye *model))success fail:(void (^)(NSError *error))fail;


//BossComment/Search?idCard={idCard}&name={name}&company={company}&page={page}&size={size}


@end
