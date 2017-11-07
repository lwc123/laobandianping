//
//  JXCardDetailCell.h
//  JuXianBossComments
//
//  Created by wy on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyBankCard.h"
@interface JXCardDetailCell : UITableViewCell
@property (nonatomic,strong)CompanyBankCard *bankCardModel;
@property (weak, nonatomic) IBOutlet UIButton *duiGouBtn;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@end
