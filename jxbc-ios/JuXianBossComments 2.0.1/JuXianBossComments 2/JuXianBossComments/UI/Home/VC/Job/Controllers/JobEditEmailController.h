//
//  JobEditEmailController.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

typedef void(^EndEditEmailBlock)(NSString* string);

@interface JobEditEmailController : JXBasedViewController

-(void)completeEditEmailHandle:(EndEditEmailBlock)endEditEmailBlock;

- (instancetype)initWithEmail:(NSString*)string;

@end
