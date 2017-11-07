//
//  UserAddCommentVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserAddCommentVC.h"

@interface UserAddCommentVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;

@end

@implementation UserAddCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{

    [self.view addSubview:self.webView];
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_CreateOpinion_Endpoint],1];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showLoadingIndicator];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissLoadingIndicator];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [JsBridge initForWebView:webView with:self];
    
}


- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        _webView.scrollView.showsVerticalScrollIndicator = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.delegate = self;
    }
    return _webView;
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
