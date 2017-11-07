//
//  InformationModel.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CompanyModel.h"

typedef NS_ENUM(long, Role) {
    Role_Boss = 1,//老板
    Role_manager = 2,//管理员
    Role_HightManager = 3,//高管
    Role_BuildMembers = 4//建档员
};

//登录成功之后
@interface CompanyMembeEntity : JSONModel
//SC.XJH.2.21
@property (nonatomic,assign)long CompanyId;

@property (nonatomic,assign)long MemberId;
@property (nonatomic,copy)NSString<Optional>*JobTitle;
@property (nonatomic,copy)NSString<Optional>*RealName;
/**角色*/
@property (nonatomic,assign)Role Role;
@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,assign)long UnreadMessageNum;//SC.XJH.12.30
//
@property (nonatomic,strong)CompanyModel<Optional> *myCompany;
@property (nonatomic,assign)long PassportId;
@property (nonatomic,copy)NSString<Optional>*MobilePhone;

//操作人id
@property (nonatomic,assign)long ModifiedId;
//修改人id
@property (nonatomic,assign)long PresenterId;

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
