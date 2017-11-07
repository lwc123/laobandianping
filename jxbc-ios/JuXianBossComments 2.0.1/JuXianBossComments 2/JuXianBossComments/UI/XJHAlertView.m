//
//  XJHAlertView.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "XJHAlertView.h"

@implementation XJHAlertView


+ (instancetype)jhAlertView{

    return [[NSBundle mainBundle] loadNibNamed:@"XJHAlertView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
//    NSLog(@"self.bgView.frame==%@",NSStringFromCGRect(self.bgView.frame));
//    NSLog(@"self.bechargeBtn.frame==%@",NSStringFromCGRect(self.bechargeBtn.frame));
//    NSLog(@"self.cancelBtn.frame==%@",NSStringFromCGRect(self.cancelBtn.frame));
    
//    self.bechargeBtn.frame = CGRectMake((self.bgView.bounds.size.width - 156 - 40) * 0.5, 0, 78, 24);
//    self.cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.bechargeBtn.frame) + 40, 0, 78, 24);
    
//    NSLog(@"self.bechargeBtn.frame==%@",NSStringFromCGRect(self.bechargeBtn.frame));
//    NSLog(@"self.cancelBtn.frame==%@",NSStringFromCGRect(self.cancelBtn.frame));

}

- (void)layoutSubviews{
    self.bechargeBtn.frame = CGRectMake((self.bgView.bounds.size.width - 170 - 40) * 0.5, 0, 85, 24);
    self.cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.bechargeBtn.frame) + 40, 0, 85, 24);
}

- (IBAction)cancelBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(xjhAlertViewDidClickOffBtn:)]) {
        
        [self.delegate xjhAlertViewDidClickOffBtn:self];
    }
}

#pragma mark -- 关闭（差号）
- (IBAction)offBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(xjhAlertViewDidClickOffBtn:)]) {
        
        [self.delegate xjhAlertViewDidClickOffBtn:self];
    }
}

#pragma mark -- 充值按钮
- (IBAction)rechargeBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(xjhAlertViewDidClicRechargeBtn:)]) {
        
        [self.delegate xjhAlertViewDidClicRechargeBtn:self];
    }
    
}



@end
