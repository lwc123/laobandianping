//
//  JXBaseSrollView.m
//  JuXianTalentBank
//
//  Created by juxian on 16/7/27.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBaseSrollView.h"

@implementation JXBaseSrollView

- (instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
    {
        return YES;
    }
    else
    {
        return  NO;
    }
}

@end
