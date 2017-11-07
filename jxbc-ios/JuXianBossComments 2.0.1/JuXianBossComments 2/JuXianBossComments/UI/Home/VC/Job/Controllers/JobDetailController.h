//
//  JobDetailController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
@class JobEntity;

@interface JobDetailController : JXBasedViewController

- (instancetype)initWithJob:(JobEntity* )jobEntity;

@end
