//
//  WorkbenchCompanyEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CompanyInformationEntity.h"
#import "CompanyMembeEntity.h"

@interface SummaryEntity : CompanyInformationEntity
//离任员工
@property (nonatomic,assign)long DimissionNum;
//在职员工
@property (nonatomic,assign)long EmployedNum;
@property (nonatomic,assign)long UnreadMessageNum;
@property (nonatomic,copy)NSString<Optional>* PromptInfo;
@property (nonatomic,strong)CompanyMembeEntity<Optional> * BossInformation;
@property (nonatomic,strong)CompanyMembeEntity<Optional> * MyInformation;

@end
/*
 AuditInfo = "\U4f01\U4e1a\U8ba4\U8bc1\U4fe1\U606f\U5ba1\U6838\U4e2d\Uff0c\U8bf7\U8010\U5fc3\U7b49\U5f85\U3002\U8054\U7cfb\U5ba2\U670d%QQ592620843%";
 AuditStatus = 1;
 CompanyAbbr = "\U7d27\U8feb\U54b3\U54b3";
 CompanyId = 4;
 CompanyLogo = "<null>";
 CompanyName = "\U4e3e\U8d24\U7f51\U8001\U677f\U70b9\U8bc42";
 CompanySize = "1-49";
 ContractStatus = "<null>";
 CreatedTime = "2016-12-05T16:02:00Z";
 DimissionNum = 0;
 EmployedNum = 0;
 Industry = "\U78e8\U7834\U6ca1\U4e8b";
 LegalName = "\U54e6\U5a46\U602a\U6211\U54af";
 ModifiedTime = "2016-12-05T16:02:00Z";
 PassportId = 12;
 Region = 8;
 myMesage = 0;
 */
