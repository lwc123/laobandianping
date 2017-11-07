//
//  MineRequest.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/12.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyMembeEntity.h"
#import "CompanySummary.h"
#import "ArchiveCommentEntity.h"
#import "DepartmentsEntity.h"
#import "CompanyBankCard.h"
#import "DrawMoneyEntity.h"
#import "ResultEntity.h"
#import "FeedbackEntity.h"

@interface MineRequest : NSObject
//添加授权人
+ (void)postAddCompanyMemberWith:(CompanyMembeEntity *)parameter success:(void (^)(ResultEntity *resultEntity))success fail:(void (^)(NSError *error))fail;
//授权人列表
+ (void)getCompanyMemberListCompanyId:(long)companyId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;
//修改
+ (void)postUpdateCompanyMemberWith:(CompanyMembeEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//删除
+ (void)postDelegateCompanyMemberWith:(CompanyMembeEntity *)membeEntity success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//我提交的（要我审核）列表
+ (void)getCompanyMemberListCompanyId:(long)companyId  andAuditStatus:(long)AuditStatus andPage:(long)page andSize:(long)size success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//进入到H5详情页面之后重新请求的数据
+ (void)getArchiveCommentSummaryCompanyId:(long)companyId CommentId:(long)CommentId success:(void (^)(ArchiveCommentEntity *commentEntity))success fail:(void (^)(NSError *error))fail;





//我的
+ (void)getCompanyMineWithCompanyId:(long)companyId success:(void (^)(CompanySummary *companySummary))success fail:(void (^)(NSError *error))fail;


//交易
+ (void)getCompanyWalletTradeHistoryWithCompanyId:(long)companyId mode:(int)mode page:(int)page size:(int)size success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;


//通过审核
+ (void)PostArchiveCommentAuditPass:(ArchiveCommentEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//XJh
+ (void)PostArchiveCommentAuditPassWithCompanyId:(long)companyId CommentId:(long)commentId IsSendSms:(BOOL)isSendSms success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

+ (void)PostArchiveCommentAuditReject:(ArchiveCommentEntity *)parameter withCompanyId:(long)companyId success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//修改企业信息
+ (void)postCompanyUpdateWith:(CompanySummary *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//部门添加
+ (void)postAddDepartmentWith:(DepartmentsEntity *)parameter success:(void(^)(ResultEntity *resultEntity))success fail:(void(^)(NSError* error))fail;

//部门修改
+ (void)postUpdateDepartmentWith:(DepartmentsEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//部门删除
+ (void)postDeleteDepartmentWith:(DepartmentsEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//获取银行卡列表
+ (void)getDrawMoneyRequestBankCardListCompanyId:(long)companyId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//部门列表
+ (void)getDepartmentWithCompanyId:(long)companyId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//提现申请
+ (void)postDrawMoneyRequestAdd:(DrawMoneyEntity *)parameter success:(void (^)(ResultEntity *resultEntity))success fail:(void (^)(NSError *error))fail;

//意见反馈 --- > 判断次数
+ (void)getAdviceFeedbackFrequencyWithPassportId:(long)passportId success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//意见反馈
+ (void)postAddFeedback:(FeedbackEntity *)parameter success:(void (^)(ResultEntity *resultEntity))success fail:(void (^)(NSError *error))fail;

@end
