//
//  ExamineBackdropVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ExamineBackdropVC.h"
#import "BuyReportVC.h"
#import "SearchWebViewVC.h"
@interface ExamineBackdropVC ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;

@end

@implementation ExamineBackdropVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self cleanCacheAndCookie];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    _bossEntity = [UserAuthentication GetBossInformation];
    [self initUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"背景调查";
    [self isShowLeftButton:YES];
    _bossEntity = [UserAuthentication GetBossInformation];
    [self initUI];
    [self initNav];
}

// 右上角的搜索按钮
- (void)initNav{

    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 64)];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"jhsousuo"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:_button];
    _button.hidden = YES;
    self.navigationItem.rightBarButtonItem = barButton;
    [self showLoadingIndicator];
}

- (void)initUI{

    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BackgroundSurvey_Endpoint],_bossEntity.CompanyId,1,30];
    NSLog(@"urlStr===%@",urlStr);
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;
    [self.webView goBack];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
}

/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self dismissLoadingIndicator];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [JsBridge initForWebView : webView with:self];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //[self dismissLoadingIndicator];
    [JsBridge initForWebView : webView with:self];
    
    if (_webView.canGoBack) {
        // 背调详情页时隐藏搜索按钮
        self.button.hidden = YES;
    }else{
        self.button.hidden = NO;
    }

}

#pragma mark -- 搜索
- (void)rightButtonAction{
//    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BackgroundSearch_Endpoint],_bossEntity.CompanyId,1];
//     NSLog(@"urlStr===%@",urlStr);
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    SearchWebViewVC * searchVC = [[SearchWebViewVC alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    [self dismissLoadingIndicator];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}




- (void)clearSelf:(NSNotification*)noti
{
    self.view = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
