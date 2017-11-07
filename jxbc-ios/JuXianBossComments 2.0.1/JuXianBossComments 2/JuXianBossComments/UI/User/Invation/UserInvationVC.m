//
//  UserInvationVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserInvationVC.h"
#import "InvitationView.h"
#import "JX_ShareManager.h"

@interface UserInvationVC ()<InvitationViewDelegate>
@property (nonatomic,strong)InvitedRegisterEntity *invitedEntity;
@property (nonatomic,strong)InvitationView * invitation;


@end

@implementation UserInvationVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"邀请注册";
    [self isShowLeftButton:YES];
    [self initShare];
    [self initUI];
}

- (void)initShare{
    
    [self showLoadingIndicator];
    [UserWorkbenchRequest getPrivatenessInviteRegisterSuccess:^(InvitedRegisterEntity *invitedEntity) {
        [self dismissLoadingIndicator];
        
        _invitedEntity = invitedEntity;
        [_invitation.codeImageView sd_setImageWithURL:[NSURL URLWithString:invitedEntity.InviteRegisterQrcode] placeholderImage:LOADing_Image];
        _invitation.moneyLabel.text = [NSString stringWithFormat:@"每邀请一位老板开户,您将获得%@元奖金(税前)",invitedEntity.InvitePremium];
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络链接超时，请稍后再试"];
        NSLog(@"%@",error);
    }];

}

- (void)initUI{

    _invitation = [InvitationView invitationView];
    _invitation.delegate = self;
    _invitation.codeImageView.image = LOADing_Image;
    _invitation.moneyLabel.text = @" 每邀请一个企业注册开户，您将获得400元奖金（代扣个税）";
    _invitation.frame = CGRectMake(0, 10, SCREEN_WIDTH, 335);
    [self.view addSubview:_invitation];
}


#pragma mark -- 分享
- (void)invitationViewClickedCodeShareBtn:(InvitationView *)jxFooterView{

    JX_ShareManager *manager = [JX_ShareManager shareManager];
    manager.curentVC = self;
    manager.invitedEntity = _invitedEntity;
    [manager isShowShareViewWithSuperView:self.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
