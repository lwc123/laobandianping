//
//  AppDelegate+XJHNotificationManager.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (XJHNotificationManager)

/// 注册远程推送
#ifdef __IPHONE_10_0
- (void)registerRemoteNotificationsApplication:(id)application;
#else
- (void)registerRemoteNotificationsApplication:(id)application;
#endif



@end
