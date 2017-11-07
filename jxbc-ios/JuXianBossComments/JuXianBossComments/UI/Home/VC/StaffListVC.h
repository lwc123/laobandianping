//
//  StaffListVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
@class WorkbenchViewController;
typedef void(^saveBlock)(NSString * nameStr,NSString *imageStr,long ArchiveId);

//离任
typedef void(^departmentBlock)(EmployeArchiveEntity * recodelEntity);


//所有员工档案
@interface StaffListVC : JXTableViewController

/**如果从添加评价 离任报告 过来点击cell就回来传值  如果是从工作台进来点击cell加载员工档案详情*/
@property (nonatomic,strong)UIViewController *secondVC;
@property (nonatomic,assign)long companyId;
@property (nonatomic,copy)saveBlock block;
@property (nonatomic,copy)departmentBlock departBlock;
@property (nonatomic, strong) CompanySummary *company;
@property (nonatomic, weak) UIView *superHeaderView;

@end
