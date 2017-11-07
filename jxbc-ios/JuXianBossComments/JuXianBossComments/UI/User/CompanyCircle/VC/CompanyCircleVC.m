//
//  CompanyCircleVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyCircleVC.h"
#import "JHItemsView.h"
#import "messageButton.h"
#import "JXBaseSrollView.h"
#import "ConsoleEntity.h"
@interface CompanyCircleVC ()<JHItemsViewDelegate,UIScrollViewDelegate>{

    JXBaseSrollView *_scrollView;
    //选中时的下划线
    UIView *_underLine;
    //记录选中的button的TAG值
    NSInteger _index;


}
@property (nonatomic, strong) messageButton *showRedBtn;
@property (nonatomic, strong) messageButton *redBtn;
@property (nonatomic,strong)UIViewController *currentVC;

@end

@implementation CompanyCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公司圈";
    
    [self addChoiceItems];
    [self initTotal];//请求统计和红点
    [self initUI];
    
}
- (void)initTotal{
    [self showLoadingIndicator];
    MJWeakSelf
    [UserOpinionRequest getConsoleIndexSuccess:^(ConsoleEntity *consoleEntity) {
        [weakSelf dismissLoadingIndicator];

        weakSelf.redBtn = [self.view viewWithTag:11];
        
        weakSelf.attentionVC.consoleEntity = consoleEntity;
        if (consoleEntity.IsRedDot) {
            weakSelf.redBtn.showRedPoint = YES;
        }else{
            weakSelf.redBtn.showRedPoint = NO;;
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}

-(void)initUI{

    self.companylistVC = [[CompanyListVC alloc] init];
    self.attentionVC = [[CompanyAttentionVC alloc] init];
    self.companylistVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
    [self addChildViewController:self.companylistVC];
    
    
    _scrollView= [[JXBaseSrollView alloc]initWithFrame:CGRectMake(0,36, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 36)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*2, SCREEN_HEIGHT-100);
    [_scrollView addSubview:self.companylistVC.view];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
    JHItemsView * itemsView = [[JHItemsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    _showRedBtn = [itemsView viewWithTag:11];
    itemsView.delegate = self;
//    [self.view addSubview:itemsView];
    

}

//添加选项栏
- (void)addChoiceItems
{
    NSArray *titleArray = @[@"所有公司",@"关注"];
    
    float width = SCREEN_WIDTH/2;
    for (int i = 0; i < titleArray.count; i ++) {
        messageButton *button = [[messageButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 36)];
        button.tag = 10+i;
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.showRedPoint = NO;

        if (button.tag ==10) {
            button.showRedPoint = NO;
            [button setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
            _index = 10;
        }
        [self.view addSubview:button];
        
    }
    _underLine = [[UIView alloc]initWithFrame:CGRectMake(0, 33, width, 3)];
    _underLine.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
    [self.view addSubview:_underLine];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, 7, 0.5, 22)];
    lineView.backgroundColor =[PublicUseMethod setColor:KColor_Text_EumeColor];
    [self.view addSubview:lineView];
    
}

- (void)selectAction:(messageButton *)button{

    UIButton *button1 = (UIButton*)[self.view viewWithTag:_index];
    
    //变黑色
    [button1 setTitleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] forState:UIControlStateNormal];
    //变红色
    [button setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
    
    _index = button.tag;
    
    [UIView animateWithDuration:.35 animations:^{
        _underLine.x = (SCREEN_WIDTH/2)*(_index -10);
        CGPoint point = CGPointMake((_index-10)*SCREEN_WIDTH, 0);
        _scrollView.contentOffset = point;
    }];
    if (button.tag == 10) {//待处理
        [self replaceController:self.currentVC newController:self.companylistVC index:button.tag];
    }
    if (button.tag == 11) {//通知
        [self replaceController:self.currentVC newController:self.attentionVC index:button.tag];
    }
}

- (void)jhItemsViewDelegateWithButton:(messageButton *)button ItemsView:(JHItemsView *)itemsView{

    if (button.tag == 10) {
        
        [self replaceController:self.currentVC newController:self.companylistVC index:button.tag];
    }else{
        [self replaceController:self.currentVC newController:self.attentionVC index:button.tag];
    }
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController index:(NSInteger)index
{
    
    if (oldController == newController) {
        return;
    }
    
    [self addChildViewController:newController];
    newController.view.frame = CGRectMake((SCREEN_WIDTH)*(index -10), 0, SCREEN_WIDTH, SCREEN_HEIGHT-100);
    [_scrollView addSubview:newController.view];
    [newController didMoveToParentViewController:self];
    [oldController willMoveToParentViewController:nil];
    [oldController removeFromParentViewController];
    [oldController.view removeFromSuperview];
    
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger selectIndex = scrollView.contentOffset.x /ScreenWidth;
    messageButton *button3 = (messageButton*)[self.view viewWithTag:selectIndex+10];
    
    
    [self selectAction:button3];
    
    [UIView animateWithDuration:.35 animations:^{
        
        messageButton *button1 = (messageButton*)[self.view viewWithTag:_index];
        
        [button1 setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        
        messageButton *button2 = (messageButton*)[self.view viewWithTag:selectIndex+10];
        [button2 setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
        
        
        _index = selectIndex + 10;
        
        [self selectAction:button2];
        _underLine.x = (SCREEN_WIDTH/2)*(_index -10);
    }];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x >ScreenWidth*2) {
        scrollView.scrollEnabled = NO;
    }
    else
    {
        scrollView.scrollEnabled = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
