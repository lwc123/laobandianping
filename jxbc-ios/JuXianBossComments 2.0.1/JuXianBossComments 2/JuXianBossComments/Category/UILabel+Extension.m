//
//  UILabel+Extension.m
//  JuXianTalentBank
//
//  Created by juxian on 16/9/27.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title titleColor :(UIColor *)mycolor fontSize:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines{
    UILabel * myLabel = [[UILabel alloc] initWithFrame:frame];
    myLabel.text = title;
    myLabel.textColor = mycolor;
    myLabel.font = [UIFont systemFontOfSize:fontSize];
    myLabel.numberOfLines = numberOfLines;
    return myLabel;
}

@end
