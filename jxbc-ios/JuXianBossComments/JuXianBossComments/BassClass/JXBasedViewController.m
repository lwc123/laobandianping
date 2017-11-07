//
//  JXBasedViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/10.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
#import <ImageIO/ImageIO.h>
@interface JXBasedViewController ()
@property (nonatomic,strong)UIView *bgView;

@property (nonatomic, assign) BOOL isFirstLoad;

@property (nonatomic, strong) UIView *reloadDataView;
@end

@implementation JXBasedViewController

- (void)dealloc{
    
    // [self dismissLoadingIndicator];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"JXBasedViewController"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self dismissLoadingIndicator];

    [MobClick endLogPageView:@"JXBasedViewController"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //注册一个清除自身的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearSelf:) name:Notification_ClearSelf object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLoad = YES;
    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    // 监听网络状态
    [self listenNetWorkStatue];
    
}

#pragma mark -  监听网络状态
- (void)listenNetWorkStatue{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                Log(@"未识别的网络");
                
            case AFNetworkReachabilityStatusNotReachable:
                Log(@"不可达的网络(未连接)");
                // 显示无网视图
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                Log(@"4g网络链接");
            case AFNetworkReachabilityStatusReachableViaWiFi:
                Log(@"wifi网络链接");
                [self loadData];

                
                break;
            default:
                break;
        }
    }];
    // 开始监听
    [manager startMonitoring];
    
}
- (void)loadData{
    [self loadPageData];
}

// 加载页面数据
- (void)loadPageData{
}

- (void)onRemoteError{

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
#pragma mak --- 返回
- (void)isShowLeftButton:(BOOL)isShow
{
    if (isShow) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonAction:)];
        
        barButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = barButton;
        
    }else{
        
//        self.navigationItem.leftBarButtonItem = nil;
        
        //xjh 11.29
        [self.navigationItem setHidesBackButton:YES];
        
    }
}

- (void)retryLoadData{


}

- (void)leftButtonAction:(UIButton *)button{

    [self.navigationController popViewControllerAnimated:YES];
}

//右侧按钮
- (void)isShowRightButton:(BOOL)isShow{
    if (isShow) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        [button setTitle:@"保存" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }

}

- (void)isShowRightButton:(BOOL)isShow withImg:(UIImage*)image{
    if (isShow) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 44)];
//        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(ImgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
    }else{}
}

- (void)isShowRightButton:(BOOL)isShow with:(NSString*)string{
    if (isShow) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
        button.contentMode = UIViewContentModeRight;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:string forState:UIControlStateNormal];
        [button setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 2;
        button.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
        [button addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
    }else{}
}

- (void)clearSelf:(NSNotification*)noti{


}

- (void)rightButtonAction:(UIButton *)button{

    

}

- (void)ImgButtonAction:(UIButton *)btn{



}


- (void)showLoadingIndicatorWithString:(NSString *)string{

    [self showLoadingIndicator];
    
    UIView* view = self.bgView.subviews.firstObject;
    UILabel* lable = [view viewWithTag:10000];
    lable.text = string;

}

- (void)showLoadingIndicator{

    [self loadAnimationView].hidden = NO;
    
    // [self.view viewWithTag:10000].hidden = YES;

}

- (void)dismissLoadingIndicator{
    
    if (self.navigationController.view == nil) {
        return;
    }
    
    //    if(_loadProgress){
    //        [self.loadProgress hide:YES];
    //    }
    
    if (_bgView) {
        [self loadAnimationView].hidden = YES;
        [[self loadAnimationView] removeFromSuperview];
        _bgView = nil;
    }
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
        
        
        
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"newloading" withExtension:@"gif"];//加载GIF图片
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

#pragma mark - 弹框

// 提示框
- (void)alertString:(NSString *)string duration:(CGFloat) duration{
    
    [self alertStringWithString:string doneButton:NO cancelButton:NO duration:duration doneClick:nil];
    
}


// 提示并显示按钮
- (void)alertStringWithString:(NSString *)string doneButton:(BOOL)isDone cancelButton:(BOOL) isCancel duration:(CGFloat) duration doneClick:(AlertDoneButtonClickBlock)alertDoneButtonClickBlock{
    
    [self alertStringWithTitle:nil String:string doneButton:isDone cancelButton:isCancel duration:duration doneClick:alertDoneButtonClickBlock];
}

- (void)alertStringWithTitle:(NSString *)title String:(NSString *)string doneButton:(BOOL)isDone cancelButton:(BOOL) isCancel duration:(CGFloat) duration doneClick:(AlertDoneButtonClickBlock)alertDoneButtonClickBlock{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
    
    if (isDone) {
        UIAlertAction* done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            alertDoneButtonClickBlock();
        }];
        
        [alert addAction:done];
    }
    
    if (isCancel) {
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:cancel];
    }
    
    MJWeakSelf
    // 没有按钮才定时
    if ((!isCancel) && (!isDone)) {
        if (duration > 0) {
            
            [UIView animateWithDuration:duration animations:^{
                if (self.navigationController) {
                    [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
                }else{
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            } completion:^(BOOL finished) {
                
                [alert dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            
        }
    }else{
        
        if (self.navigationController) {
            [weakSelf.navigationController presentViewController:alert animated:YES completion:nil];
        }else{
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
