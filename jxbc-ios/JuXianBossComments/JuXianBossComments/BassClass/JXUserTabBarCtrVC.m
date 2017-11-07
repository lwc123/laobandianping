//
//  JXUserTabBarCtrVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXUserTabBarCtrVC.h"
#import "CompanyCircleVC.h"//公司圈
#import "UserMineVC.h"//个人信息
#import "JHTabbar.h"
#import "UserSeachCompanyVC.h"

@interface JXUserTabBarCtrVC ()

@end

@implementation JXUserTabBarCtrVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViewControllers];

}

- (void)initSubViewControllers{
    self.tabBar.barTintColor = [PublicUseMethod setColor:KColor_Tabbar_BlackColor];
    
    [self setCustomtabbar];
    
    CompanyCircleVC * companyCircle = [[CompanyCircleVC alloc] init];
    companyCircle.tabBarItem.image = [[UIImage imageNamed:@"companywordth"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    companyCircle.tabBarItem.selectedImage = [[UIImage imageNamed:@"companywordthss"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    companyCircle.title = @"公司口碑";
    
    UserMineVC * mineVC = [[UserMineVC alloc] init];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"wou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"mine"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.title = @"我的";

    NSArray *controllers = @[companyCircle,mineVC];
    NSMutableArray *navVCs = [NSMutableArray array];
    for (UIViewController *VC  in controllers) {
        JXBasedNavigationController *navVC = [[JXBasedNavigationController alloc]initWithRootViewController:VC];
        [self selectedTapTabBarItems:VC.tabBarItem];
        [self unSelectedTapTabBarItems:VC.tabBarItem];
        [navVCs addObject:navVC];
        [self addChildViewController:navVC];
    }
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
//    self.viewControllers = navVCs;
    
}


- (void)setCustomtabbar{
    
    JHTabbar *tabbar = [[JHTabbar alloc]init];
    
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [tabbar.centerBtn addTarget:self action:@selector(centerBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)centerBtnClick{

    UserSeachCompanyVC * seachVC = [[UserSeachCompanyVC alloc] init];
    JXBasedNavigationController *jjNav = [[JXBasedNavigationController alloc]initWithRootViewController:seachVC];
    [self presentViewController:jjNav animated:YES completion:nil];
}


/**
 *  设置tabbar字体
 */
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:10], UITextAttributeFont,[PublicUseMethod setColor:KColor_TabbarColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:10],
                                        UITextAttributeFont,[PublicUseMethod setColor:KColor_Text_WhiterColor],UITextAttributeTextColor,
                                        nil] forState:UIControlStateSelected];
}
//设置tabbar上第三个按钮为不可选中状态，其他的按钮为可选择状态
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return ![viewController isEqual:tabBarController.viewControllers[1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
