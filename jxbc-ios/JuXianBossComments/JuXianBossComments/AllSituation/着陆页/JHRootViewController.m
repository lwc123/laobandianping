//
//  JHRootViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/8.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHRootViewController.h"

@interface JHRootViewController ()

@end 

@implementation JHRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initUI];
}

-(void)initUI{

    UIImageView * bgImageView= [[UIImageView alloc] initWithFrame:self.view.frame];
    bgImageView.image = [UIImage imageNamed:@"openone"];
    [self.view addSubview:bgImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
