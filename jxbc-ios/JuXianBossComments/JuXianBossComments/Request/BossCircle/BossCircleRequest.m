//
//  BossCircleRequest.m
//  JuXianBossComments
//
//  Created by wy on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircleRequest.h"

@implementation BossCircleRequest

// 老板圈列表
+ (void)getBossCircleListWithCompanyId:(long)companyId withSize:(int)size withPage:(int)page success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_getBossCircle_list(companyId,size,page) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[BossDynamicEntity class]];

            success(modelArray);

        }
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];
    
}

// 个人圈列表
+ (void)getBossDynamicWithCompanyId:(long)companyId withSize:(int)size withPage:(int)page success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    
    [WebAPIClient getJSONWithUrl:API_getMyDynamic_list(companyId,size,page) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[BossDynamicEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];
    
}

// 发布
+ (void)postPublicDynamicWith:(BossDynamicEntity *)dynamic success:(void (^)(long))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_postPublicDynamic_add parameters:[dynamic toDictionary] success:^(id result) {
        
        success((long)result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}

// 删除
+ (void)postDeleteDynamicWithDynamicID:(BossDynamicEntity *)dynamic success:(void (^)(BOOL))success fail:(void (^)(NSError *))fail{

    
    [WebAPIClient postJSONWithUrl:API_postDeleteDynamic_del(dynamic.CompanyId, dynamic.PassportId, dynamic.DynamicId) parameters:nil success:^(id result) {
        
        success((BOOL)result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}

// 评论
+ (void)postCommentDynamicWith:(BossDynamicCommentEntity *)comment success:(void (^)(long))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_postCommentDynamic_comment parameters:[comment toDictionary]  success:^(id result) {
        success((long)result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}

// 点赞
+ (void)postLikedDynamicWithCompanyId:(long)CompanyId DynamicId:(long)dynamicId success:(void (^)(BOOL))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_postLikedDynamic_comment(CompanyId,dynamicId) parameters:nil success:^(id result) {
        
        success((long)result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}



@end
