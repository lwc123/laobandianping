//
//  CompanyModel.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/5.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CompanyModel : JSONModel

// 离任档案人数
@property (nonatomic,assign)long DimissionNum;//NSNumber
// 在职档案人数
@property (nonatomic,assign)long EmployedNum;//NSNumber
@property (nonatomic,assign)NSInteger AuditStatus;
@property (nonatomic,assign)long CompanyId;
@property (nonatomic,assign)long PassportId;

@property (nonatomic,copy)NSString<Optional>*CompanyName;
/**合同状态 服务到期*/
@property (nonatomic,copy)NSString<Optional>*ContractStatus;
@property (nonatomic, strong) NSDate *CreatedTime;
@property (nonatomic, strong) NSDate *ModifiedTime;
@property (nonatomic, copy) NSString *CompanyLogo;
//阶段评价数 ,
@property (nonatomic, assign) NSInteger StageEvaluationNum;
//离任报告数 ,
@property (nonatomic, assign) NSInteger DepartureReportNum;
//合同终止时间 ,
@property (nonatomic,strong)NSDate<Optional>*ServiceEndTime;
// 公司简称
@property (nonatomic,copy)NSString<Optional>*CompanyAbbr;
- (NSInteger) getServiceDays;

@end
/*   AuditStatus
NoSubmit (int, optional): 未提交 [ 0 ] ,
Submited (int, optional): 已提交 [ 1 ] ,
AuditPassed (int, optional): 认证通过 [ 2 ] ,
AuditRejected (int, optional): 认证被拒绝 [ 9 ]
*/
// ContractStatus 1未生效，2生效，3过期
/*
 myCompany =         {
 AuditStatus = 1;
 CompanyName = "\U4e3e\U8d24\U7f51\U8001\U677f\U70b9\U8bc4";
 ContractStatus = "<null>";
 
 
 
 AuditStatus = 1;
 CompanyAbbr = "\U8bcd\U5f62\U5bb9\U70ed";
 CompanyId = 4;
 CompanyLogo = "<null>";
 CompanyName = "\U4e3e\U8d24\U7f51\U8001\U677f\U70b9\U8bc42";
 CompanySize = "1-49";
 ContractStatus = 0;
 CreatedTime = "2016-12-09T02:09:00Z";
 Industry = "\U78e8\U7834\U6ca1\U4e8b";
 LegalName = "\U8001\U5a46\U8272\U8272";
 ModifiedTime = "2016-12-09T12:23:56Z";
 PassportId = 12;
 Region = 7;
 
 };

 
 */
