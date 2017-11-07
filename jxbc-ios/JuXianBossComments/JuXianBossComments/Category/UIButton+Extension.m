//
//  UIButton+Extension.m
//  JuXianTalentBank
//
//  Created by juxian on 16/9/27.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)myColor imageName:(NSString *)imageName bgImageName:(NSString *)bgName{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:myColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:bgName] forState:UIControlStateNormal];
    return button;
}

@end
