//
//  InformationModel.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CompanyModel.h"
//登录成功之后
@interface InformationModel : JSONModel

@property (nonatomic,assign)long CompanyId;
@property (nonatomic,assign)long MemberId;
@property (nonatomic,copy)NSString<Optional>*JobTitle;
@property (nonatomic,copy)NSString<Optional>*MemberName;
/**角色*/
@property (nonatomic,assign)int Role;
@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,assign)int myMesage;
//
@property (nonatomic,strong)CompanyModel<Optional> *myCompany;


@end
/*
 CompanyId = 1;
 
 CreatedTime = "2016-12-05T15:13:34Z";
 
 JobTitle = "PHP\U7814\U53d1";
 MemberId = 1;
 MemberName = "\U5b8b\U7b56";
 ModifiedTime = "2016-12-05T15:13:34Z";
 PassportId = 62;
 Role = 1;
 
 myCompany =         {
 AuditStatus = 1;
 CompanyName = "\U4e3e\U8d24\U7f51\U8001\U677f\U70b9\U8bc4";
 ContractStatus = "<null>";
 };
 myMesage = 0;
 },

 */
