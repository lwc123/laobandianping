//
//  AboutUsViewController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
}

- (UIWebView *)webView{

    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.scrollView.scrollEnabled = NO;
        NSString * urlString = [NSString stringWithFormat:@"%@/BossComments/AboutUs",API_HOST_MOBILE];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

        [_webView loadRequest:request];
    }
    return _webView;
}

@end
