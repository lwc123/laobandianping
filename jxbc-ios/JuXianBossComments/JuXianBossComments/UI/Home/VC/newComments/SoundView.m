//
//  SoundView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/12.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SoundView.h"

@implementation SoundView

- (void)awakeFromNib{

    [super awakeFromNib];

}

- (IBAction)cacelClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(soundViewDidClickedCacelWithbutton:WithView:)]) {
        
        [self.delegate soundViewDidClickedCacelWithbutton:sender WithView:self];
    }
}


- (IBAction)sureClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(soundViewDidClickedSurelWithbutton:WithView:)]) {
        [self.delegate soundViewDidClickedSurelWithbutton:sender WithView:self];
    }
}


- (IBAction)recodeSoundClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(soundViewDidClickedRecodelWithbutton:WithView:)]) {
        
        [self.delegate soundViewDidClickedRecodelWithbutton:sender WithView:self];
    }
}

+ (instancetype)soundView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SoundView" owner:nil options:nil].lastObject;
}

@end
