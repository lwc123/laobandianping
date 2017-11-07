//
//  GetMoneyView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetMoneyView : UIView

//金库
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
//提现金额
@property (weak, nonatomic) IBOutlet UILabel *drawLabel;
@property (weak, nonatomic) IBOutlet UITextField *putMoneyLabel;

//可提现金额
@property (weak, nonatomic) IBOutlet UILabel *canWithdrawLabel;

// 对公/个人银行账号
@property (nonatomic, weak) IBOutlet UILabel *bankAccountLabel;
// 公司/个人金库title
@property (nonatomic, weak) IBOutlet UILabel *accountTitleLabel;

+ (instancetype)getMoneyView;
@end
