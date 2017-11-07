//
//  UIButton+Extension.h
//  JuXianTalentBank
//
//  Created by juxian on 16/9/27.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

/**
 *  自定义Button
 *  @param frame  尺寸
 *  @param title  标题
 *  @param bgName 背景图片名称
 *
 *  @return Button实例
 */
+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)myColor imageName:(NSString *)imageName bgImageName:(NSString *)bgName;

@end
