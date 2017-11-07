//
//  MineRequest.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/12.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "MineRequest.h"

@implementation MineRequest
//添加授权人
+ (void)postAddCompanyMemberWith:(CompanyMembeEntity *)parameter success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Add_CompanyMember parameters:[parameter toDictionary] success:^(id result) {
        
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

//授权人列表
+ (void)getCompanyMemberListCompanyId:(long)companyId success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_CompanyMember_List(companyId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[CompanyMembeEntity class]];
            success(modelArray);
        }

    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];


}

//修改授权人
+ (void)postUpdateCompanyMemberWith:(CompanyMembeEntity *)parameter success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Update_CompanyMember parameters:[parameter toDictionary] success:^(id result) {
        success(result);
        
    } fail:^(NSError *error) {
        fail (error);

    }];

}

//删除
+ (void)postDelegateCompanyMemberWith:(CompanyMembeEntity *)membeEntity success:(void (^)(id))success fail:(void (^)(NSError *))fail{


    [WebAPIClient postJSONWithUrl:API_Delegate_CompanyMember parameters:[membeEntity toDictionary] success:^(id result) {
        success(result);
        
    } fail:^(NSError *error) {
        fail (error);        
    }];
}
//我提交的（要我审核）列表
+ (void)getCompanyMemberListCompanyId:(long)companyId  andAuditStatus:(long)AuditStatus andPage:(long)page andSize:(long)size success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail
{
    [WebAPIClient getJSONWithUrl:API_ArchiveComment_MyListByAudit(companyId,AuditStatus, page, size) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[ArchiveCommentEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];
}

//进入到H5详情页面之后重新请求的数据
+ (void)getArchiveCommentSummaryCompanyId:(long)companyId CommentId:(long)CommentId success:(void (^)(ArchiveCommentEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_ArchiveComment_Summary(companyId,CommentId) parameters:nil success:^(id result) {
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



//我的
+ (void)getCompanyMineWithCompanyId:(long)companyId success:(void (^)(CompanySummary *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Company_Mine(companyId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            CompanySummary *companySummary = [[CompanySummary alloc] initWithDictionary:result error:nil];
            success(companySummary);
        }
    } fail:^(NSError *error) {
        fail(error);
        NSLog(@"error===%@",error.localizedDescription);
    }];
}


+ (void)getCompanyWalletTradeHistoryWithCompanyId:(long)companyId mode:(int)mode page:(int)page size:(int)size success:(void (^)(id))success fail:(void (^)(NSError *))fail{
    AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
    if (myaccount.UserProfile.CurrentProfileType == OrganizationProfile) {// 公司
        [WebAPIClient getJSONWithUrl:API_TradeHistory_Wallet(companyId, mode, page, size) parameters:nil success:^(id result) {
            
            success(result);
        } fail:^(NSError *error) {
            fail(error);
        }];
    }else{
        
        [WebAPIClient getJSONWithUrl:API_User_TradeHistory(mode, size, page) parameters:nil success:^(id result) {
            
            success(result);
        } fail:^(NSError *error) {
            fail(error);
        }];
    
    }
}


//通过审核
+ (void)PostArchiveCommentAuditPass:(ArchiveCommentEntity *)parameter success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    //[WebAPIClient postJSONWithUrl:API_PostArchiveCommentAuditPass parameters:[parameter toDictionary] success:^(id result) {
       // success(result);
        
   // } fail:^(NSError *error) {
        //fail (error);
   // }];
    
    //[WebAPIClient postJSONWithUrl:API_PostArchiveCommentAuditPass() parameters:nil success:^(id result) {
 //       success(result);
  //  } fail:^(NSError *error) {
      //  fail (error);
  //  }];
}


//通过审核
+ (void)PostArchiveCommentAuditPassWithCompanyId:(long)companyId CommentId:(long)commentId IsSendSms:(BOOL)isSendSms success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_PostArchiveCommentAuditPass(companyId,commentId,isSendSms) parameters:nil success:^(id result) {
           success(result);
      } fail:^(NSError *error) {
      fail (error);
      }];
}


//拒绝
+ (void)PostArchiveCommentAuditReject:(ArchiveCommentEntity *)parameter withCompanyId:(long)companyId success:(void(^)(id result))success fail:(void(^)(NSError* error))fail
{
    [WebAPIClient postJSONWithUrl:API_PostArchiveComment_AuditReject(companyId) parameters:[parameter toDictionary] success:^(id result) {
        success(result);
        
    } fail:^(NSError *error) {
        fail (error);
    }];
    
}

//修改企业信息
+(void)postCompanyUpdateWith:(CompanySummary *)parameter success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Company_Update parameters:[parameter toDictionary] success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail (error);
    }];

}

//部门添加
+ (void)postAddDepartmentWith:(DepartmentsEntity *)parameter success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{
    
    [WebAPIClient postJSONWithUrl:API_Department_Add parameters:[parameter toDictionary] success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            ResultEntity *resultEntity = [[ResultEntity alloc] initWithDictionary:result error:nil];
            success(resultEntity);
        }
    } fail:^(NSError *error) {
        fail (error);
    }];
}

//部门修改
+ (void)postUpdateDepartmentWith:(DepartmentsEntity *)parameter success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Department_Update parameters:[parameter toDictionary] success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail (error);
    }];
}

//部门删除
+ (void)postDeleteDepartmentWith:(DepartmentsEntity *)parameter success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_Department_Delegate parameters:[parameter toDictionary] success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail (error);
    }];

}

//获取银行卡列表
+ (void)getDrawMoneyRequestBankCardListCompanyId:(long)companyId success:(void (^)(JSONModelArray *array))success fail:(void (^)(NSError *error))fail
{
    [WebAPIClient getJSONWithUrl:API_getDrawMoneyRequest_BankCardList(companyId) parameters:nil success:^(id result) {
        
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
        NSLog(@"error===%@",error.localizedDescription);
    }];

}


//部门列表
+ (void)getDepartmentWithCompanyId:(long)companyId success:(void (^)(JSONModelArray *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_Department_List(companyId) parameters:nil success:^(id result) {
        
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }
        else
        {
            NSLog(@"%@",result);
            JSONModelArray *modelArray = [[JSONModelArray alloc]initWithArray:result modelClass:[DepartmentsEntity class]];
            success(modelArray);
        }
        
    } fail:^(NSError *error) {
        fail (error);
    }];
}
//提现申请
+ (void)postDrawMoneyRequestAdd:(DrawMoneyEntity *)parameter success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_PostDrawMoneyRequest_add parameters:[parameter toDictionary] success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            ResultEntity *resultEntity = [[ResultEntity alloc] initWithDictionary:result error:nil];
            success(resultEntity);
        }        
    } fail:^(NSError *error) {
        fail (error);
    }];
}

//意见反馈 --- > 判断次数
+ (void)getAdviceFeedbackFrequencyWithPassportId:(long)passportId success:(void (^)(id))success fail:(void (^)(NSError *))fail{

    [WebAPIClient getJSONWithUrl:API_FeedbackFrequency parameters:nil success:^(id result) {
        success(result);
    } fail:^(NSError *error) {
        fail (error);
    }];
}

//意见反馈
+ (void)postAddFeedback:(FeedbackEntity *)parameter success:(void (^)(ResultEntity *))success fail:(void (^)(NSError *))fail{

    [WebAPIClient postJSONWithUrl:API_FeedbackAdd parameters:[parameter toDictionary] success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            success(result);
        }else
        {
            ResultEntity *resultEntity = [[ResultEntity alloc] initWithDictionary:result error:nil];
            success(resultEntity);
        }
    } fail:^(NSError *error) {
        fail (error);
    }];


}

@end
