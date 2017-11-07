//
//  AddStaffRecordVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
//添加员工档案
@interface AddStaffRecordVC : JXTableViewController

@property (nonatomic,assign)int jobstatus;
@property (nonatomic,assign)long companyId;
@property (nonatomic,strong)EmployeArchiveEntity * employeEntity;
@property (nonatomic,strong)WorkItemEntity * workItemEntity;
@property (nonatomic,strong)UIViewController *secondVC;

@end
