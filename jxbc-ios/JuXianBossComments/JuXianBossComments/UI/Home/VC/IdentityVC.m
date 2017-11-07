//
//  IdentityVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "IdentityVC.h"
#import "LoginViewController.h"

@interface IdentityVC ()

@end

@implementation IdentityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择身份";

    [self initUI];
    
}

- (void)initUI{

    UIButton * companyBtn = [UIButton buttonWithFrame:CGRectMake(100, 100, 100, 20) title:@"企业用户" fontSize:14.0 titleColor:[UIColor blackColor] imageName:nil bgImageName:nil];
    [self.view addSubview:companyBtn];
    [companyBtn addTarget:self action:@selector(companyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIButton * personBtn = [UIButton buttonWithFrame:CGRectMake(100, 300, 100, 20) title:@"个人用户" fontSize:14.0 titleColor:[UIColor blackColor] imageName:nil bgImageName:nil];
    [self.view addSubview:personBtn];
    [personBtn addTarget:self action:@selector(personBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 我的是企业
- (void)companyBtnClick:(UIButton *)btn{
    LoginViewController * pageVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];
}

#pragma mark -- 我的个人
- (void)personBtnClick:(UIButton *)btn{

    LoginViewController * pageVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:pageVC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
