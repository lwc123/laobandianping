//
//  JXGoldDescriptionVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/3/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXGoldDescriptionVC.h"

@interface JXGoldDescriptionVC ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JXGoldDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"企业金库说明";
    [self isShowLeftButton:YES];
    [self.view addSubview:self.webView];
}
- (UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _webView.scrollView.scrollEnabled = NO;
        NSString * urlString = [NSString stringWithFormat:@"%@/BossComments/GoldDescription",API_HOST_MOBILE];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        
        [_webView loadRequest:request];
        
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
