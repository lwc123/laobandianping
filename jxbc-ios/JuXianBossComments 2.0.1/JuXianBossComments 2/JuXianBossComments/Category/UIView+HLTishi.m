//
//  UIView+HLTishi.m
//  HaoLinApp
//
//  Created by 张亚鹏 on 15/6/17.
//  Copyright (c) 2015年 HL. All rights reserved.
//

#import "UIView+HLTishi.h"

@interface UIView ()
{
    UIView *view1;
    UIView *customView;
}

@end
@implementation UIView (HLTishi)

+ (void)alertViewWithTitle:(NSString *)title tishiImage:(UIImage *)tishiImage withDuration:(CGFloat)duration frame:(CGRect)rect
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    UIView *tishview ;
    
     UILabel *label;
    if (rect.size.height >45 && tishiImage != nil)
    {
        tishview = [[UIView alloc] initWithFrame:rect];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.size.width/2 - 15, rect.size.height/3 - 15, 30, 30)];
        imageView.image = tishiImage;
        [tishview addSubview:imageView];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height/3*2 - 10, rect.size.width, rect.size.height/3)];
    }
   
    if (rect.size.height < 45)
    {
        tishview = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, 40)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 40)];
    }
    tishview.layer.cornerRadius = 3;
    tishview.layer.masksToBounds = YES;
    
    tishview.backgroundColor = [UIColor whiteColor];
    tishview.alpha = 1.0;
    if (IS_IPHONE_4 || IS_IPHONE_5)
    {
        label.font = SetFont(14);
    }
    else
    {
        label.font = SetFont(16);
    }
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = mainColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [tishview addSubview:label];
    [[[UIApplication sharedApplication] keyWindow] insertSubview:tishview aboveSubview:view];
    
    if (duration > 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view removeFromSuperview];
            [tishview removeFromSuperview];
        });
    }
}

+(void)showBottomView:(void(^)(UIWindow *window))btomBlock
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenWidth)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.4;
    [window addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackHiddenWidow:)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    btomBlock(window);
}

- (void)tapBackHiddenWidow:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}

@end
