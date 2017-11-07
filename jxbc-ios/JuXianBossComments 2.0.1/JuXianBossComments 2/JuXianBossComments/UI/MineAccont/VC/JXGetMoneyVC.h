//
//  JXGetMoneyVC.h
//  JuXianBossComments
//
//  Created by wy on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "JXTableViewController.h"

@interface JXGetMoneyVC : JXTableViewController
@property (weak, nonatomic) IBOutlet UITextField *moneyField;
@property (nonatomic,strong)CompanySummary *companySummary;
@property (nonatomic,strong)PrivatenessSummaryEntity *userSummary;
@property (nonatomic,strong)UIViewController *secondVC;
@property (nonatomic,strong)WalletEntity *walletEntity;


@end
