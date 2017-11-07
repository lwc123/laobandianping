//
//  ReloInstructionVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/13.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ReloInstructionVC.h"

@interface ReloInstructionVC ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ReloInstructionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加授权人";
    [self isShowLeftButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self isShowLeftButton:YES];
//    [self initUI];
}


- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.scrollView.scrollEnabled = NO;
        
        NSString * urlStr = [JXApiEnvironment Page_Role_Instruction];
        NSLog(@"urlStr===%@",urlStr);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [_webView loadRequest:request];
        
    }
    return _webView;
}

- (void)initUI{

    UILabel * reloLabel = [UILabel labelWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20, 15) title:@"角色权限说明" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:1];
    [self.view addSubview:reloLabel];
    
    UILabel * managerLabel = [UILabel labelWithFrame:CGRectMake(10, CGRectGetMaxY(reloLabel.frame) + 12, SCREEN_WIDTH - 20, 40) title:@"高管：可以建档、提交评价、背景调查查询、发布职位、审核评价。" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:0];
    [self.view addSubview:managerLabel];
    
    UILabel * jiandangLabel = [UILabel labelWithFrame:CGRectMake(10, CGRectGetMaxY(managerLabel.frame) + 12, SCREEN_WIDTH - 20, 40) title:@"建档员：可以建档、提交评价、背景调查查询、发布职位。" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:0];
    [self.view addSubview:jiandangLabel];
    UILabel * adminLabel = [UILabel labelWithFrame:CGRectMake(10, CGRectGetMaxY(jiandangLabel.frame) + 12, SCREEN_WIDTH - 20, 40) title:@"管理员：可以建档、提交评价、背景调查查询、发布职位、授权管理、修改企业资料信息。" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:0];
    [self.view addSubview:adminLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
