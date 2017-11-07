//
//  RecodeCheckVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

//档案查询员工
@interface RecodeCheckVC : JXBasedViewController

//用于存放搜索过的数据
@property (nonatomic,strong)NSArray * hisData;
@property (strong, nonatomic)  UITableView *tableview;
@property (strong, nonatomic)  UIViewController *secondVC;



@end
