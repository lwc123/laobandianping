//
//  BossCirclePublicDynamicVCViewController.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletePublicBlock)();

@interface BossCirclePublicDynamicViewController : JXBasedViewController

- (void)CompletePublicHandle:(CompletePublicBlock)completePublicBlock;

@end
