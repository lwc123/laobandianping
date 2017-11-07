//
//  SeachRecodeListVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

typedef void(^saveBlock)(NSString * nameStr,NSString *imageStr,long ArchiveId);

//查询员工档案列表
@interface SeachRecodeListVC : JXTableViewController

@property (nonatomic,strong)NSString * realName;
@property (strong, nonatomic)  UIViewController *secondVC;
@property (nonatomic,copy)saveBlock block;

@end
