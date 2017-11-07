//
//  ApplyAccountFourVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ApplyAccountFourVC.h"
#import "MineDataRequest.h"
#import "BossCommentTabBarCtr.h"
#import "ContactUsViewController.h"

@interface ApplyAccountFourVC ()<JXFooterViewDelegate>

@property (nonatomic, strong) UIButton *contactUsButton;

@end

@implementation ApplyAccountFourVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    [self initUI];
}

- (void)initNavView{
    self.title = @"企业认证";
    [self isShowLeftButton:NO];
}

- (void)initUI{
    JXBecomeHunterView * headerView = [JXBecomeHunterView becomeHunterView];
    headerView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 50);
    [self.view addSubview:headerView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) * 0.5, CGRectGetMaxY(headerView.frame) + 20, 100, 100)];
    imageView.image = [UIImage imageNamed:@"luch"];
    [self.view addSubview:imageView];
    
    UILabel * showLabel = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH - 200) * 0.5, CGRectGetMaxY(imageView.frame) + 20, 200, 35) title:@"您的开户申请已经成功提交，24小时内会短信通知您审核的结果" titleColor:[PublicUseMethod setColor:KColor_Text_ListColor] fontSize:12.0 numberOfLines:2];
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showLabel];
    
    // 联系我们按钮
    [self.view addSubview:self.contactUsButton];
    self.contactUsButton.y = CGRectGetMaxY(showLabel.frame) - 10;
    self.contactUsButton.x = showLabel.x;
    
    JXFooterView * footer = [JXFooterView footerView];
    footer.y = CGRectGetMaxY(showLabel.frame) + 30;
    footer.x = (SCREEN_WIDTH - 320) * 0.5;
    footer.nextLabel.text = @"进入工作台";
    footer.nextLabel.font = [UIFont systemFontOfSize:15];
    footer.delegate = self;
    [self.view addSubview:footer];
}

#pragma mark-- 进入工作台
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
}

- (void)contactUsButtonClick:(UIButton*)sender{
    
    ContactUsViewController* contactVc = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:contactVc animated:YES];
    
}

- (UIButton *)contactUsButton{
    
    if (_contactUsButton == nil) {
        _contactUsButton = [[UIButton alloc] init];
        [_contactUsButton setTitle:@"如需帮助，请联系我们" forState:UIControlStateNormal];
        [_contactUsButton setTitleColor:ColorWithHex(@"64A9FE") forState:UIControlStateNormal];
        _contactUsButton.height = 15;
        [_contactUsButton sizeToFit];
        
        _contactUsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _contactUsButton.titleLabel.x = 0;
        _contactUsButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_contactUsButton addTarget:self action:@selector(contactUsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _contactUsButton;
}



@end
