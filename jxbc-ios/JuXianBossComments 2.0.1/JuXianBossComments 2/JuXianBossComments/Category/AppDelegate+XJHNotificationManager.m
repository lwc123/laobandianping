//
//  AppDelegate+XJHNotificationManager.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AppDelegate+XJHNotificationManager.h"
#import <UserNotifications/UserNotifications.h>


@implementation AppDelegate (XJHNotificationManager)

//#ifdef __IPHONE_10_0
//-(void)registerRemoteNotificationsApplication:(id)application
//#else
//- (void)registerRemoteNotificationsApplication:(id)application
//#endif
//{
//#ifdef __IPHONE_10_0
//    
//    //设置代理对象
//    [UNUserNotificationCenter currentNotificationCenter].delegate = application;
//    
//    // 请求权限
//    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
//        
//        if (granted == true)//如果准许，注册推送
//        {
//            [[UIApplication sharedApplication]registerForRemoteNotifications];
//        }
//    }];
//    
//#else
//    
//#ifdef __IPHONE_8_0 //适配iOS 8
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
//    
//    [[UIApplication sharedApplication]registerForRemoteNotifications];
//    
//#else //适配iOS7
//    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
//#endif
//    
//#endif
//}
// 注册推送成功
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //    NSLog(@"token = %@",deviceToken);
    // 将返回的token发送给服务器
}

// 注册推送失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"remoteNotice failture = %@",error.localizedDescription);
}



@end
