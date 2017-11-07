
//
//  FixCompanyVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

@interface FixCompanyVC : JXTableViewController

@property (nonatomic,strong)CompanySummary * companySummary;
@property (nonatomic,strong)UITextField * cityTf;
@property (nonatomic,copy)NSString * cityCode;

@end
