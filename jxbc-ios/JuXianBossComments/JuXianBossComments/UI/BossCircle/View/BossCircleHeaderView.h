//
//  BossCircleHeaderView.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IconButtonClickBlock)();

@interface BossCircleHeaderView : UIView

- (void)iconButtonClickBlockComplete:(IconButtonClickBlock)iconButtonClickBlock;

- (void)updateIconAndCompanyName;

@end
