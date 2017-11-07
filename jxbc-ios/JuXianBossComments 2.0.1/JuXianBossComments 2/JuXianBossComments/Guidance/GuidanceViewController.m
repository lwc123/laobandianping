//
//  GuidanceViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "GuidanceViewController.h"
#import "MacroDefinition.h"
#import "UIButton+Extension.h"
#import "BossCommentTabBarCtr.h"
#import "LoginViewController.h"
#import "LandingPageViewController.h"


#define Count 3

@interface GuidanceViewController ()<UIScrollViewDelegate>{

    UIScrollView *_scrollView;
    int _speed;
}
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation GuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMyScrollView];
    
}

- (void)setMyScrollView{

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    //设置显示的内容的大小
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * Count, SCREEN_HEIGHT);
    
    //设置是否分页
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = YES;
    
    //是的弹回
    _scrollView.bounces = NO;
    
    //是否显示滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    //设置图片
    for (int i = 0; i < Count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        NSString * imageName;
        
        imageName = [NSString stringWithFormat:@"ios_y%d",i + 1];
        imageView.image = [UIImage imageNamed:imageName];
        [_scrollView addSubview:imageView];
    }
    
    //按钮
    CGRect frame;
    if (SCREEN_HEIGHT == 568) {
        
        frame = CGRectMake(SCREEN_WIDTH*2 + (SCREEN_WIDTH -120)/2, (SCREEN_HEIGHT - 60),120, 25);
    }else if (SCREEN_HEIGHT == 667 || SCREEN_HEIGHT == 736){
        
        frame = CGRectMake(SCREEN_WIDTH*2 + (SCREEN_WIDTH -120)/2, (SCREEN_HEIGHT - 70),120, 25);
        
    }else if (SCREEN_HEIGHT == 480){
        
        frame = CGRectMake(SCREEN_WIDTH*2 + (SCREEN_WIDTH -120)/2, (SCREEN_HEIGHT - 60),120, 25);
        
    }
        
    //按钮
    UIButton * loginBtn = [UIButton buttonWithFrame:frame title:@"立即使用" fontSize:17.0 titleColor:[UIColor blackColor] imageName:nil bgImageName:nil];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 8;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    [loginBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:loginBtn];
    
    
    //pageControll
    _pageControl.numberOfPages = Count;
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    _pageControl.pageIndicatorTintColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [_pageControl addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    [self.view bringSubviewToFront:_pageControl];
    
    _speed = -1;
}

#pragma mark -- 点击立即使用跳转首页或是登录
- (void)clickBtn:(UIButton *)btn{

    //暂时先跳到首页
    LandingPageViewController * quickVC = [[LandingPageViewController alloc] init];
    
    [PublicUseMethod changeRootNavController:quickVC];
}

- (void)pageChange{
    // 当pageControl上的点改变时,根据当前选中的点 设置scrollview的偏移量
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * _pageControl.currentPage, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSLog(@"已经结束减速");
    //系统帮我们把scrollView 对象协议方法的内部
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
