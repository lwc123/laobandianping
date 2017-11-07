//
//  UserOpinionRequest.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserOpinionRequest.h"

@implementation UserOpinionRequest

//专题列表
+ (void)getCompanyReputationTopicSuccess:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_Company_Topic parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[TopicEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司口碑列表
+ (void)getCompanyReputationListPage:(int)page size:(int)size success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_Company_ReputationList(page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[OpinionEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//点赞
+ (void)postOpinionPraiseWithOpinionId:(long)opinionId success:(void (^)(BOOL))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Opinion_Praise(opinionId) parameters:nil success:^(id result) {
        
        success((long)result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//我关注的公司
+ (void)getConcernedMineListPage:(int)page size:(int)size success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Concerned_MineList(page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[OpinionCompanyEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//关注
+ (void)postConcernedAttentionCompanyId:(long)companyId success:(void (^)(BOOL))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Opinion_Attention(companyId) parameters:nil success:^(id result) {
        
        success((long)result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//公司详情
+ (void)getCompanyDetailWithCompanyId:(long)companyId page:(int)page size:(int)size Success:(void (^)(OpinionCompanyEntity *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_Company_Detail(companyId, page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            OpinionCompanyEntity *companyEntity = [[OpinionCompanyEntity alloc] initWithDictionary:result error:nil];
            success(companyEntity);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//专题详情
+ (void)getTopicDetaillWithTopicId:(long)topicId page:(int)page size:(int)size Success:(void (^)(TopicEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Topic_Detail(topicId, page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            TopicEntity *topicEntity = [[TopicEntity alloc] initWithDictionary:result error:nil];
            success(topicEntity);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//搜索
+ (void)getCompanySearchWithKeyword:(NSString *)keyword success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Company_Search(keyword) parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[OpinionCompanyEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//评论
+ (void)postOpinionReplyCreateWith:(OpinionReplyEntity *)replyEntity success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Reply_Create parameters:[replyEntity toDictionary] success:^(id result) {
        
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

//我的点评列表
+ (void)getOpinionMineListPage:(int)page size:(int)size success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_CommentList_Mine(page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[OpinionEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}
//个人统计 红点
+ (void)getConsoleIndexSuccess:(void (^)(ConsoleEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Console_Index parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            ConsoleEntity *consoleEntity = [[ConsoleEntity alloc] initWithDictionary:result error:nil];
            success(consoleEntity);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];


}

@end
