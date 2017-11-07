//
//  InvitationRegistVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "InvitationRegistVC.h"
#import "InvitationView.h"
#import "JX_ShareManager.h"


@interface InvitationRegistVC ()
@property (nonatomic,strong)InvitationView * invitation;
@property (nonatomic,strong)InvitedRegisterEntity *invitedEntity;
@property (nonatomic,strong)CompanyMembeEntity *bossEntity;


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation InvitationRegistVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
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
        _invitedEntity = invitedEntity;
        
        [self.codeImage sd_setImageWithURL:[NSURL URLWithString:invitedEntity.InviteRegisterQrcode] placeholderImage:LOADing_Image];
        self.goldLabel.text = [NSString stringWithFormat:@"3.邀请的企业成功开户公司将获得%@金币奖励",invitedEntity.InvitePremium];
        
        [_invitation.codeImageView sd_setImageWithURL:[NSURL URLWithString:invitedEntity.InviteRegisterQrcode] placeholderImage:LOADing_Image];
        _invitation.moneyLabel.text = [NSString stringWithFormat:@"每邀请一位老板开户,您将获得%@元金币",invitedEntity.InvitePremium];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
    }];
}


-(void)initUI{
    
    self.shareBtn.layer.masksToBounds = YES;
    self.shareBtn.layer.cornerRadius = 4;
    
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = self.iconImage.height * 0.5;
    self.iconImage.layer.borderWidth = 2;
    self.iconImage.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
//    self.codeImage.layer.masksToBounds = YES;
//    self.codeImage.layer.cornerRadius = 4;
//    self.codeImage.layer.borderWidth = 8;
//    self.codeImage.layer.borderColor = [PublicUseMethod setColor:KColor_Text_WhiterColor].CGColor;
    
    CompanyMembeEntity* myInfo = [UserAuthentication GetMyInformation];
    AnonymousAccount * account = [UserAuthentication GetCurrentAccount];
    CompanySummary * commpany = [UserAuthentication GetCompanySummary];
    
    self.nameLabel.text = myInfo.RealName;
    self.companyName.text = commpany.CompanyName;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:account.UserProfile.Avatar] placeholderImage:LOADing_Image];
}
- (IBAction)backButton:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -- 企业分享
- (IBAction)share:(id)sender {
    JX_ShareManager *manager = [JX_ShareManager shareManager];
    manager.curentVC = self;
    manager.invitedEntity = _invitedEntity;
    [manager isShowShareViewWithSuperView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
