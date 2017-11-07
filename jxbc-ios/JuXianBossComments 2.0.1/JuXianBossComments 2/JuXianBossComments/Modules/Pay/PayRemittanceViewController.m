//
//  PayRemittanceViewController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "PayRemittanceViewController.h"

@interface PayRemittanceViewController ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PayRemittanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支付";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
}

- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.scrollEnabled = NO;
        NSString * urlString = [NSString stringWithFormat:@"%@/BossComments/companyTransfer",API_HOST_MOBILE];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

        [_webView loadRequest:request];
        
    }
    return _webView;
}



@end
