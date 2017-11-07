//
//  FAQViewController.m
//  JuXianBossComments
//
//  Created by Jam on 17/2/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"常见问题";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
}

- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.scrollView.scrollEnabled = YES;
//        _webView.scrollView.bounces = NO;
        NSString * urlString = [NSString stringWithFormat:@"%@/BossComments/problem",API_HOST_MOBILE];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [_webView loadRequest:request];
    }
    return _webView;
}

@end
