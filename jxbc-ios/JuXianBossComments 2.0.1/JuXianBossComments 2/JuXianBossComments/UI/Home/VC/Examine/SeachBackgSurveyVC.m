//
//  SeachBackgSurveyVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachBackgSurveyVC.h"

@interface SeachBackgSurveyVC ()<UIWebViewDelegate>

@property (nonatomic,strong)UIWebView * webView;

@end

@implementation SeachBackgSurveyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    [self initUI];
}

- (void)initUI{

    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BackgroundSurvey_Endpoint],self.companyId];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showLoadingIndicator];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [JsBridge initForWebView : webView with:self];
    [self dismissLoadingIndicator];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
