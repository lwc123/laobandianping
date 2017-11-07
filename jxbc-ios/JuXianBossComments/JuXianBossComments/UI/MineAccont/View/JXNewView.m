//
//  JXNewView.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/15.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXNewView.h"

@implementation JXNewView

+(instancetype)appearView
{
    UINib *nib = [UINib nibWithNibName:@"JXNewView" bundle:nil];
    JXNewView *View = [nib instantiateWithOwner:nil options:nil][0];
    return View;
}

- (IBAction)btnClick:(UIButton *)sender {
    
    if ([self.dele respondsToSelector:@selector(btnClickWithBtn:)]) {
        [self.dele btnClickWithBtn:sender];
    }
    [self removeFromSuperview];
    
    
    
}


@end
