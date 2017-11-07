//
//  paySucessVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "paySucessVC.h"
#import "ProveOneViewController.h"
#import "UserOpenVipVC.h"
#import "MyArchiveList.h"
#import "OpenCommentVC.h"
#import "AppleOpenServiceVC.h"
#import "JXOpenServiceWebVC.h"

@interface paySucessVC ()<JXFooterViewDelegate>

@end

@implementation paySucessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self isShowLeftButton:NO];
    [self initUI];
    
}

- (void)initUI{
    CGFloat iconW = 65;

    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - iconW) * 0.5, 40, iconW, iconW)];
    iconImageView.image = [UIImage imageNamed:@"paysuccessicon"];
    [self.view addSubview:iconImageView];
    
    UILabel * showLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + 20, SCREEN_WIDTH, 15) title:@"支付成功" titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:15.0 numberOfLines:1];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showLabel];
    
    
    UILabel * nextLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(showLabel.frame) + 5, SCREEN_WIDTH, 15) title:@"2秒后自动跳转" titleColor:[PublicUseMethod setColor:KColor_Text_ListColor] fontSize:12.0 numberOfLines:1];
    nextLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nextLabel];

    

    JXFooterView * footer = [JXFooterView footerView];
    footer.y = CGRectGetMaxY(nextLabel.frame) + 10;
    footer.x = (SCREEN_WIDTH - 320) * 0.5;
    footer.nextLabel.text = @"完成企业认证";
    footer.nextLabel.font = [UIFont systemFontOfSize:15];
    footer.delegate = self;
    
//    [self.view addSubview:footer];
//        支付成功3s跳到企业认证
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.secondVC isKindOfClass:[UserOpenVipVC class]]) {//个人开户成功之后跳到个人档案列表
                MyArchiveList * listVC = [[MyArchiveList alloc] init];
                [listVC.jxTableView.mj_header beginRefreshing];
                [self.navigationController pushViewController:listVC animated:YES];
            }else if ([self.secondVC isKindOfClass:[OpenCommentVC class]] || [self.secondVC isKindOfClass:[AppleOpenServiceVC class]]){//开户
                ProveOneViewController * oneVC = [[ProveOneViewController alloc]init];
                [PublicUseMethod changeRootNavController:oneVC];
            }else if ([self.secondVC isKindOfClass:[JXOpenServiceWebVC class ]]){//续费
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }
        });
}

#pragma mark -- 企业认证
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    ProveOneViewController * oneVC = [[ProveOneViewController alloc]init];
    [self.navigationController pushViewController:oneVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
