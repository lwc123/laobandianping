//
//  WorkbenchRequest.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SummaryEntity.h"
//添加档案
#import "EmployeArchiveEntity.h"
#import "EmployeArchiveListEntity.h"
#import "ArchiveCommentEntity.h"
#import "WalletEntity.h"
//已评价的年区间
#import "ExistsStageSectionEntity.h"
#import "InvitedRegisterEntity.h"//邀请注册
#import "BizDictModel.h"
#import "JXMessageEntity.h"
#import "ArchiveCommentLogEntity.h"
#import "VersionEntity.h"
@interface WorkbenchRequest : NSObject

//工作台信息
+ (void)getWorkbenchInformiationWithCompanyId:(long)companyId success:(void (^)(CompanySummary *summaryEntity))success fail:(void (^)(NSError *error))fail;
//添加档案
+ (void)postAddEmployeArchiveWith:(EmployeArchiveEntity *)parameter success:(void (^)(ResultEntity *resultEntity))success fail:(void (^)(NSError *error))fail;

//修改员工档案
+ (void)postUpDateEmployeArchiveWith:(EmployeArchiveEntity *)parameter success:(void (^)(ResultEntity *resultEntity))success fail:(void(^)(NSError* error))fail;

//档案列表
+ (void)getEmployeArchiveListWithCompanyId:(long)companyId success:(void (^)(EmployeArchiveListEntity *archiveListEntity))success fail:(void (^)(NSError *error))fail;

//验证身份证号
+ (void)getExistsIDCardWithCompanyId:(long)companyId WithidCard:(NSString *)idCard success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//员工档案详情
+ (void)getArchiveDetailWithCompanyId:(long)companyId ArchiveID:(long)archiveID success:(void (^)(EmployeArchiveEntity *archiveEntity))success fail:(void (^)(NSError *error))fail;

//阶段评价列表 离任列表
+ (void)getCommentSearchListWithCompanyId:(long)companyId commentType:(int)commenttype name:(NSString *)realName page:(int)page size:(int)size success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//添加评价 添加离任
+ (void)postAddArchiveCommentWith:(ArchiveCommentEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//员工离任 阶段详情
+ (void)getCommentDetailWithCompanyId:(long)companyId CommentId:(long)commentId success:(void (^)(ArchiveCommentEntity *commentEntity))success fail:(void (^)(NSError *error))fail;


//修改离任评价
+ (void)postCommentUpdateWith:(ArchiveCommentEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;
//h5档案详情进入修改离任阶段评价
+ (void)getAllArchiveCommentWithCompanyId:(long)CommentId ArchiveId:(long)archiveId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;
//公司钱包
+ (void)getCompanyWalletWithCompanyId:(long)companyId success:(void (^)(WalletEntity *walletEntity))success fail:(void (^)(NSError *error))fail;

//档案搜索结果页
+ (void)getArchiveSearchCompanyId:(long)companyId realName:(NSString *)realName page:(int)page size:(int)size success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;
//查看此档案已添加的年份区间评价
+ (void)getArchiveCommentExistsStageSectionWith:(long)companyId archiveId:(long)archiveId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//邀请注册InvitedRegisterEntity
+ (void)getCompanyInviteRegisterCompanyId:(long)companyId success:(void (^)(InvitedRegisterEntity *invitedEntity))success fail:(void (^)(NSError *error))fail;

//学历字典
+ (void)getAcademicSuccess:(void (^)(AcademicModel *academicModel))success fail:(void (^)(NSError *error))fail;
//获取字典
+ (void)getDictionarySuccess:(void (^)(BizDictModel *bizDictModel))success fail:(void (^)(NSError *error))fail;

// 消息
//消息新改
+ (void)getMessageWithSize:(int)size andPage:(int)page success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//1.1.2消息
+ (void)getMessageListMessageType:(int)messageType size:(int)size andPage:(int)page success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

// 标记消息为已读状态
+ (void)getReadMsgForMessageId:(long)messageId  success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;

// 获取未读消息数量
+ (void)getUnreadMsgNumForCompanyId:(long)companyId  success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;

//修改记录
+ (void)getlogListWithCompanyId:(long)companyId commentId:(long)commentId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

// 检测是否有新版本
+ (void)getExisteVersion:(NSString*)version success:(void (^)(VersionEntity *versionEntity))success fail:(void (^)(NSError *error))fail;


@end
