//
//  JXOpenServiceWebVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/3/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXOpenServiceWebVC.h"

@interface JXOpenServiceWebVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation JXOpenServiceWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{

    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_RenewalEnterpriseService_Endpoint],self.companyId,@"ios",app_Version];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;
    [self.webView goBack];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

}

- (void)leftButtonAction:(UIButton *)button{
    [self cleanCacheAndCookie];
    [self.navigationController popViewControllerAnimated:YES];
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
    [self showLoadingIndicator];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [JsBridge initForWebView:webView with:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissLoadingIndicator];
    [JsBridge initForWebView:webView with:self];
    
}
- (void)clearSelf:(NSNotification*)noti
{
    self.view = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
