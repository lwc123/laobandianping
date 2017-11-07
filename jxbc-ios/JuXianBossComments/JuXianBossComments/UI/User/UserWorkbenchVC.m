//
//  UserWorkbenchVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserWorkbenchVC.h"
#import "UserInvationVC.h"
#import "MyArchiveList.h"
#import "UserMessageVC.h"
#import "AskforJobVC.h"
#import "UserNoBindIDCardVC.h"
#import "SubAddCardVC.h"
#import "JXGetMoneyVC.h"
#import "SetingVC.h"

@interface UserWorkbenchVC ()
@property (nonatomic,strong)WorkbentchView * bentchView;
@property (nonatomic,strong)WorkbentchView * twoBentchView;

@property (nonatomic,strong)PrivatenessSummaryEntity * userSummaryEntity;
//WalletEntity
@property (nonatomic,strong)WalletEntity * walletEntity;


@end

@implementation UserWorkbenchVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [self initRequest];
    [self initUserWallet];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"老板点评";
    [self isShowLeftButton:NO];
    [self initData];
    [self initUI];
    
}

- (void)initData{

    _userSummaryEntity = [[PrivatenessSummaryEntity alloc] init];
    _walletEntity  = [[WalletEntity alloc] init];
}
- (void)initRequest{

    [UserWorkbenchRequest getPrivatenessSummaryWithSuccess:^(PrivatenessSummaryEntity *summaryEntity) {
        _userSummaryEntity = summaryEntity;
        
        [UserAuthentication saveUserContract:summaryEntity.PrivatenessServiceContract];        
        if (summaryEntity.UnreadMessageNum > 0) {
            
            _twoBentchView.userUnRead.text = [NSString stringWithFormat:@"%ld",summaryEntity.UnreadMessageNum];            
        }else{
            _twoBentchView.userUnRead.hidden = YES;
        }
    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}

- (void)initUI{

    CGFloat benchH = 97;
    _bentchView = [WorkbentchView workbentchView];
    _bentchView.frame = CGRectMake(0,10, SCREEN_WIDTH, benchH);
    _bentchView.recodeImageView.image = [UIImage imageNamed:@"myarchive"];
    _bentchView.commentImageView.image = [UIImage imageNamed:@"askfor"];
    _bentchView.liZhiImageView.image = [UIImage imageNamed:@"mouth"];
    _bentchView.recodeLabel.text = @"我的档案";
    _bentchView.commentLabel.text = @"求职";
    _bentchView.liZhiLabel.text = @"口袋";
    [_bentchView.oneBtn addTarget:self action:@selector(myArchiveClick) forControlEvents:UIControlEventTouchUpInside];
    [_bentchView.twoBtn addTarget:self action:@selector(askJobClick) forControlEvents:UIControlEventTouchUpInside];
    [_bentchView.threeBtn addTarget:self action:@selector(userWalletClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bentchView];
    _twoBentchView = [WorkbentchView workbentchView];
    _twoBentchView.frame = CGRectMake(0, CGRectGetMaxY(_bentchView.frame), SCREEN_WIDTH, benchH);
    _twoBentchView.recodeLabel.text = @"邀请企业注册";
    _twoBentchView.commentLabel.text = @"消息";
    _twoBentchView.userUnRead.hidden = NO;
    _twoBentchView.liZhiLabel.text = @"设置";
    _twoBentchView.recodeImageView.image = [UIImage imageNamed:@"yaoqingboss"];
    _twoBentchView.commentImageView.image = [UIImage imageNamed:@"xiaoxi"];
    _twoBentchView.liZhiImageView.image = [UIImage imageNamed:@"settimg"];
    _twoBentchView.youJiangImageView.hidden = NO;
    [_twoBentchView.oneBtn addTarget:self action:@selector(invitationClick) forControlEvents:UIControlEventTouchUpInside];
    [_twoBentchView.twoBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [_twoBentchView.threeBtn addTarget:self action:@selector(settinglick) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_twoBentchView];

}

- (void)initUserWallet{

    [UserWorkbenchRequest getPrivatenessWalletWalletSuccess:^(WalletEntity *walletEntity) {
        _walletEntity = walletEntity;
        
    } fail:^(NSError *error) {

        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

#pragma mark -- 我的档案
- (void)myArchiveClick{

    if (_userSummaryEntity.PrivatenessServiceContract.IDCard == nil) {//如果还没有合同就先进入没有绑定的界面
        UserNoBindIDCardVC * userNoIdVC = [[UserNoBindIDCardVC alloc] init];
        [self.navigationController pushViewController:userNoIdVC animated:YES];
    }else{
        MyArchiveList * listVC = [[MyArchiveList alloc] init];
        [self.navigationController pushViewController:listVC animated:YES];
    }
    
}
#pragma mark -- 求职
- (void)askJobClick{
    
    AskforJobVC * askforVC = [[AskforJobVC alloc] init];
    [self.navigationController pushViewController:askforVC animated:YES];
}

#pragma mark -- 口袋
- (void)userWalletClick{
    
    if (_userSummaryEntity.ExistBankCard) {//如果有银行卡
        SubAddCardVC *cardVC = [[SubAddCardVC alloc]init];
         cardVC.title = @"口袋";
        cardVC.hidesBottomBarWhenPushed= YES;
        cardVC.userSummary = _userSummaryEntity;
        cardVC.walletEntity = _walletEntity;
        cardVC.secondVC = self;
        [self.navigationController pushViewController:cardVC animated:YES];
    }else{
    
        JXGetMoneyVC *moneyVC = [[JXGetMoneyVC alloc]init];
        moneyVC.userSummary = _userSummaryEntity;
        moneyVC.title = @"口袋";
        moneyVC.secondVC = self;
        moneyVC.walletEntity = _walletEntity;
        moneyVC.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:moneyVC animated:YES];
    }
}
#pragma mark --邀请
- (void)invitationClick{    
    UserInvationVC * invationVC = [[UserInvationVC alloc] init];
    [self.navigationController pushViewController:invationVC animated:YES];
}
#pragma mark --消息
- (void)messageClick{

    UserMessageVC * messageVC = [[UserMessageVC alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];
}
#pragma mark --设置
- (void)settinglick{
    SetingVC * setVC = [[SetingVC alloc] init];
    setVC.summaryEntity = self.userSummaryEntity;
    [self.navigationController pushViewController:setVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
