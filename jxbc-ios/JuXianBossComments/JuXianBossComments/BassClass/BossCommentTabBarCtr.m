//
//  BossCommentTabBarCtr.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCommentTabBarCtr.h"
#import "JXBasedNavigationController.h"
//账号
#import "MineAccountViewController.h"
//工作台
#import "WorkbenchViewController.h"
#import "BossCircleViewController.h"
#import "SignOut.h"

@interface BossCommentTabBarCtr ()<UITabBarDelegate,UITabBarControllerDelegate>

@property (nonatomic,strong)CompanySummary * companySummary;

@property (nonatomic, strong) WorkbenchViewController *homeVC;

@property (nonatomic, strong) BossCircleViewController *bossCircleVC;

@property (nonatomic, strong) MineAccountViewController *accountVC;

@end

@implementation BossCommentTabBarCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tabBar.delegate = self;
    self.delegate = self;
    
    [self initSubViewControllers];
}

- (void)initSubViewControllers{
    
    self.tabBar.barTintColor = [PublicUseMethod setColor:KColor_Tabbar_BlackColor];
    
    WorkbenchViewController * homeVC = [[WorkbenchViewController alloc] init];
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"homeicon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"work"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.title = @"工作台";
    self.homeVC = homeVC;
        
    BossCircleViewController * bossCircleVC = [[BossCircleViewController alloc] init];
    bossCircleVC.tabBarItem.image = [[UIImage imageNamed:@"bossuu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bossCircleVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"boss"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bossCircleVC.title = @"老板圈";
    self.bossCircleVC = bossCircleVC;
    
    MineAccountViewController * accountVC = [[MineAccountViewController alloc] init];
    accountVC.tabBarItem.image = [[UIImage imageNamed:@"wou"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"mine"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    accountVC.title = @"我的";
    self.accountVC = accountVC;
    
    //suggestionVC,
    NSArray *controllers = @[homeVC,bossCircleVC,accountVC];
    NSMutableArray *navVCs = [NSMutableArray array];
    
    for (UIViewController *VC  in controllers) {
        JXBasedNavigationController *navVC = [[JXBasedNavigationController alloc]initWithRootViewController:VC];
        [self selectedTapTabBarItems:VC.tabBarItem];
        [self unSelectedTapTabBarItems:VC.tabBarItem];
        [navVCs addObject:navVC];
    }
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.viewControllers = navVCs;
    
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

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSLog(@"item.title==%@",item.title);
//}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    _companySummary = [UserAuthentication GetCompanySummary];

    if (viewController == [tabBarController.viewControllers objectAtIndex:1] || viewController == [tabBarController.viewControllers objectAtIndex:2]) {
        if (_companySummary.AuditStatus == 1) {
            
            if (self.alertString) {
                
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:self.alertString preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *done = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
//                
//                
//                [alert addAction:done];
//                [self presentViewController:alert animated:YES completion:^{
//                    
//                }];
                [self alertWithTitle:nil message:self.alertString cancelTitle:@"退出登录" okTitle:@"我知道了"];
            }
            
            return NO;
        }
    }
    
    return YES;
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [SignOut signOut];

    }];
    [alertController addAction:cancel];
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
