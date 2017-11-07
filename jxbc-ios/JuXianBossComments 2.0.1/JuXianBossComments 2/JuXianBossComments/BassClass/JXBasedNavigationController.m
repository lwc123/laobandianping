//
//  JXBasedNavigationController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedNavigationController.h"

@interface JXBasedNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation JXBasedNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //设置导航栏的字体的颜色为白色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
    // 使导航条有效
    [self setNavigationBarHidden:NO];
    
    // 隐藏导航条，但由于导航条有效，系统的返回按钮页有效，所以可以使用系统的右滑返回手势。
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark -- 是否右滑返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.viewControllers.count > 1) {
        return YES;
    }else{
        
        return NO;
    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.navigationBar.hidden == YES) {
//        //        如果导航栏隐藏 返回
//        return;
//    }
    // 只在主界面显示tabBarController
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
