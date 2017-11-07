//
//  WorkBenchJobRequest.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "WorkBenchJobRequest.h"
#import "JobEntity.h"

@implementation WorkBenchJobRequest
#pragma mark - 企业发布职位api
//----企业----
// 公司所发布的职位
//API_getJob_jobList(CompanyId,Size,Page)
+ (void)getJob_jobListWithCompanyId:(long)companyId withSize:(int) size withPage:(int) page success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail{
    
    [WebAPIClient getJSONWithUrl:API_getJob_jobList(companyId, size, page) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[JobEntity class]];//但是这种转的方式依然没有用，失败，initWithDictionary这种的有效，转成功了。
            
            NSMutableArray *modelArrayM = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                JobEntity *jobEntity = [[JobEntity alloc]initWithDictionary:dict error:nil];
                [modelArrayM addObject:jobEntity];
            }
            NSLog(@"modelArrayM===%@",modelArrayM);
            modelArray = modelArrayM.copy;//然后就将转成功的模型数组给modelArray了，但JSONModelArray是对象，不是array，虽然这样操作没有问题，但不知道会不会出问题，可以先这样写，或者以后遇到这种情况，返回就不要返回JSONModelArray类型，可以直接返回nsarray
            
            success(modelArray);
            
        }
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];
    
}

// 企业发布职位
// API_postJob_add
+ (void)postJob_publicJobWith:(JobEntity *)jobEntity
                      success:(void(^)(id result))success
                         fail:(void(^)(NSError* error))fail{
    
    [WebAPIClient postJSONWithUrl:API_postJob_add parameters:[jobEntity toDictionary] success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}

// 编辑职位
// API_postJob_update
+ (void)postJob_updateJobWith:(JobEntity *)jobEntity
                      success:(void(^)(id result))success
                         fail:(void(^)(NSError* error))fail{
    [WebAPIClient postJSONWithUrl:API_postJob_update parameters:[jobEntity toDictionary] success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}

// 职位详情
+ (void)getJob_jodDetailWith:(long)companyId and:(long)jobId success:(void (^)(JobEntity*))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_getJob_detail(companyId, jobId) parameters:nil success:^(id result) {
        JobEntity* job = [[JobEntity alloc]initWithDictionary:result error:nil];
        success(job);

    } fail:^(NSError *error) {
        fail(error);

    }];
}

// 关闭职位
// API_postJob_closeJob
+ (void)postJob_closeJobWith:(long)companyId
                         and:(long)jobId
                     success:(void(^)(id result))success
                        fail:(void(^)(NSError* error))fail{
    
    [WebAPIClient getJSONWithUrl:API_postJob_closeJob(companyId, jobId) parameters:nil success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
        
    }];

}

// 开启职位
// API_postJob_openJob
+ (void)postJob_openJobWith:(long)companyId
                        and:(long) jobId
                    success:(void(^)(id result))success
                       fail:(void(^)(NSError* error))fail{
    
    [WebAPIClient getJSONWithUrl:API_postJob_openJob(companyId, jobId) parameters:nil success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
        
    }];

}

// 删除职位
// API_getJob_deleteJob(CompanyId,JobId)
+ (void)getJob_deleteJobWith:(long)companyId
                         and:(long)jobId
                     success:(void(^)(id result))success
                        fail:(void(^)(NSError* error))fail{
    
    [WebAPIClient getJSONWithUrl:API_getJob_deleteJob(companyId,jobId) parameters:nil success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
        
    }];

}

#pragma mark - 个人搜索职位api
//----个人----
// 搜索职位列表

//API_getJobQuery_search(JobName,JobCity,Industry,SalaryRange,Page,Size)y,Industry,SalaryRange,Page,Size]
+ (void)getJobQuery_searchJobWithJobName:(NSString*)JobName
                                 JobCity:(NSString*)JobCity
                                Industry:(NSString*)Industry
                             SalaryRange:(NSString*)SalaryRange
                                    page:(int)page
                                    size:(int)size
                                 success:(void(^)(JSONModelArray *array))success
                                    fail:(void(^)(NSError* error))fail{
    [WebAPIClient getJSONWithUrl:API_getJobQuery_search(JobName, JobCity, Industry, SalaryRange, page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[JobEntity class]];//但是这种转的方式依然没有用，失败，initWithDictionary这种的有效，转成功了。
            
            NSMutableArray *modelArrayM = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                JobEntity *jobEntity = [[JobEntity alloc]initWithDictionary:dict error:nil];
                [modelArrayM addObject:jobEntity];
            }
            NSLog(@"modelArrayM===%@",modelArrayM);
            modelArray = modelArrayM.copy;//然后就将转成功的模型数组给modelArray了，但JSONModelArray是对象，不是array，虽然这样操作没有问题，但不知道会不会出问题，可以先这样写，或者以后遇到这种情况，返回就不要返回JSONModelArray类型，可以直接返回nsarray
            
            success(modelArray);
            
        }
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];
}


// 职位详情
// API_getJobQuery_Detail(JobId)
+ (void)getJobQuery_jobDetailWithJobId:(long)jobId
                               success:(void(^)(JobEntity* result))success
                                  fail:(void(^)(NSError* error))fail{
    [WebAPIClient getJSONWithUrl:API_getJobQuery_Detail(jobId) parameters:nil success:^(id result) {
        JobEntity* job = [[JobEntity alloc]initWithDictionary:result error:nil];
        success(job);
        
    } fail:^(NSError *error) {
        fail(error);
        
    }];

}

@end
