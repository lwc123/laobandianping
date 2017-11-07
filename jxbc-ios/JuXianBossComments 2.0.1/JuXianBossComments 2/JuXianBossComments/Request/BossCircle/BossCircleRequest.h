//
//  BossCircleRequest.h
//  JuXianBossComments
//
//  Created by wy on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BossDynamicEntity.h"


@interface BossCircleRequest : NSObject

// 获取老板圈动态列表
+ (void)getBossCircleListWithCompanyId:(long)companyId
                    withSize:(int) size
                    withPage:(int) page
                    success:(void (^)(JSONModelArray *array))success
                    fail:(void (^)(NSError *error))fail;

// 获取某个老板动态
+ (void)getBossDynamicWithCompanyId:(long)companyId
                    withSize:(int) size
                    withPage:(int) page
                    success:(void (^)(JSONModelArray *array))success
                    fail:(void (^)(NSError *error))fail;

// 发布动态
+ (void)postPublicDynamicWith:(BossDynamicEntity *)dynamic
                      success:(void(^)(long result))success
                         fail:(void(^)(NSError* error))fail;
// 删除动态
+ (void)postDeleteDynamicWithDynamicID:(BossDynamicEntity *)dynamic
                      success:(void(^)(BOOL result))success
                         fail:(void(^)(NSError* error))fail;
// 评论动态
+ (void)postCommentDynamicWith:(BossDynamicCommentEntity *)comment
                       success:(void(^)(long result))success
                          fail:(void(^)(NSError* error))fail;

// 点赞
+ (void)postLikedDynamicWithCompanyId:(long )CompanyId
                        DynamicId:(long )dynamicId
                     success:(void(^)(BOOL result))success
                        fail:(void(^)(NSError* error))fail;
@end
