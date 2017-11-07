//
//  JobEditWorkDetailController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^EndEditWorkDetailBlock)(NSString* string);

@interface JobEditWorkDetailController : JXBasedViewController


- (void)completeEndEditWorkDetailBlock:(EndEditWorkDetailBlock)endEditWorkDetailBlock;

- (instancetype)initWithDescripton:(NSString*)string;


@end
