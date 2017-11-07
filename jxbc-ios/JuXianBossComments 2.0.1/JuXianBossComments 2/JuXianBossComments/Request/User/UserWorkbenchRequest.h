//
//  UserWorkbenchRequest.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrivatenessSummaryEntity.h"
#import "PrivatenessArchiveSummary.h"
#import "CompanyBankCard.h"
#import "JobEntity.h"

@interface UserWorkbenchRequest : NSObject
//个人工作台+合同信息
+ (void)getPrivatenessSummaryWithSuccess:(void (^)(PrivatenessSummaryEntity *summaryEntity))success fail:(void (^)(NSError *error))fail;

//我的档案没有绑定身份证号
+ (void)getPrivatenessArchiveSummarySuccess:(void (^)(PrivatenessArchiveSummary *archiveSummary))success fail:(void (^)(NSError *error))fail;

//绑定身份证号
+ (void)postPrivatenessBindingIDCard:(NSString *)iDCard success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//我的档案列表
+ (void)getPrivatenessmyArchivesWithSuccess:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;

//个人钱包WalletEntity
+ (void)getPrivatenessWalletWalletSuccess:(void (^)(WalletEntity *walletEntity))success fail:(void (^)(NSError *error))fail;

//个人银行卡列表
+ (void)getPrivatenessBankCardListSuccess:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail;;

//个人提现
+ (void)postPrivatenessDrawMoneyRequesWith:(DrawMoneyEntity *)moneyEntity success:(void(^)(id result))success fail:(void(^)(NSError* error))fail;

//个人分享邀请
+ (void)getPrivatenessInviteRegisterSuccess:(void (^)(InvitedRegisterEntity *invitedEntity))success fail:(void (^)(NSError *error))fail;

//个人求职
+ (void)getJobQuerySearchWithJobName:(NSString *)jobName jobCity:(NSString *)jobCity industry:(NSString *)industry salaryRange:(NSString *)salaryRange page:(int)page size:(int)size success:(void (^)(NSArray *array))success fail:(void (^)(NSError *error))fail;


@end
