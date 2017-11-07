//
//  WorkBenchJobRequest.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JobEntity;

@interface WorkBenchJobRequest : NSObject

#pragma mark - 企业发布职位api
//----企业----
// 公司所发布的职位
//API_getJob_jobList(CompanyId,Size,Page)
+ (void)getJob_jobListWithCompanyId:(long)companyId
                           withSize:(int) size
                           withPage:(int) page
                            success:(void (^)(JSONModelArray *array))success
                               fail:(void (^)(NSError *error))fail;

// 企业发布职位
// API_postJob_add
+ (void)postJob_publicJobWith:(JobEntity *)jobEntity
                      success:(void(^)(id result))success
                         fail:(void(^)(NSError* error))fail;

// 编辑职位
// API_postJob_update
+ (void)postJob_updateJobWith:(JobEntity *)jobEntity
                      success:(void(^)(id result))success
                         fail:(void(^)(NSError* error))fail;
// 职位详情
// API_getJob_detail(CompanyId,JobId)
+ (void)getJob_jodDetailWith:(long)companyId
                         and:(long)jobId
                     success:(void(^)(JobEntity* result))success
                        fail:(void(^)(NSError* error))fail;
// 关闭职位
// API_postJob_closeJob
+ (void)postJob_closeJobWith:(long)companyId
                         and:(long)jobId
                     success:(void(^)(id result))success
                        fail:(void(^)(NSError* error))fail;

// 开启职位
// API_postJob_openJob
+ (void)postJob_openJobWith:(long)companyId
                        and:(long)jobId
                    success:(void(^)(id result))success
                       fail:(void(^)(NSError* error))fail;

// 删除职位
// API_getJob_deleteJob(CompanyId,JobId)
+ (void)getJob_deleteJobWith:(long)companyId
                         and:(long)jobId
                     success:(void(^)(id result))success
                        fail:(void(^)(NSError* error))fail;

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
                                 success:(void(^)(JSONModelArray* array))success
                                    fail:(void(^)(NSError* error))fail;


// 职位详情
// API_getJobQuery_Detail(JobId)
+ (void)getJobQuery_jobDetailWithJobId:(long)jobId
                               success:(void(^)(JobEntity* result))success
                                  fail:(void(^)(NSError* error))fail;




@end
