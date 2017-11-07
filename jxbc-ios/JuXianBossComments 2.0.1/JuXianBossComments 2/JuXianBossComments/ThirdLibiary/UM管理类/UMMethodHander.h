//
//  UMMethodHander.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/9/9.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface UMMethodHander : NSObject <UIAlertViewDelegate,UNUserNotificationCenterDelegate>
#pragma mark-------第三方登陆
+(void)startThirdLoginIn;
#pragma mark-------友盟统计
+(void)startLogStatistics;
#pragma mark-------消息推送
/// 在应用启动时调用此方法注册
+(void)startWithLaunchOptions:(NSDictionary *)launchOptions;
+ (void)registerDeviceToken:(NSData *)deviceToken;
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
/// 关闭接收消息通知
+ (void)unregisterRemoteNotifications;
/// default is YES
/// 使用友盟提供的默认提示框显示推送信息
+ (void)setAutoAlertView:(BOOL)shouldShow;
/// 应用在前台时，使用自定义的alertview弹出框显示信息
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo;
///绑定一个或多个tag至设备
+(void)setAddTags:(id)parameter;
///删除设备中绑定的一个或多个tag==>按钮点击添加事件
+(void)setRemoveTags:(id)parameter;
///根据地域推送
+(void)setLocationPush;
@end
