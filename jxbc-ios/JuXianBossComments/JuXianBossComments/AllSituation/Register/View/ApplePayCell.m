//
//  ApplePayCell.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "ApplePayCell.h"

@implementation ApplePayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.payBtn.layer.masksToBounds = YES;
    self.payBtn.layer.cornerRadius = 4;
    self.payBtn.adjustsImageWhenHighlighted = NO;
//    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
    self.payBtn.layer.borderWidth = 2;
    self.payBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
}

#pragma mark -- 去支付
- (IBAction)goPayClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(ApplePayCellDidClickedPayBtn:)]) {
        [self.delegate ApplePayCellDidClickedPayBtn:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
