//
//  DepartmentsEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

// 为部门数组列表（取出部门ID，名称，人数，排序），
@interface DepartmentsEntity : JSONModel

@property (nonatomic,assign)long DeptId;
@property (nonatomic,assign)long CompanyId;
//提交人ID ,
@property (nonatomic,assign)long PresenterId;
//部门排序
@property (nonatomic,assign)long DeptSort;
//部门在岗人数 ,
@property (nonatomic,assign)long StaffNumber;

//部门名称
@property (nonatomic,copy)NSString<Optional>* DeptName;
@property (nonatomic,strong)NSDate<Optional> * CreatedTime;
@property (nonatomic,strong)NSDate<Optional> * ModifiedTime;
@end
/*
 DeptId (integer, optional): ,
 CompanyId (integer, optional): ,
 PresenterId (integer, optional): 提交人ID ,
 DeptName (string): 部门名称 ,
 DeptSort (integer, optional): 部门排序 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }
 */
