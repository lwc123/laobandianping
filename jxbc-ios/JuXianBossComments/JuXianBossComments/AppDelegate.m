//
//  AppDelegate.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AppDelegate.h"
#import "BossCommentTabBarCtr.h"
#import "GuidanceViewController.h"
#import "AccountRepository.h"
#import "DictionaryRepository.h"
#import "VideoPlayerController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "MineDataRequest.h"
#import "UMessage.h"
#import "UMMethodHander.h"
#import <UserNotifications/UserNotifications.h>


//流程
#import "ChoiceCompanyVC.h"
#import "JHRootViewController.h"
#import "ChoiceIdentityVC.h"
#import "JXUserTabBarCtrVC.h"//个人


#import "ApplePayValidate.h"//SC.XJH.1.19


@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)AnonymousAccount * account;
@property (nonatomic,assign) long companyId;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMeng_APIKey];
    //推送
    //    [UMessage startWithAppkey:UMeng_APIKey launchOptions:launchOptions];
    //    [UMMethodHander startWithLaunchOptions:launchOptions];
    
    
    //友盟的推送暂时不上这个方法
    //    [self registrePushMessageWithOptions:launchOptions];
    
    //友盟统计初始化
    [self umengTrack];
    [WXApi registerApp:WX_APP_KEY withDescription:@"bosscomments1.0"];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [NSThread sleepForTimeInterval:.5];
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        [[UINavigationBar appearance] setBarTintColor:[PublicUseMethod setColor:@"49525D"]];
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    }else{
        [[UINavigationBar appearance] setTintColor:[PublicUseMethod setColor:@"49525D"]];
    }
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    [self initRootVC];
    VideoPlayerController * videoPlayerController = [[VideoPlayerController alloc]init];
    self.window.rootViewController = videoPlayerController;    
    [self.window makeKeyAndVisible];
    return YES;
}



#pragma mark -- 友盟统计
- (void)umengTrack{
    //如果需要取Xcode4及以上版本的Version
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    UMConfigInstance.appKey = UMeng_APIKey;
    UMConfigInstance.secret = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    AnonymousAccount *acc = [UserAuthentication GetCurrentAccount];
    if (acc.UserProfile.MobilePhone) {
        [MobClick profileSignInWithPUID:acc.UserProfile.MobilePhone];
    }
}

#pragma mark -- 友盟的推送 暂时没用

- (void)registrePushMessageWithOptions:(NSDictionary *)launchOptions{
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
            [UMessage registerForRemoteNotifications];
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
            UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
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


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)initRootVC{
    
    [ApplePayValidate validateApplePay];
    
    NSString * companyStr = [[NSUserDefaults standardUserDefaults] valueForKey:CompanyChoiceKey];
    _companyId = [companyStr longLongValue];
    //第一次启动应用
    AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [self loadAllDictionaryloadAllDictionary];
        //判断是否登陆//1.调用:开机启动,传递设备参数
        [AccountRepository createNew:^(AccountSignResult *result) {
        } fail:^(NSError *error) {
            [self createNewFail:error];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //需要登陆==>进入导航界面
        GuidanceViewController * guidanceVC = [[GuidanceViewController alloc] init];
        self.window.rootViewController = guidanceVC;
        
    }else{
        NSString * AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
        // 加载动画
        if(AccessToken==nil){
            [AccountRepository createNew:^(AccountSignResult *result) {
                
            } fail:^(NSError *error) {
                [self createNewFail:error];
            }];
            LoginViewController * landPageVC = [[LoginViewController alloc] init];
            [PublicUseMethod changeRootNavController:landPageVC];
        }
        
        [self loadAllDictionaryloadAllDictionary];
        
        if (myaccount.PassportId > 0 && AccessToken != nil) {
            if ([myaccount.MobilePhone isEqualToString:DemoPhone]) {//是演示账号直接导登录
                [AccountRepository signOut: ^(id result) {
                    if (result) {
                        [UserAuthentication removeCurrentAccount];
                        NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
                        [current removeObjectForKey:@"currentIdentity"];
                        [current synchronize];
                        NSString * userProfilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userProfile.data"];
                        NSFileManager * userProfileFileManager = [[NSFileManager alloc]init];
                        [userProfileFileManager removeItemAtPath:userProfilePath error:nil];
                    }
                    else
                    {
                        [PublicUseMethod showAlertView:@"返回失败"];
                    }
                } fail:^(NSError *error) {
                    [PublicUseMethod showAlertView:@"返回失败"];
                }];
                LoginViewController * landPageVC = [[LoginViewController alloc] init];
                [PublicUseMethod changeRootNavController:landPageVC];
            }else{
            
                [self signInByTokenWith:myaccount];
            
            }

        }else{
            LoginViewController * landPageVC = [[LoginViewController alloc] init];
            [PublicUseMethod changeRootNavController:landPageVC];
        }
    }
}

- (void)signInByTokenWith:(AnonymousAccount *)myaccount{
    NSString * myIdentity = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentIdentity"];
    int currentIdentity = [myIdentity intValue];

    [AccountRepository signInByToken:^(id result) {
        if (_companyId > 0) {
            
            if (currentIdentity == 2) {
                [SignInMemberPublic SignInWithCompanyId:_companyId];
            }else{
                [SignInMemberPublic SignInWithCompanyId:_companyId];
            }
        }else{
            
            if (currentIdentity == 1) {
                [PublicUseMethod goViewController:[JXUserTabBarCtrVC class]];
            }else{
                [SignInMemberPublic SignInLoginWithAccount:myaccount];
            }
        }
    } fail:^(NSError *error) {
        Log(@"%@",error.localizedDescription);
        // 请求超时 提示失败 重新加载
        if (error.code == -1001) { // 请求超时
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络链接超时,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
            [alert show];
            
        }
        // 没有网络 提示失败 重新加载
        if (error.code == -1009) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络好像断开了,请检查网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
            [alert show];
            
        }
        
    }];
    JHRootViewController * rootVC = [[JHRootViewController alloc] init];
    [PublicUseMethod changeRootNavController:rootVC];

}

#pragma mark - 重新加载
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    Log(@"重新加载");
    [self initRootVC];
}

#pragma mark - 加载字典
- (void)loadAllDictionaryloadAllDictionary{
    
    [WebAPIClient getJSONWithUrl:API_Dictionary_Dictionaries parameters:nil success:^(id result) {
        
        //        Log(@"result===%@",result);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:KDicLoadSuccess object:nil];
        //SC.XJH.1.1
        AllDictionaryModel *allDictM = [[AllDictionaryModel alloc]initWithDictionary:result error:nil];
        
        [DictionaryRepository saveAllDictionaryModelWith:allDictM];
        
        Log(@"allDictM===%@",allDictM);
        
        NSArray *PeriodModelA = [DictionaryRepository getComment_PeriodModelArray];
        NSLog(@"PeriodModelA===%@",PeriodModelA);
        
        for (PeriodModel *periodModel in PeriodModelA) {
            NSLog(@"periodModel.Code===%@",periodModel.Code);
        }
        //
        
    } fail:^(NSError *error) {
        NSLog(@"Appdelegate加载失败===%@",error.localizedDescription);
    }];
    
}

#pragma mark  消息推送
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //关闭友盟自带的弹出框
    [UMMethodHander didReceiveRemoteNotification:userInfo];
    [UMMethodHander setAutoAlertView:NO];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"收到通知" object:nil userInfo:userInfo];
}

/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self applicationOpenURL:url];
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self applicationOpenURL:url];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    return [self applicationOpenURL:url];
}

- (BOOL)applicationOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        }];
        return YES;
    }else if(url.scheme && [url.scheme rangeOfString:WX_APP_KEY].location != NSNotFound
             && url.host && [url.host rangeOfString:@"pay"].location != NSNotFound){
        return [WXApi handleOpenURL:url delegate:self];
    }
    return [[UMSocialManager defaultManager] handleOpenURL:url];
    
}

- (void)onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response= (PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
            {
                self.block();
                
            }
                break;
            default:
            {
                [PublicUseMethod showAlertView:@"支付失败!"];
            }
                break;
        }
    }
}


//传递设备信息失败
-(void)createNewFail:(NSError *)error
{
    [PublicUseMethod showAlertView:@""];
}

+ (AppDelegate *)currentAppDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
