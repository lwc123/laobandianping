//
//  EmployeArchiveEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/8.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "WorkItemEntity.h"
#import "JXJhDate.h"
//员工档案
@interface EmployeArchiveEntity : JSONModel

//档案ID
@property (nonatomic,assign)long ArchiveId;
@property (nonatomic,assign)long CompanyId;
//提交人
@property (nonatomic,assign)long PresenterId;
//修改人
@property (nonatomic,assign)long ModifiedId;
// 部门ID ,
@property (nonatomic,assign)long DeptId;
//评价数 
@property (nonatomic,assign)long CommentsNum;
//是否离任，0在职，1离任
@property (nonatomic,assign)int IsDimission;
@property (nonatomic,copy)NSString<Optional>* RealName;
//身份证号
@property (nonatomic,copy)NSString<Optional>* IDCard;
@property (nonatomic,copy)NSString<Optional>* Gender;
@property (nonatomic,copy)NSString<Optional>* Birthday;
@property (nonatomic,copy)NSString<Optional>* Picture;
@property (nonatomic,copy)NSString<Optional>* MobilePhone;
//入职日期
@property (nonatomic,strong)NSDate<Optional>* EntryTime;
//离任日期
@property (nonatomic,strong)NSDate<Optional>* DimissionTime;
//毕业学校
@property (nonatomic,copy)NSString<Optional>* GraduateSchool;
//学历code
@property (nonatomic,copy)NSString<Optional>* Education;
//学历name
@property (nonatomic,copy)NSString<Optional>* EducationText;

@property (nonatomic,strong)NSDate<Optional>* CreatedTime;
@property (nonatomic,strong)NSDate<Optional>* ModifiedTime;
//担任职务
@property (nonatomic,strong)NSArray<Optional>* WorkItems;
@property (nonatomic,strong)WorkItemEntity<Optional>* WorkItem;

@property (nonatomic,copy)NSString<Optional> * CompanyName;
@property (nonatomic,strong)NSNumber<Optional>*  StageEvaluationNum;
@property (nonatomic,strong)NSNumber<Optional>*  DepartureReportNum;
//是否发送短信
@property (nonatomic, assign) BOOL IsSendSms;

@end

/*
 EmployeArchive {
 ArchiveId (integer, optional): 档案ID ,
 CompanyId (integer): ,
 PresenterId (integer, optional): 提交人 
 ,
 ModifiedId (integer, optional): 修改人 ,
 IsDimission (integer, optional): 是否离任，0在职，1离任 ,
 RealName (string, optional): 真实姓名 ,
 IDCard (string, optional): 身份证号 ,
 Gender (string, optional): 性别 ,
 Birthday (string, optional): 出生年月 ,
 Picture (string, optional): 头像 ,
 MobilePhone (string, optional): 手机号 ,
 EntryTime (string, optional): 入职日期 ,
 
 DimissionTime (string, optional): 离任日期 ,
 GraduateSchool (string, optional): 毕业学校 ,
 Education (string, optional): 学历 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional): ,

 WorkItem {
 ItemId (integer, optional): ,
 ArchiveId (integer): 档案ID ,
 Department (string, optional): 部门ID ,
 PostTitle (string, optional): 担任职务 ,
 Salary (string, optional): 薪水 ,
 PostStartTime (string, optional): 任职开始时间 ,
 PostEndTime (string, optional): 任职结束日期 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }
 */
