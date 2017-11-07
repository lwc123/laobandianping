//
//  ExamineBackdropVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ExamineBackdropVC.h"
#import "BuyReportVC.h"
@interface ExamineBackdropVC ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;

@end

@implementation ExamineBackdropVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self cleanCacheAndCookie];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"背景调查";
    [self isShowLeftButton:YES];
    [self initNav];
    [self initData];
    [self initUI];
}

- (void)initData{
    _bossEntity = [UserAuthentication GetBossInformation];

}

- (void)initNav{

    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 64)];
    _button.titleLabel.font = [UIFont systemFontOfSize:12];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_button setImage:[UIImage imageNamed:@"jhsousuo"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:_button];
    _button.hidden = YES;
    self.navigationItem.rightBarButtonItem = barButton;

}

- (void)initUI{

    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BackgroundSurvey_Endpoint],_bossEntity.CompanyId];
    NSLog(@"urlStr===%@",urlStr);

    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.delegate = self;

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self.view addSubview:_webView];
    
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

- (void)decode{

    BuyReportVC * bu = [[BuyReportVC alloc] init];
    [self.navigationController pushViewController:bu animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"shouldStartLoadWithRequest %@", webView.request.URL);
    [self showLoadingIndicator];
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [JsBridge initForWebView : webView with:self];
    [self dismissLoadingIndicator];
}

#pragma mark -- 搜索
- (void)rightButtonAction{
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BackgroundSearch_Endpoint],_bossEntity.CompanyId,1];
     NSLog(@"urlStr===%@",urlStr);
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

}

- (void)leftButtonAction:(UIButton *)button{
    
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)clearSelf:(NSNotification*)noti
{
    self.view = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
