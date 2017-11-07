//
//  UMMethodHander.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/9/9.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "UMMethodHander.h"
#import "UMSocialWechatHandler.h"

//#import "MobClick.h"

#import "UMessage.h"
//#define UMAppKey @"55cb166ae0f55a4a5a001c9e"
@interface UMMethodHander ()

@property (nonatomic, strong) NSDictionary *userInfo;

@end
@implementation UMMethodHander

+ (UMMethodHander *)shared {
    static UMMethodHander *sharedObject = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}
#pragma mark-------第三方登陆
+(void)startThirdLoginIn
{
   
}
#pragma mark-------友盟统计
+(void)startLogStatistics
{
    //友盟统计
    //友盟统计分析是一款专业的移动应用统计分析工具，致力于为开发者提供实时、稳定的移动应用统计分析服务，帮助开发者更好地了解用户、优化产品以及提升转化率。友盟统计分析客户端，可以方便开发者查看应用数据，随时随地掌握应用的运营状态。
    
    //开启友盟统计 UMAppKey 启动发送
//    [MobClick startWithAppkey:UMTONGJIKEY reportPolicy:BATCH channelId:nil];
    
    //如果需要取Xcode4及以上版本的Version
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];

}
#pragma mark-------消息推送
/// 在应用启动时调用此方法
+(void)startWithLaunchOptions:(NSDictionary *)launchOptions
{
    //设置AppKey 和 launchOptions
    [UMessage startWithAppkey:UMAppKey launchOptions:launchOptions];
    //注册通知
    [UMessage registerForRemoteNotifications];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            
        } else {
            //点击不允许
        }
    }];
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        
        //如果要在iOS10显示交互式的通知，必须注意实现以下代码
        if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
            UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
            UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
            
            //UNNotificationCategoryOptionNone
            //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
            //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
            UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
            //ios 注册category
            [center setNotificationCategories:categories_ios10];
        }else
        {
            [UMessage registerForRemoteNotifications:categories];
        }
        
    }

#if DEBUG
    //for log
    [UMessage setLogEnabled:YES];
#else
     [UMessage setLogEnabled:NO];
#endif
}
+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}
/// 关闭接收消息通知
+ (void)unregisterRemoteNotifications
{
    if ([[[UIDevice currentDevice] systemVersion]intValue] < 10) {
        //(iOS10此功能存在系统bug,建议不要在iOS10使用。iOS10出现的bug会导致关闭推送后无法打开推送。)
        [UMessage unregisterForRemoteNotifications];
    }
}
/// default is YES
/// 使用友盟提供的默认提示框显示推送信息
+ (void)setAutoAlertView:(BOOL)shouldShow
{
    [UMessage setAutoAlert:shouldShow];
}
/// 应用在前台时，使用自定义的alertview弹出框显示信息
+ (void)showCustomAlertViewWithUserInfo:(NSDictionary *)userInfo
{
    [UMMethodHander shared].userInfo = userInfo;
    // 应用当前处于前台时，需要手动处理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [UMessage setAutoAlert:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送消息"message:userInfo[@"aps"][@"alert"] delegate:[UMMethodHander shared]cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alertView show];
        });  
    }  
    return;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 如果不调用此方法，统计数据会拿不到，但是如果调用此方法，会再弹一次友盟定制的alertview显示推送消息
        // 所以这里根据需要来处理是否屏掉此功能
        [UMessage sendClickReportForRemoteNotification:[UMMethodHander shared].userInfo];
    }
    return;  
}
///绑定一个或多个tag至设备
+(void)setAddTags:(id)parameter
{
    [UMessage addTag:parameter response:^(id responseObject, NSInteger remain, NSError *error)
    {
        if ([[(NSDictionary *)responseObject objectForKey:@"success"] isEqualToString:@"ok"])
        {
            NSLog(@"添加tag成功!!!");
        }
        else
        {
            NSLog(@"添加tag失败原因:%@",error);
        }
    }];
    

}
///删除设备中绑定的一个或多个tag
+(void)setRemoveTags:(id)parameter
{
    [UMessage removeTag:parameter response:^(id responseObject, NSInteger remain, NSError *error)
    {
        if ([[(NSDictionary *)responseObject objectForKey:@"success"] isEqualToString:@"ok"])
        {
            NSLog(@"删除tag成功!!!");
        }
        else
        {
            NSLog(@"删除tag失败原因:%@",error);
        }
    }];
    
    
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        //应用处于前台时的本地推送接受
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        if([response.actionIdentifier isEqualToString:@"*****你定义的action id****"])
        {
            
        }else
        {
            
        }
        
        //这个方法是用来做action的点击统计
        [UMessage sendClickReportForRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}
///根据地域推送
+(void)setLocationPush
{
//    CLLocationManager *locManager = [[CLLocationManageralloc] init];
//    locManager.delegate = self;
//    locManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locManager startUpdatingLocation];
//    locManager.distanceFilter = 1000.0f;
//    CLLocation *cllocation = [[CLLocationalloc]initWithLatitude:locManager.location.coordinate.latitudelongitude:locManager.location.coordinate.longitude];
//    [UMessagesetLocation:cllocation];
}
@end
