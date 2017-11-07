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
    self.payBtn.layer.cornerRadius = 5;
    self.payBtn.adjustsImageWhenHighlighted = NO;
    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"loginbutton"] forState:UIControlStateNormal];
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
