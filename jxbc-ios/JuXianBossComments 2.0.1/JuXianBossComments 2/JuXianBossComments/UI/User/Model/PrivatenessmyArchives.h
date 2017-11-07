//
//  PrivatenessmyArchives.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "EmployeArchiveEntity.h"

@interface PrivatenessmyArchives : EmployeArchiveEntity
@property (nonatomic,copy)NSString<Optional> * CompanyName;
@property (nonatomic,assign)long StageEvaluationNum;
@property (nonatomic,assign)long DepartureReportNum;

@end

/*
 PrivatenessmyArchives {
 CompanyName (string, optional): 公司名称 ,
 StageEvaluationNum (integer, optional): 阶段评价个数 ,
 DepartureReportNum (integer, optional): 离任报告个数 ,
 ArchiveId (integer, optional): 档案ID ,
 CompanyId (integer, optional): ,
 PresenterId (integer, optional): 提交人 ,
 ModifiedId (integer, optional): 修改人 ,
 DeptId (integer, optional): 部门ID ,
 CommentsNum (integer, optional): 评价数 ,
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
 WorkItems (WorkItem, optional),
 WorkItem (WorkItem, optional)
 }
 WorkItem {
 ArchiveId (integer): 档案ID ,
 Department (string, optional): 部门名称 ,
 PostTitle (string, optional): 担任职务 ,
 Salary (string, optional): 薪水 ,
 PostStartTime (string, optional): 任职开始时间 ,
 PostEndTime (string, optional): 任职结束日期 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }
 
 */
