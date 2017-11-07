//
//  LandingPageViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "LandingPageViewController.h"
#import "LoginViewController.h"
#import "MineDataRequest.h"
#import "ApplyAccountFourVC.h"

//新注册
#import "NewRegistreVC.h"
#import "UserRegisterVC.h"



@interface LandingPageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet ColorButton *loginBtn;

@property (weak, nonatomic) IBOutlet ColorButton *checkBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong)AnonymousAccount * account;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;

@end

@implementation LandingPageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

/*
- (void)jumpUI{
    //XJH 8888
    if (_account.UserProfile.AttestationStatus == AttestationStatus_None || _account.UserProfile.AttestationStatus == AttestationStatus_Rejected) {//没有提交认证 //拒绝认证
        
        ApplyAccountTwoVC * twoVC = [[ApplyAccountTwoVC alloc] init];
        [PublicUseMethod changeRootNavController:twoVC];
    }
    
    if (_account.UserProfile.AttestationStatus == AttestationStatus_Submited){//提交认证
        
//        ApplyAccountTwoVC * twoVC = [[ApplyAccountTwoVC alloc]init];
//        [self.navigationController pushViewController:twoVC animated:NO];
//        
//        ApplyAccountThreeVC * threeVC = [[ApplyAccountThreeVC alloc] init];
        ApplyAccountFourVC * fourVC = [[ApplyAccountFourVC alloc] init];
//        [self.navigationController setViewControllers:@[self,twoVC,threeVC,fourVC] animated:YES];
        [PublicUseMethod changeRootNavController:fourVC];
    }
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    
    _account = [UserAuthentication GetCurrentAccount];
    
    if (SCREEN_WIDTH == 320) {
        
        self.bgImageView.image = [UIImage imageNamed:@"ios640"];
    }
    if (SCREEN_WIDTH == 375) {
        
        self.bgImageView.image = [UIImage imageNamed:@"ios750"];
    }
    if (SCREEN_WIDTH == 621) {
        
        self.bgImageView.image = [UIImage imageNamed:@"ios1242"];
    }
    if (SCREEN_WIDTH == 516) {
        
        self.bgImageView.image = [UIImage imageNamed:@"ios1080"];
    }
    
    
    self.bgImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.bgView.frame = CGRectMake(0, ScreenHeight-140-45, ScreenWidth, 45);
    self.loginBtn.frame = CGRectMake((ScreenWidth - 220) * 0.5, 5, 100, 35);
    self.checkBtn.frame = CGRectMake(CGRectGetMaxX(self.loginBtn.frame) + 40, 5, 100, 35);
    self.userBtn.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame) + 70, SCREEN_WIDTH, 15);
    
}


#pragma mark -- 登录
- (IBAction)loginBtn:(id)sender {
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}


#pragma mark -- 企业注册
- (IBAction)OpenAccount:(id)sender {
    NewRegistreVC * registerVC = [[NewRegistreVC alloc] init];
    registerVC.SelectedProfileType = 2;
    [self.navigationController pushViewController:registerVC animated:YES];
}


#pragma mark -- 个人用户注册
- (IBAction)userRegisterClick:(id)sender {
    
    UserRegisterVC * userVC = [[UserRegisterVC alloc] init];
    userVC.SelectedProfileType = 1;
    [self.navigationController pushViewController:userVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
