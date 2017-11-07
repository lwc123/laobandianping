//
//  bossCommentsProtocolVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "bossCommentsProtocolVC.h"
#import "NewRegistreVC.h"

@interface bossCommentsProtocolVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;
@end

@implementation bossCommentsProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{
    
    NSString * urlString;
    if ([self.secondVC isKindOfClass:[NewRegistreVC class]]) {
        
        urlString = [NSString stringWithFormat:@"%@/BossComments/CompanyAgreement",API_HOST_MOBILE];
    }else{
        urlString = [NSString stringWithFormat:@"%@/BossComments/UserAgreement",API_HOST_MOBILE];
    }
    
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    _webView.delegate = self;
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [self.view addSubview:_webView];
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showLoadingIndicator];
    return YES;
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
