//
//  EmployeArchiveListEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//档案列表
@interface EmployeArchiveListEntity : JSONModel

@property (nonatomic,strong)NSArray<Optional> * Departments;
@property (nonatomic,strong)NSArray<Optional> * ArchiveLists;


@end
/*
 
 Departments 为部门数组列表（取出部门ID，名称，人数，排序），
 EmployeArchives 为档案数组列表（取出头像，姓名，评价数，部门ID），
 */
