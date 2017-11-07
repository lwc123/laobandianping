//
//  ChoiceCompanyVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
//选择公司
@interface ChoiceCompanyVC : JXTableViewController

@property (nonatomic,assign) int currentProfile;
@property (nonatomic,strong)NSArray * inforArray;
@property (nonatomic, strong) UIViewController *secondVC;
@end
