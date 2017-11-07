//
//  TopAlertView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/5.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "TopAlertView.h"

@implementation TopAlertView


- (IBAction)offBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(topAlertViewDidClickedOffBtn:)]) {

        [self.delegate topAlertViewDidClickedOffBtn:self];
    }
}

#pragma markk-- 在电脑上创建简历
- (IBAction)addBtnPcClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(topAlertViewAddRecodeOnPc:)]) {
        
        [self.delegate topAlertViewAddRecodeOnPc:self];
    }
    
}


+ (instancetype)topAlertView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"TopAlertView" owner:nil options:nil].lastObject;
}


@end
