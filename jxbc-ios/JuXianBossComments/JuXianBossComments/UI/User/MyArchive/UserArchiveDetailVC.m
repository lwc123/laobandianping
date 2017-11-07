//
//  UserArchiveDetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserArchiveDetailVC.h"

@interface UserArchiveDetailVC ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView * webView;


@end

@implementation UserArchiveDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"档案详情";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{
    NSString * urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_UserSurveyDetail_Endpoint],_archiveId];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [JsBridge initForWebView:webView with:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
