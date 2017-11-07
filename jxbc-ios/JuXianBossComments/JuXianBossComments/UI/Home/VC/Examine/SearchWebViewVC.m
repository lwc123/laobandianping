//
//  SearchWebViewVC.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "SearchWebViewVC.h"

@interface SearchWebViewVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@end

@implementation SearchWebViewVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"背景调查";
    [self isShowLeftButton:YES];
    _bossEntity = [UserAuthentication GetBossInformation];
    [self initUI];
}

- (void)initUI{
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BackgroundSearch_Endpoint],_bossEntity.CompanyId,1];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;
    [self.webView goBack];
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [JsBridge initForWebView : webView with:self];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [JsBridge initForWebView : webView with:self];
    
}
- (void)leftButtonAction:(UIButton *)button{
    [self dismissLoadingIndicator];
    if (_webView.canGoBack) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_webView.canGoBack) {
        if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
