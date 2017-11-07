//
//  JXMessageAlertView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/3/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXMessageAlertView.h"

@implementation JXMessageAlertView

- (void)awakeFromNib{

    [super awakeFromNib];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 16;

}

- (IBAction)clickBtn:(UIButton *)sender {
    if (self.clickBtn.selected == YES) {
        [self.imageBtn setImage:[UIImage imageNamed:@"绿选中"] forState:UIControlStateNormal];
        self.clickBtn.selected = NO;
    }else{
        self.clickBtn.selected = YES;
        [self.imageBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(messageAlertViewDidClickedWithAlertView:)]) {
        [self.delegate messageAlertViewDidClickedWithAlertView:self];
    }
}

#pragma mark -- 取消
- (IBAction)cacelBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(messageAlertViewCacenlClickWithAlertView:)]) {
        [self.delegate messageAlertViewCacenlClickWithAlertView:self];
    }
}


#pragma mark -- 确定
- (IBAction)sureBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(messageAlertViewSurelClickWithAlertView:)]) {
        
        [self.delegate messageAlertViewSurelClickWithAlertView:self];
    }
}




+ (instancetype)messageAlertView{
    return [[NSBundle mainBundle] loadNibNamed:@"JXMessageAlertView" owner:nil options:nil].lastObject;
}

@end
