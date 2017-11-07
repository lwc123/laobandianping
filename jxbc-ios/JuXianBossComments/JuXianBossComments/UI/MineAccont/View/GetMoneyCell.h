//
//  GetMoneyCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetMoneyCell : UITableViewCell
//公司名称
@property (weak, nonatomic) IBOutlet UILabel *companyName;
//银行账户
@property (weak, nonatomic) IBOutlet UILabel *bankAccount;
///开户银行
@property (weak, nonatomic) IBOutlet UILabel *openBank;

@end
