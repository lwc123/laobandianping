//
//  JXCardDetailCell.m
//  JuXianBossComments
//
//  Created by wy on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXCardDetailCell.h"

@implementation JXCardDetailCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBankCardModel:(CompanyBankCard *)bankCardModel
{
    _bankCardModel = bankCardModel;
    self.companyNameLabel.text = bankCardModel.CompanyName;
    self.cardNumberLabel.text = bankCardModel.BankCard;
    self.bankNameLabel.text = bankCardModel.BankName;
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
