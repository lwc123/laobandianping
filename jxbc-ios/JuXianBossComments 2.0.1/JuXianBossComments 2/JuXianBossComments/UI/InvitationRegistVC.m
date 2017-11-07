//
//  InvitationRegistVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "InvitationRegistVC.h"
#import "XJHMineView.h"
#import "InvitationView.h"
#import "JX_ShareManager.h"


@interface InvitationRegistVC ()<InvitationViewDelegate,XJHMineViewDelegate>
@property (nonatomic,strong)InvitationView * invitation;
@property (nonatomic,strong)InvitedRegisterEntity *invitedEntity;
@property (nonatomic,strong)CompanyMembeEntity *bossEntity;

@end

@implementation InvitationRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请注册";
    [self isShowLeftButton:YES];
    [self initData];
    [self initRequest];
    [self initUI];
}

- (void)initData{

    _invitedEntity = [[InvitedRegisterEntity alloc] init];
    _bossEntity = [UserAuthentication GetBossInformation];
}

- (void)initRequest{

    [self showLoadingIndicator];
    MJWeakSelf
    [WorkbenchRequest getCompanyInviteRegisterCompanyId:_bossEntity.CompanyId success:^(InvitedRegisterEntity *invitedEntity) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"invitedEntity===%@",invitedEntity);
        _invitedEntity = invitedEntity;
        [_invitation.codeImageView sd_setImageWithURL:[NSURL URLWithString:invitedEntity.InviteRegisterQrcode] placeholderImage:LOADing_Image];
        _invitation.moneyLabel.text = [NSString stringWithFormat:@"每邀请一位老板开户,您将获得%@元金币",invitedEntity.InvitePremium];
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"error===%@",error);
    }];



}


-(void)initUI{

    XJHMineView * headerView = [XJHMineView jhMineView];
    headerView.y = 0;
    headerView.x = 0;
    headerView.width = SCREEN_WIDTH;
    [self.view addSubview:headerView];
    
    CompanyMembeEntity* company = [UserAuthentication GetBossInformation];
    headerView.positionLabel.text = company.RealName;

        // 获取公司信息
    [MineRequest getCompanyMineWithCompanyId:company.CompanyId success:^(CompanySummary *companySummary) {
        headerView.nameLabel.text = companySummary.CompanyName;
        // logo
        [headerView.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:companySummary.CompanyLogo] placeholderImage:[UIImage imageNamed:@"企业默认logo"]];
        
        
    } fail:^(NSError *error) {
        
        NSLog(@"#getCompanyMineWithCompanyId error===%@",error);
    }];
    
    _invitation = [InvitationView invitationView];
    _invitation.delegate = self;
    _invitation.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame) + 10, SCREEN_WIDTH, 270);
    [self.view addSubview:_invitation];
}

#pragma mark -- 企业分享
- (void)invitationViewClickedCodeShareBtn:(InvitationView *)jxFooterView{


    JX_ShareManager *manager = [JX_ShareManager shareManager];
    manager.curentVC = self;
    manager.invitedEntity = _invitedEntity;
    manager.shareTitle = [NSString stringWithFormat:@"我是泼猴科技CEO%@，现在邀请你一起使用老板点评，点评自己的员工。",_bossEntity.RealName];
    [manager isShowShareViewWithSuperView:self.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
