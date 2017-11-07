//
//  UserWorkbenchRequest.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserWorkbenchRequest.h"

@implementation UserWorkbenchRequest

//个人工作台+合同信息
+ (void)getPrivatenessSummaryWithSuccess:(void (^)(PrivatenessSummaryEntity *summaryEntity))success fail:(void (^)(NSError *error))fail{


    [WebAPIClient getJSONWithUrl:API_UserSummary parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            PrivatenessSummaryEntity *auditEntity = [[PrivatenessSummaryEntity alloc] initWithDictionary:result error:nil];
            success(auditEntity);
        }
        
    } fail:^(NSError *error) {
         fail(error);
    }];
}
//我的档案没有绑定身份证号
+ (void)getPrivatenessArchiveSummarySuccess:(void (^)(PrivatenessArchiveSummary *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_ArchiveSummary parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            PrivatenessArchiveSummary *archiveSummary = [[PrivatenessArchiveSummary alloc] initWithDictionary:result error:nil];
            success(archiveSummary);
        }
    } fail:^(NSError *error) {
         fail(error);
    }];

}

//绑定身份证号
+ (void)postPrivatenessBindingIDCard:(NSString *)iDCard success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Binding_IDCard(iDCard) parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//我的档案列表
+ (void)getPrivatenessmyArchivesWithSuccess:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{


    [WebAPIClient getJSONWithUrl:API_myArchive_List parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[EmployeArchiveEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//个人钱包WalletEntity
+ (void)getPrivatenessWalletWalletSuccess:(void (^)(WalletEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_User_Wallet parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            WalletEntity *walletEntity = [[WalletEntity alloc] initWithDictionary:result error:nil];
            success(walletEntity);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//个人银行卡列表
+ (void)getPrivatenessBankCardListSuccess:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_User_BankCardList parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[CompanyBankCard class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}


//个人提现
+ (void)postPrivatenessDrawMoneyRequesWith:(DrawMoneyEntity *)moneyEntity success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_User_SubmitMoney parameters:[moneyEntity toDictionary] success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];

}


//个人分享邀请
+ (void)getPrivatenessInviteRegisterSuccess:(void (^)(InvitedRegisterEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_User_Share parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            InvitedRegisterEntity *invitedEntity = [[InvitedRegisterEntity alloc] initWithDictionary:result error:nil];
            success(invitedEntity);
        }
    } fail:^(NSError *error) {
         fail(error);
    }];

}

//个人求职列表
+ (void)getJobQuerySearchWithJobName:(NSString *)jobName jobCity:(NSString *)jobCity industry:(NSString *)industry salaryRange:(NSString *)salaryRange page:(int)page size:(int)size success:(void (^)(NSArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_JobQuery_List(jobName,jobCity,industry,salaryRange,page,size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
//            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[JobEntity class]];
            NSArray * dataArray = [[NSArray alloc] init];
            NSMutableArray *modelArrayM = [NSMutableArray array];
            for (NSDictionary *dict in result) {
                
                JobEntity *jobEntity = [[JobEntity alloc]initWithDictionary:dict error:nil];

                [modelArrayM addObject:jobEntity];
            }
            NSLog(@"modelArrayM===%@",modelArrayM);
            dataArray = modelArrayM.copy;
            success(dataArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}


@end
