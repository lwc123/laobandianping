//
//  StartViewController.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/9/15.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "StartViewController.h"
#import "LoginViewController.h"
#import "PublicUseMethod.h"

//#import "UMSocial.h"

//#import "UMSocialSnsService.h"
//#import "UMSocialSnsPlatformManager.h"
//#import "UMSocialDataService.h"
//#import "IQKeyboardReturnKeyHandler.h"
#import "StartViewController.h"
#import "AccountRepository.h"
//#import "MainViewController.h"
//#import "UMSocialQQHandler.h"
//#import "UMSocialWechatHandler.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登录注册";
    
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 10;
    self.registerBtn.backgroundColor = [PublicUseMethod setColor:@"E53737"];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 10;
    self.loginBtn.layer.borderWidth = 1.0f;
    self.loginBtn.layer.borderColor = [[PublicUseMethod setColor:@"E53737"] CGColor];
}
- (IBAction)registerBtn:(id)sender
{

}
- (IBAction)loginBtn:(id)sender
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
#pragma mark--------第三方登陆按钮
//微信
- (IBAction)weixin_Btn:(id)sender
{
    //[JXThirdLoginManger startLoginForWechat:self];
}
//新浪 微博登陆
- (IBAction)weibo_Btn:(id)sender
{
//    [JXThirdLoginManger startLoginForSina:self];
}
//QQ
- (IBAction)QQ_Btn:(id)sender
{
//    [JXThirdLoginManger startLoginForQQ:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
