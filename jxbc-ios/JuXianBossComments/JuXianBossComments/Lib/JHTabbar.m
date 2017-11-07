//
//  JHTabbar.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHTabbar.h"

@implementation JHTabbar

- (instancetype)init{

    if ( self = [super init]) {
        
        self.barTintColor = [PublicUseMethod setColor:KColor_Tabbar_BlackColor];

        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        self.centerBtn = btn;
        [self addSubview:btn];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    self.centerBtn.size = CGSizeMake(64, 64);
    self.centerBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.3);
    self.centerBtn.centerX = self.centerX;
    self.centerBtn.centerY = self.height * 0.5;

    int index = 2;
    CGFloat wigth = self.bounds.size.width / 3;
    //设置button的大小与位置
//    self.centerBtn.size = [self.centerBtn.currentBackgroundImage size];
    
    
    for (UIView * sub in self.subviews) {
        
        if ([sub isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
//            if (index == 1) {
////                index++;
//                sub.frame = CGRectMake(index * wigth, self.bounds.origin.y, wigth, self.bounds.size.height - 2);
//            }else{
//                sub.frame = CGRectMake(index * wigth, self.bounds.origin.y, wigth, self.bounds.size.height - 2);
//                index++;
//            }
            if (index == 1) {
                index--;
            }
            sub.frame = CGRectMake(index * wigth, self.bounds.origin.y, wigth, self.bounds.size.height - 2);
            index--;
        }
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    if (self.isHidden == NO) {
        
        CGPoint newPoint = [self convertPoint:point toView:self.centerBtn];
        if ([self.centerBtn pointInside:newPoint withEvent:event]) {            
            return self.centerBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }else{
    
        return [super hitTest:point withEvent:event];
    }
}



@end
