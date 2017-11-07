//
//  BackSurveyBuyDetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BackSurveyBuyDetailVC.h"

@interface BackSurveyBuyDetailVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;

@end

@implementation BackSurveyBuyDetailVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    _bossEntity = [UserAuthentication GetBossInformation];
    [self initUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self isShowLeftButton:YES];
}

- (void)initUI{
    
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BoughtDetailh_Endpoint],_bossEntity.CompanyId,self.recordIdStr];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

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

- (void)leftButtonAction:(UIButton *)button{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    [self dismissLoadingIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
