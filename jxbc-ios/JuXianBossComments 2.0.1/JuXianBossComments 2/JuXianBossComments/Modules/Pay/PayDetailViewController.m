//
//  PayDetailViewController.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/5/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "PayDetailViewController.h"

@interface PayDetailViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@end

@implementation PayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self isShowLeftButton:YES];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.backgroundColor = [UIColor whiteColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webStr]]];
    //    [_webView loadHTMLString:self.url baseURL:[NSURL URLWithString:self.url]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    

//    [self showLoadingIndicator];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [self dismissLoadingIndicator];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [PublicUseMethod showAlertView:@"网络繁忙..."];

}

- (void)leftButtonAction:(UIButton*)button
{
    NSArray *vcArray = self.navigationController.viewControllers;
    
    [self.navigationController popToViewController:vcArray[1] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
