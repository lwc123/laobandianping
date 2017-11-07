//
//  SubAddCardVC.h
//  JuXianBossComments
//
//  Created by wy on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

@interface SubAddCardVC : JXTableViewController
@property (nonatomic,strong)CompanySummary *companySummary;
@property (nonatomic,strong)NSMutableArray *cardListArray;
@property (nonatomic,strong)UIViewController *secondVC;
@property (nonatomic,strong)PrivatenessSummaryEntity *userSummary;
@property (nonatomic,strong)WalletEntity *walletEntity;




@end
