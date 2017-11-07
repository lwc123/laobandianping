//
//  SignOut.h
//  JuXianBossComments
//
//  Created by juxian on 2017/2/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LandingPageViewController.h"
#import "AccountRepository.h"
#import "JXBasedViewController.h"

@interface SignOut : NSObject
+ (void)signOutAccountWith:(UIButton *)btn;
+(void)createNewFails:(NSError *)error;
@end
