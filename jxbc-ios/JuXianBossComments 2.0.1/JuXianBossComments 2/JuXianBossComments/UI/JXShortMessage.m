//
//  JXShortMessage.m
//  JuXianBossComments
//
//  Created by juxian on 2017/3/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXShortMessage.h"

@implementation JXShortMessage

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.imageBtn setImage:[UIImage imageNamed:@"groupprotocol"] forState:UIControlStateSelected];
    [self.imageBtn setImage:[UIImage imageNamed:@"redsection"] forState:UIControlStateNormal];
    self.imageBtn.selected = self.clinkBtn.selected;
}

- (IBAction)clickBtn:(UIButton *)sender {
    
    if (self.clinkBtn.selected == YES) {
        self.imageBtn.selected = NO;
        self.clinkBtn.selected = NO;
    }else{
        self.clinkBtn.selected = YES;
        self.imageBtn.selected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(shortMessageDidClickedWith:shortMessage:)]) {
        [self.delegate shortMessageDidClickedWith:self.imageBtn shortMessage:self];
    }
    
}

+ (instancetype)shortMessage{
    
    return [[NSBundle mainBundle] loadNibNamed:@"JXShortMessage" owner:nil options:nil].lastObject;
}



@end
