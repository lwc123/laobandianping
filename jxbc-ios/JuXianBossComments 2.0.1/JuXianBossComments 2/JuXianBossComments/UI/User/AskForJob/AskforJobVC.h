//
//  AskforJobVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

//求职
//JobName:@"" jobCity:@"" industry:@"" salaryRange:@""
@interface AskforJobVC : JXTableViewController

@property (nonatomic, copy) NSString *jobName;
@property (nonatomic, copy) NSString *jobCity;
@property (nonatomic, copy) NSString *industry;
@property (nonatomic, copy) NSString *salaryRange;
@end
