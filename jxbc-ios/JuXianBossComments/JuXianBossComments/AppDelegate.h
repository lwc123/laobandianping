//
//  AppDelegate.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^wxBlock)();


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,assign)AFNetworkReachabilityStatus netStatus;
@property (nonatomic,copy)wxBlock block;

+ (AppDelegate *)currentAppDelegate;



@end

