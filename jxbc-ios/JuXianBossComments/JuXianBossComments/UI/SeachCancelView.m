//
//  SeachCancelView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/3/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "SeachCancelView.h"

@implementation SeachCancelView

#pragma mark -- 搜索
- (IBAction)searchClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(seachDidClickedSeachBtn:)]) {
        [self.delegate seachDidClickedSeachBtn:self];
    }
}



+ (instancetype)seachCancelView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SeachCancelView" owner:nil options:nil].lastObject;
}

@end
