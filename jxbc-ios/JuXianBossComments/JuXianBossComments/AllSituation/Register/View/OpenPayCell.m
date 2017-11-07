//
//  OpenPayCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "OpenPayCell.h"

@implementation OpenPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.demoBtn.layer.masksToBounds = YES;
    self.demoBtn.layer.cornerRadius = 4;
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.layer.cornerRadius = 4;
    
    self.payBtn.layer.borderWidth = 2;
    self.payBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
