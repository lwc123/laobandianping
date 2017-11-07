//
//  JobPublicPositionViewController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
@class JobEntity;

@interface JobPublicPositionViewController : JXTableViewController
- (instancetype)initWithJobEntity:(JobEntity*) jobEntity;

@end
