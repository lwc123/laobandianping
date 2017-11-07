//
//  VideoPlayerController.m
//  JuXianBossComments
//
//  Created by Jam on 17/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "VideoPlayerController.h"

#import "BossCommentTabBarCtr.h"
#import "GuidanceViewController.h"
#import "AccountRepository.h"
#import "DictionaryRepository.h"
#import "VideoPlayerController.h"
//申请开户第一步（注册）
//#import "OpenAccountVC.h"
//着陆页
#import "LandingPageViewController.h"
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
#import "UserWorkbenchVC.h"//个人
#import "ApplePayValidate.h"//SC.XJH.1.19
#import <ImageIO/ImageIO.h>


@interface VideoPlayerController ()<UIAlertViewDelegate>

/** 播放开始之前的图片 */

//@property (nonatomic , strong)UIImageView *startPlayerImageView;

/** 播放中断时的图片 */

//@property (nonatomic , strong)UIImageView *pausePlayerImageView;

/** 定时器 */

//@property (nonatomic , strong)NSTimer *timer;

@property (nonatomic,assign) long companyId;
@property (nonatomic,strong)UIView *bgView;


@end

@implementation VideoPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self setupView];
    [self addNotification];
    
    [self prepareMovie];
}

- (void)setupView {
    
}

#pragma mark - 准备视频
- (void)prepareMovie {
    
    //首次运行
    
    NSString *filePath = nil;
    
    if ([self isFirstLauchApp]) {
        // 第一次启动
        filePath = [[NSBundle mainBundle] pathForResource:@"长视频.mp4" ofType:nil];

    }else{
    
        // 每次启动
        filePath = [[NSBundle mainBundle] pathForResource:@"短视频.mp4" ofType:nil];

    }
    
    if (filePath) {
        //初始化player
        
        self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
        
        self.showsPlaybackControls = NO;
        
        //播放视频
        
        [self.player play];
        
    }else{
        
        [self enterMain];
    }
    
}

#pragma mark - 监听
- (void)addNotification {
    
    //进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillEnterForeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //视频播放结束

//    if (![self isFirstLauchApp]) {
    
        //第二次进入app视频需要直接结束
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//视频播放结束
        
//    }else {
        
        //第一次进入app视频需要轮播
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackAgain) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//视频播放结束
//        
//    }
    
}


- (void)viewWillEnterForeground
{
    
    NSLog(@"app enter foreground");
    
    if (!self.player) {
        
        [self prepareMovie];
        
    }
    //播放视频
    [self.player play];
}

- (void)moviePlaybackAgain {
    
    //第二次进入app视频需要直接结束
    //发送推送之后就删除  否则 界面显示有问题
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name: AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackComplete) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];//视频播放结束
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"two.mp4" ofType:nil];
    
    //初始化player
    
    self.player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
    
    self.showsPlaybackControls = NO;
    
    //播放视频
    
    [self.player play];
    
}



#pragma mark - 播放完成
- (void)moviePlaybackComplete {
    
    //发送推送之后就删除  否则 界面显示有问题
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name: AVPlayerItemDidPlayToEndTimeNotification object:nil];
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"openone"];
//    [self.view addSubview:bgImageView];
    [self enterMain];
    
}
//进入主界面

- (void)enterMain {
    
    //启动掉这个的时候崩溃
    [ApplePayValidate validateApplePay];
    
    
    NSString * companyStr = [[NSUserDefaults standardUserDefaults] valueForKey:CompanyChoiceKey];
    _companyId = [companyStr longLongValue];
    //第一次启动应用
    AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
    
    if([self isFirstLauchApp])
    {
        [self loadAllDictionaryloadAllDictionary];
        //判断是否登陆//1.调用:开机启动,传递设备参数
       
        MJWeakSelf
        [self showLoadingIndicator];
        [AccountRepository createNew:^(AccountSignResult *result) {
            [weakSelf dismissLoadingIndicator];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
            //需要登陆==>进入导航界面
            LandingPageViewController * landPageVC = [[LandingPageViewController alloc] init];
            [PublicUseMethod changeRootNavController:landPageVC];
            
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            [self createNewFail:error];
        }];
        
        
    }else{
        NSString * AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
        // 加载动画
        if(AccessToken==nil){
            [AccountRepository createNew:^(AccountSignResult *result) {
                
                LandingPageViewController * landPageVC = [[LandingPageViewController alloc] init];
                [PublicUseMethod changeRootNavController:landPageVC];

                
            } fail:^(NSError *error) {
                [self createNewFail:error];
            }];
            
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
                    LandingPageViewController * landPageVC = [[LandingPageViewController alloc] init];
                    [PublicUseMethod changeRootNavController:landPageVC];
                } fail:^(NSError *error) {
                    [self createNewFail:error];

                }];
                
            }else{
                
                [self signInByTokenWith:myaccount];
                
            }
            
        }else{
            LandingPageViewController * landPageVC = [[LandingPageViewController alloc] init];
            [PublicUseMethod changeRootNavController:landPageVC];
            
        }
        
    }
    
}

//传递设备信息失败
-(void)createNewFail:(NSError *)error
{
    // 请求超时 提示失败 重新加载
    if (error.code == -1001) { // 请求超时
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络链接超时,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        
    }else if (error.code == -1009) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络好像断开了,请检查网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
    }
    
}

- (void)signInByTokenWith:(AnonymousAccount *)myaccount{
    NSString * myIdentity = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentIdentity"];
    
    int currentIdentity = [myIdentity intValue];
    
    [AccountRepository signInByToken:^(id result) {
        
        if ([self isUserProfile]) {
            
            UserWorkbenchVC * userVC = [[UserWorkbenchVC alloc] init];
            [PublicUseMethod changeRootNavController:userVC];
        }else{
            if (_companyId > 0) {
                [SignInMemberPublic SignInWithCompanyId:_companyId];
//                if (currentIdentity == 2) {
//                    [SignInMemberPublic SignInWithCompanyId:_companyId];
//                }else{
//                    [SignInMemberPublic SignInWithCompanyId:_companyId];
//                }
            }else{
                
                if (currentIdentity == 1) {
                    UserWorkbenchVC * userVC = [[UserWorkbenchVC alloc] init];
                    [PublicUseMethod changeRootNavController:userVC];
                }else{
                    [SignInMemberPublic SignInLoginWithAccount:myaccount];
                    
                }
            }
        }
        
    } fail:^(NSError *error) {
        [self createNewFail:error];
    }];
    
}

#pragma mark - 当前是猎人还是用户端
- (BOOL)isUserProfile
{
    
    AnonymousAccount *anonymousAccount = [UserAuthentication GetCurrentAccount];

    if (anonymousAccount.UserProfile.CurrentProfileType == UserProfile) {
        //个人
        return YES;
    }else
    {  //是用户
        return NO;
    }
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
        Log(@"PeriodModelA===%@",PeriodModelA);
        
        for (PeriodModel *periodModel in PeriodModelA) {
            Log(@"periodModel.Code===%@",periodModel.Code);
        }
        //
        
    } fail:^(NSError *error) {
        
//        [self createNewFail:error];
        [PublicUseMethod showAlertView:@"字典加载失败,请退出重试"];
    }];
    
}

#pragma mark - 重新加载
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    Log(@"重新加载");
    [self enterMain];
}


- (BOOL)isFirstLauchApp {
    
    return ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"];
//    return YES;
    
}


- (void)showLoadingIndicator{
    
    [self loadAnimationView].hidden = NO;
    
}

- (UIView *)loadAnimationView{
    
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.35];
        [self.navigationController.view addSubview:_bgView];
        [self.navigationController.view bringSubviewToFront:_bgView];
        
        if (self.navigationController.viewControllers != 0) {
            
            _bgView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            
        }else{
            _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = CGPointMake(self.navigationController.view.center.x, self.navigationController.view.center.y);
        view.backgroundColor = [UIColor clearColor];
        
        //        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 76, 76)];
        //        imageView.image = [UIImage imageNamed:@"loading1"];
        //        imageView.animationImages = @[[UIImage imageNamed:@"loading1"],[UIImage imageNamed:@"loading2"],[UIImage imageNamed:@"loading3"],[UIImage imageNamed:@"loading4"]];
        //        imageView.animationDuration = .3;
        //        [imageView startAnimating];
        //
        
        
        
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"jhloading" withExtension:@"gif"];//加载GIF图片
        CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);//将GIF图片转换成对应的图片源
        size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
        NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
        for (size_t i=0; i<frameCout;i++){
            CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
            UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
            [frames addObject:imageName];//将图片加入数组中
            CGImageRelease(imageRef);
        }
        
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, 76, 76)];
        //        imageView.image = [UIImage imageNamed:@"loading1"];
        //        imageView.animationImages = @[[UIImage imageNamed:@"loading1"],[UIImage imageNamed:@"loading2"],[UIImage imageNamed:@"loading3"],[UIImage imageNamed:@"loading4"]];
        imageView.animationImages = frames;
        imageView.animationDuration = .5;
        [imageView startAnimating];
        
        
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 76, 100, 24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [PublicUseMethod setColor:KColor_SubColor];
        label.font = [UIFont systemFontOfSize:15];
        label.text = @"正在加载...";
        label.tag = 10000;
        
        
        [view addSubview:imageView];
        //        [view addSubview:label];
        [_bgView addSubview:view];
    }
    
    
    return _bgView;
}

- (void)dismissLoadingIndicator{
    if (self.navigationController.view == nil) {
        return;
    }
    if (_bgView) {
        [self loadAnimationView].hidden = YES;
        [[self loadAnimationView] removeFromSuperview];
        _bgView = nil;
    }
}


@end
