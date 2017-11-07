//
//  UserMineVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserMineVC.h"
#import "JXMineModel.h"
#import "XJHMineView.h"
#import "UserInvationVC.h"
#import "UserMessageVC.h"
#import "AskforJobVC.h"
#import "SubAddCardVC.h"
#import "JXGetMoneyVC.h"
#import "UserNoBindIDCardVC.h"
#import "MyArchiveList.h"
#import "SetingVC.h"
#import "ChoiceCompanyVC.h"
#import "OpenCommentVC.h"
#import "MyCommentListVC.h"
#import "UserInformationVC.h"

@interface UserMineVC ()<XJHMineViewDelegate>

@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic, strong) XJHMineView *mineView;
@property (nonatomic,strong)PrivatenessSummaryEntity * userSummaryEntity;
@property (nonatomic,strong)WalletEntity * walletEntity;
@property (nonatomic,strong)AnonymousAccount * account;

@end

@implementation UserMineVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _account = [UserAuthentication GetCurrentAccount];
    self.mineView.nameLabel.text =_account.UserProfile.RealName;
    [self.mineView.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_account.UserProfile.Avatar] placeholderImage:UserImage];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";

    [self initRequest];
    [self initUserWallet];
    [self initUI];
    
}


- (void)initRequest{
    
    [UserWorkbenchRequest getPrivatenessSummaryWithSuccess:^(PrivatenessSummaryEntity *summaryEntity) {
        self.userSummaryEntity = summaryEntity;
        [UserAuthentication saveUserContract:summaryEntity.PrivatenessServiceContract];

    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}

- (void)initUserWallet{
    [UserWorkbenchRequest getPrivatenessWalletWalletSuccess:^(WalletEntity *walletEntity) {
        self.walletEntity = walletEntity;
        
    } fail:^(NSError *error) {
        
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}



- (void)initUI{

    self.mineView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.mineView addGestureRecognizer:tap];
    [self.view addSubview:self.mineView];
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(_mineView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 154 - 64);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.backgroundColor = [UIColor clearColor];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.scrollEnabled = YES;

}

- (XJHMineView *)mineView{
    
    if (_mineView == nil) {
        
        _mineView = [XJHMineView jhMineView];
        _mineView.width = SCREEN_WIDTH;
        _mineView.height = 154;
        _mineView.iconImageVIew.layer.masksToBounds = YES;
        _mineView.iconImageVIew.layer.cornerRadius = 65 * 0.5;
        _mineView.iconImageVIew.layer.borderWidth = 2;
        _mineView.iconImageVIew.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
        _mineView.delegate = self;
        _mineView.next.hidden = NO;

    }
    return _mineView;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groupArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    JXMineModel * model = self.groupArray[section];
    return model.cellMessage.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    JXMineModel * mindeModel = self.groupArray[indexPath.section];
    NSString * testStr = mindeModel.cellMessage[indexPath.row];
    UIImage * myImage = mindeModel.cellImage[indexPath.row];
    cell.textLabel.text = testStr;
    cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.imageView.image = myImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//我的档案
            if (self.userSummaryEntity.PrivatenessServiceContract.IDCard == nil) {//如果还没有合同就先进入没有绑定的界面
                UserNoBindIDCardVC * userNoIdVC = [[UserNoBindIDCardVC alloc] init];
                userNoIdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userNoIdVC animated:YES];
            }else{
                MyArchiveList * listVC = [[MyArchiveList alloc] init];
                listVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listVC animated:YES];
            }
        }else if (indexPath.row == 1){//我的公司
            
            if (self.userSummaryEntity.myCompanys > 0) {
                ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
                choiceVC.secondVC = self;
                [self.navigationController pushViewController:choiceVC animated:YES];
                
            }else{
                OpenCommentVC * openVC = [[OpenCommentVC alloc] init];
                openVC.isChangeCompany = YES;
                openVC.secondVC = self;
                [self.navigationController pushViewController:openVC animated:YES];
            }
        }else{//我的点评
            MyCommentListVC * commentListVC = [[MyCommentListVC alloc] init];
            commentListVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:commentListVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {//求职
            AskforJobVC * askforVC = [[AskforJobVC alloc] init];
            askforVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:askforVC animated:YES];
        }else if (indexPath.row == 1){//口袋
        
            if (self.userSummaryEntity.ExistBankCard) {//如果有银行卡
                SubAddCardVC *cardVC = [[SubAddCardVC alloc]init];
                cardVC.title = @"口袋";
                cardVC.hidesBottomBarWhenPushed= YES;
                cardVC.userSummary = self.userSummaryEntity;
                cardVC.walletEntity = self.walletEntity;
                cardVC.secondVC = self;
                [self.navigationController pushViewController:cardVC animated:YES];
            }else{
                
                JXGetMoneyVC *moneyVC = [[JXGetMoneyVC alloc]init];
                moneyVC.userSummary = self.userSummaryEntity;
                moneyVC.title = @"口袋";
                moneyVC.secondVC = self;
                moneyVC.walletEntity = self.walletEntity;
                moneyVC.hidesBottomBarWhenPushed= YES;
                [self.navigationController pushViewController:moneyVC animated:YES];
            }
            
        }else{//消息
            UserMessageVC * messageVC = [[UserMessageVC alloc] init];
            messageVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
    
    }else{
        if (indexPath.row == 0) {//邀请注册
            UserInvationVC * invationVC = [[UserInvationVC alloc] init];
            invationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:invationVC animated:YES];
        
        }else{//设置
            SetingVC * setVC = [[SetingVC alloc] init];
            setVC.summaryEntity = self.userSummaryEntity;
            setVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:setVC animated:YES];
        }
    }
    
    
}


- (void)tapAction{
    
    [self xjhMineViewDidClickUserInfoBtn:nil];
}


- (PrivatenessSummaryEntity *)userSummaryEntity{
    
    if (_userSummaryEntity == nil) {
        _userSummaryEntity = [[PrivatenessSummaryEntity alloc] init];
    }
    return _userSummaryEntity;
}

- (WalletEntity *)walletEntity{
    if (_walletEntity == nil) {
        _walletEntity = [[WalletEntity alloc] init];
    }
    return _walletEntity;
}

- (NSArray *)groupArray{
    
    if (_groupArray == nil) {
        
        
        JXMineModel * mindeModel1 = [[JXMineModel alloc] init];
        
        mindeModel1.cellMessage =@[@"我的档案",@"我的公司",@"我的点评"];
        mindeModel1.cellImage = @[[UIImage imageNamed:@"我的档案"],[UIImage imageNamed:@"jhcompany"],[UIImage imageNamed:@"我的点评"]];
        
        JXMineModel * mindeModel2 = [[JXMineModel alloc] init];
        mindeModel2.cellMessage =@[@"求职",@"口袋",@"消息"];
        mindeModel2.cellImage = @[[UIImage imageNamed:@"求职"],[UIImage imageNamed:@"jinku"],[UIImage imageNamed:@"XJH消息"]];
        
        JXMineModel * mindeModel3 = [[JXMineModel alloc] init];
        mindeModel3.cellMessage =@[@"邀请注册",@"设置"];
        mindeModel3.cellImage = @[[UIImage imageNamed:@"邀请"],[UIImage imageNamed:@"seting"]];
        _groupArray = @[mindeModel1,mindeModel2,mindeModel3];
    }
    return _groupArray;
}

#pragma mark -- 个人信息
- (void)xjhMineViewDidClickUserInfoBtn:(XJHMineView *)jhMineView{
    UserInformationVC * userVC = [[UserInformationVC alloc] init];
    userVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
