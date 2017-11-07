//
//  SeachView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/6.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachView.h"

@implementation SeachView

- (void)awakeFromNib{

    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 4;
    self.placehoderText.layer.masksToBounds = YES;
    self.placehoderText.layer.cornerRadius = 4;
}

- (IBAction)seachJumpClcik:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(seachViewDidClickedSeachBtn:)]) {
        [self.delegate seachViewDidClickedSeachBtn:self];
    }
}


+ (instancetype)seachView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SeachView" owner:nil options:nil].lastObject;
}
@end
