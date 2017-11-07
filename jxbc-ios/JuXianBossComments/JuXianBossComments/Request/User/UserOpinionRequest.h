//
//  UserOpinionRequest.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicEntity.h"//轮播图
#import "OpinionEntity.h"//公司口碑列表
#import "OpinionCompanyEntity.h"//公司
#import "OpinionReplyEntity.h"//回复评论
#import "ConsoleEntity.h"//个人统计

@interface UserOpinionRequest : NSObject
//专题列表
+ (void)getCompanyReputationTopicSuccess:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;
//公司口碑列表
+(void)getCompanyReputationListPage:(int)page size:(int)size success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//点赞
+ (void)postOpinionPraiseWithOpinionId:(long)opinionId
                               success:(void(^)(BOOL result))success
                                  fail:(void(^)(NSError* error))fail;
//我关注的
+ (void)getConcernedMineListPage:(int)page size:(int)size success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;


//关注
+ (void)postConcernedAttentionCompanyId:(long)companyId
                                success:(void(^)(BOOL result))success
                                   fail:(void(^)(NSError* error))fail;

//公司详情
+ (void)getCompanyDetailWithCompanyId:(long)companyId
                                 page:(int)page
                                 size:(int)size
                              Success:(void (^)(OpinionCompanyEntity *companyEntity))success
                                 fail:(void (^)(NSError *error))fail;
//专题详情
+ (void)getTopicDetaillWithTopicId:(long)topicId
                                page:(int)page
                                size:(int)size
                             Success:(void (^)(TopicEntity *topicEntity))success
                                fail:(void (^)(NSError *error))fail;
//搜索
+ (void)getCompanySearchWithKeyword:(NSString *)keyword success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//评论
+ (void)postOpinionReplyCreateWith:(OpinionReplyEntity *)replyEntity
                           success:(void (^)(ResultEntity *resultEntity))success
                              fail:(void (^)(NSError *error))fail;

//我的点评列表
+ (void)getOpinionMineListPage:(int)page
                          size:(int)size
                       success:(void (^)(JSONModelArray *array))success
                          fail:(void (^)(NSError *error))fail;

//统计 红点
+ (void)getConsoleIndexSuccess:(void (^)(ConsoleEntity *consoleEntity))success
                          fail:(void (^)(NSError *error))fail;
@end
