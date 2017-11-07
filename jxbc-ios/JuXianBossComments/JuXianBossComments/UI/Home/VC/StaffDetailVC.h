//
//  StaffDetailVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

//员工详情 是5 页面
@interface StaffDetailVC : JXBasedViewController

@property (nonatomic,assign)long archiveId;
@property (nonatomic,assign)long companyId;

@property (nonatomic,strong)UIViewController * secondVC;

@end

