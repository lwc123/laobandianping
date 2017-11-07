//
//  JobdetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 17/1/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobdetailVC.h"

@interface JobdetailVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JobdetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位详情";
    [self isShowLeftButton:YES];
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];

        _webView.delegate = self;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_getJobQuery_detailHtml(self.companyId,self.jobId)]];
        _webView.scrollView.bounces = YES;
        [_webView loadRequest:request];
    }
    return _webView;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self showLoadingIndicator];
    [JsBridge initForWebView:webView with:self];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissLoadingIndicator];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
