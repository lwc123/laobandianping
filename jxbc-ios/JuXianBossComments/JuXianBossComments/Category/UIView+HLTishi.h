//
//  UIView+HLTishi.h
//  HaoLinApp
//
//  Created by 张亚鹏 on 15/6/17.
//  Copyright (c) 2015年 HL. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (HLTishi)

+ (void)alertViewWithTitle:(NSString *)title tishiImage:(UIImage *)tishiImage withDuration:(CGFloat)duration frame:(CGRect)rect;


+(void)showBottomView:(void(^)(UIWindow *window))btomBlock;


@end
