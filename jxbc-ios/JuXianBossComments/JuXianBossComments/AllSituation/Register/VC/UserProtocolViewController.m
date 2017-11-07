//
//  UserProtocolViewController.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/8/7.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()
@property (nonatomic,strong)UIWebView * webView;

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户协议";
    [self isShowLeftButton:YES];
    [self initSubViews];
    
}


- (void)initSubViews
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor =[UIColor lightGrayColor];
    
    NSString* path;
    path = [[NSBundle mainBundle] pathForResource:@"agree_cc_service" ofType:@"html"];
    
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
