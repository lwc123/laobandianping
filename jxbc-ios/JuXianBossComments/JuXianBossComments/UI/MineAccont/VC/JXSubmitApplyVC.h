//
//  JXSubmitApplyVC.h
//  JuXianBossComments
//
//  Created by wy on 16/12/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "JXTableViewController.h"
#import "CompanyBankCard.h"

@interface JXSubmitApplyVC : JXTableViewController
@property (nonatomic,strong)CompanySummary *companySummary;
@property(nonatomic,strong)CompanyBankCard *bankCard;
@property (nonatomic,copy)NSString *moneyStr;
@property (nonatomic,copy)NSString *companyNameStr;
@property (nonatomic,copy)NSString *bankStr;
@property (nonatomic,copy)NSString *bankAccountStr;
@property (nonatomic,strong)UIViewController *secondVC;

@property (nonatomic,strong)WalletEntity *walletEntity;


@end
