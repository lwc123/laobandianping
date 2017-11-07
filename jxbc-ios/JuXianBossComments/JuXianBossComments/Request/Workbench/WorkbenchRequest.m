//
//  WorkbenchRequest.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//
#import "WorkbenchRequest.h"

@implementation WorkbenchRequest

//工作台信息
+ (void)getWorkbenchInformiationWithCompanyId:(long)companyId success:(void (^)(CompanySummary *summaryEntity))success fail:(void (^)(NSError *error))fail{

    [WebAPIClient getJSONWithUrl:API_CompanyInformation(companyId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            CompanySummary * summaryEntity = [[CompanySummary alloc] initWithDictionary:result error:nil];
            success(summaryEntity);
            
        }
    } fail:^(NSError *error) {
        
        fail (error);
    }];
}

//添加档案
+ (void)postAddEmployeArchiveWith:(EmployeArchiveEntity *)parameter success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient postJSONWithUrl:API_AddEmployeArchive parameters:[parameter toDictionary] success:^(id result) {
        
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




//修改员工档案
+ (void)postUpDateEmployeArchiveWith:(EmployeArchiveEntity *)parameter success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_UpDate_EmployeArchive parameters:[parameter toDictionary] success:^(id result) {
//        success(result);
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

//档案列表
+ (void)getEmployeArchiveListWithCompanyId:(long)companyId success:(void (^)(EmployeArchiveListEntity *archiveListEntity))success fail:(void (^)(NSError *error))fail{

    [WebAPIClient getJSONWithUrl:API_EmployeArchiveList(companyId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            EmployeArchiveListEntity *archiveListEntity = [[EmployeArchiveListEntity alloc] initWithDictionary:result error:nil];
            success(archiveListEntity);
        }
    } fail:^(NSError *error) {
        fail (error);
    }];

}

//添加评价 离任报告
+ (void)postAddArchiveCommentWith:(ArchiveCommentEntity *)parameter success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    [WebAPIClient postJSONWithUrl:API_ArchiveComment parameters:[parameter toDictionary] success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//验证身份证号
+ (void)getExistsIDCardWithCompanyId:(long)companyId WithidCard:(NSString *)idCard success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Exists_IDCar(companyId,idCard) parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);

    }];
}
//员工档案详情
+ (void)getArchiveDetailWithCompanyId:(long)companyId ArchiveID:(long)archiveID success:(void (^)(EmployeArchiveEntity *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_ArchiveDetail(companyId,archiveID) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            EmployeArchiveEntity *archiveEntity = [[EmployeArchiveEntity alloc] initWithDictionary:result error:nil];
            success(archiveEntity);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//评价列表 离任列表
+ (void)getCommentSearchListWithCompanyId:(long)companyId commentType:(int)commenttype name:(NSString *)realName page:(int)page size:(int)size success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_CommentSeach_List(companyId, commenttype, realName, page, size) parameters:nil success:^(id result) {
    
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[ArchiveCommentEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}
//员工离任 阶段详情
+ (void)getCommentDetailWithCompanyId:(long)companyId CommentId:(long)commentId success:(void (^)(ArchiveCommentEntity *))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_Comment_Detail(companyId,commentId) parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            ArchiveCommentEntity *commentEntity = [[ArchiveCommentEntity alloc] initWithDictionary:result error:nil];
            success(commentEntity);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];


}

//修改离任评价
+ (void)postCommentUpdateWith:(ArchiveCommentEntity *)parameter success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Comment_Update parameters:[parameter toDictionary] success:^(id result) {
        
           success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}
//h5档案详情进入修改离任阶段评价
+ (void)getAllArchiveCommentWithCompanyId:(long)CommentId ArchiveId:(long)archiveId success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_AllComment_List(CommentId,archiveId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[ArchiveCommentEntity class]];
            success(modelArray);
        }
    } fail:^(NSError *error) {
        fail(error);
        
    }];
}

//公司钱包
+ (void)getCompanyWalletWithCompanyId:(long)companyId success:(void (^)(WalletEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Company_Wallet(companyId) parameters:nil success:^(id result) {
        
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

//档案搜索结果页
+ (void)getArchiveSearchCompanyId:(long)companyId realName:(NSString *)realName page:(int)page size:(int)size success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{
    [WebAPIClient getJSONWithUrl:API_ArchiveSeach_List(companyId, realName, page, size) parameters:nil success:^(id result) {
        
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

//查看此档案已添加的年份区间评价
+ (void)getArchiveCommentExistsStageSectionWith:(long)companyId archiveId:(long)archiveId success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Exists_StageSection(companyId,archiveId) parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[ExistsStageSectionEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}
//邀请注册
+ (void)getCompanyInviteRegisterCompanyId:(long)companyId success:(void (^)(InvitedRegisterEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_InviteRegister(companyId) parameters:nil success:^(id result) {
        
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


//学历字典
+ (void)getAcademicSuccess:(void (^)(AcademicModel *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_Dictionary_Academic parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            AcademicModel *academicModel = [[AcademicModel alloc] initWithDictionary:result error:nil];
            success(academicModel);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];

}

+ (void)getDictionarySuccess:(void (^)(BizDictModel *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Dictionary_leaving parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            BizDictModel *bizDictModel = [[BizDictModel alloc] initWithDictionary:result error:nil];
            success(bizDictModel);
        }
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}

#pragma mark - 消息
//消息新改
+ (void)getMessageWithSize:(int)size andPage:(int)page success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_getAppMsg(size,page) parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[JXMessageEntity class]];
            success(modelArray);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];

}

//1.1.2消息
+ (void)getMessageListMessageType:(int)messageType size:(int)size andPage:(int)page success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_getMsgList(messageType,size,page) parameters:nil success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[JXMessageEntity class]];
            success(modelArray);
        }
    } fail:^(NSError *error) {
        fail(error);
    }];
}
// 标记消息为已读状态
+ (void)getReadMsgForMessageId:(long)messageId success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_getReadMsg(messageId) parameters:nil success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];

}


// 获取未读消息数量
+ (void)getUnreadMsgNumForCompanyId:(long)companyId success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient getJSONWithUrl:API_getUnreadMsgNum(companyId) parameters:nil success:^(id result) {
        
        success(result);
        
    } fail:^(NSError *error) {
        fail(error);
    }];
}

//修改记录
+ (void)getlogListWithCompanyId:(long)companyId commentId:(long)commentId success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_getLogList(companyId,commentId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[ArchiveCommentLogEntity class]];
            success(modelArray);
        }
    } fail:^(NSError *error) {
        fail(error);

    }];

}

// 检测是否有新版本
+ (void)getExisteVersion:(NSString*)version success:(void (^)(VersionEntity *versionEntity))success fail:(void (^)(NSError *error))fail{
    
    [WebAPIClient getJSONWithUrl:API_ExistsVersion(version) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else{
            VersionEntity *versionEntity = [[VersionEntity alloc] initWithDictionary:result error:nil];
            success(versionEntity);

        }
    } fail:^(NSError *error) {
        fail(error);
    }];
    
}

//获取消息列表红点逻辑
+(void)getMessageUnreadWithmessageType:(int)messageType success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_MessageUnread(messageType) parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail(error);
    }];

}

@end
