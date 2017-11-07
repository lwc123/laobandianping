//
//  WorkItemEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/8.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface WorkItemEntity : JSONModel
//档案ID
@property (nonatomic,assign)long ArchiveId;
@property (nonatomic,assign)long ItemId;

@property (nonatomic,copy)NSString<Optional>* Department;
//担任职务
@property (nonatomic,copy)NSString<Optional>* PostTitle;
//薪水
@property (nonatomic,copy)NSString<Optional>* Salary;
//任职开始时间
@property (nonatomic,strong)NSDate<Optional>* PostStartTime;
//任职结束日期
@property (nonatomic,strong)NSDate<Optional>* PostEndTime;
@property (nonatomic,strong)NSDate<Optional>* CreatedTime;
@property (nonatomic,strong)NSDate<Optional>* ModifiedTime;


@end
/*
 ItemId (integer, optional): ,
 ArchiveId (integer): 档案ID ,
 Department (string, optional): 部门ID ,
 PostTitle (string, optional): 担任职务 ,
 Salary (string, optional): 薪水 ,
 PostStartTime (string, optional): 任职开始时间 ,
 PostEndTime (string, optional): 任职结束日期 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):

 */
