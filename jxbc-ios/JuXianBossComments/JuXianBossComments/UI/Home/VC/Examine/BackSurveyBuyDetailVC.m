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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    _bossEntity = [UserAuthentication GetBossInformation];
    [self initUI];
}


- (void)initUI{
    
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_BoughtDetailh_Endpoint],_bossEntity.CompanyId,self.recordId];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
