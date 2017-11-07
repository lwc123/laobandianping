//
//  CommentsListVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

//评价列表
@interface CommentsListVC : JXTableViewController

@property (nonatomic,assign)long companyId;
@property (nonatomic, strong) WorkHeaderView *headerView;
@end
