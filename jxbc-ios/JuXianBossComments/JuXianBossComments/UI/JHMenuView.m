//
//  JHMenuView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHMenuView.h"

@implementation JHMenuView

- (void)awakeFromNib{
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 4;
    
}

#pragma mark -- 修改档案
- (IBAction)fixArchiveClick:(UIButton *)sender {//tag10 修改评价
  
    if ([self.delegate respondsToSelector:@selector(menuViewDidClickedFixArchive:)]) {
        
        [self.delegate menuViewDidClickedFixArchive:self];
    }
    
}
#pragma mark -- 修改评价 离任报告
- (IBAction)fixCommenClcik:(UIButton *)sender {//tag11修改离任报告

    if ([self.delegate respondsToSelector:@selector(menuViewDidClickedFixComment:)]) {
        [self.delegate menuViewDidClickedFixComment:self];
    }
}

#pragma mark -- 提现
- (IBAction)drawalsMoneyClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(menuViewDidClickedWithdrawals:)]) {
        
        [self.delegate menuViewDidClickedWithdrawals:self];
    }
    
}



+ (instancetype)menuView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"JHMenuView" owner:nil options:nil].lastObject;
}

@end
