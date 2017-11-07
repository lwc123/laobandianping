//
//  MineAccountViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "MineAccountViewController.h"
#import "JXMineModel.h"
#import "XJHMineView.h"
#import "SystemconfigureVC.h"
#import "BossReviewRechargeVC.h"//消费记录
#import "MineDataRequest.h"
#import "JXAuthorizationManagerVC.h"//授权管理
#import "FixCompanyVC.h"

#import "MineRequest.h"
#import "JXMessageVC.h"
#import "JXGetMoneyVC.h"
#import "SubAddCardVC.h"

#import "CompanyWallentCell.h"
#import "WalletEntity.h"
#import "JXJudgeListVC.h"
#import "SectionManagerVC.h"//部门管理
#import "JXAccountInformationVC.h"//修改账号信息
#import "ChoiceCompanyVC.h"
#import "OpenCommentVC.h"
#import "JXOpenServiceWebVC.h"
#import "InvitationRegistVC.h"
#import "JXGoldDescriptionVC.h"//企业金库说明

#import "TextfieldCell.h"

@interface MineAccountViewController ()<WorkHeaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CompanyWallentCellDelegate,XJHMineViewDelegate>

@property (nonatomic,strong)NSArray * groupArray;
@property (nonatomic,strong)WorkHeaderView * workHeaderView;
@property (nonatomic,strong)AnonymousAccount * account;
@property (nonatomic,strong)UIImageView * iconImageView;
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic,strong)CompanyMembeEntity *userEntity;
@property (nonatomic,strong)WalletEntity *walletEntity;
@property (nonatomic,strong)CompanySummary *companySummary;

//银行卡列表
@property(nonatomic,strong)NSMutableArray *cardListArray;
@property(nonatomic,copy)NSString *auditStatus;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic,strong) XJHMineView * mineView;
@property (nonatomic, strong) UILabel * myLabel;

@end

@implementation MineAccountViewController

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:NO];
    [self initUI];
    // 默认大于30天
    self.days = 100;

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _companySummary = [[CompanySummary alloc] init];
    _walletEntity = [[WalletEntity alloc] init];
    _walletEntity = [[WalletEntity alloc] init];
    _account = [UserAuthentication GetCurrentAccount];
    _membeEntity = [UserAuthentication GetBossInformation];
    _userEntity = [UserAuthentication GetMyInformation];
    [self initRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - init
- (NSArray *)groupArray{

    if (_groupArray == nil) {
        JXMineModel * mindeModel1 = [[JXMineModel alloc] init];
        
        mindeModel1.cellMessage =@[@"我的评价",@"我的公司",@"邀请其他公司"];
        mindeModel1.cellImage = @[[UIImage imageNamed:@"comments"],[UIImage imageNamed:@"jhcompany"],[UIImage imageNamed:@"邀请"]];
        JXMineModel * mindeModel2 = [[JXMineModel alloc] init];
        mindeModel2.cellMessage =@[@"企业名称",@"企业金库",@"交易记录",@"授权管理",@"部门管理"];
        
        mindeModel2.cellImage = @[[UIImage imageNamed:@"企业"],[UIImage imageNamed:@"jinku"],[UIImage imageNamed:@"jiaoyi"],[UIImage imageNamed:@"shouquan"],[UIImage imageNamed:@"jhmanager"]];
        JXMineModel * mindeModel3 = [[JXMineModel alloc] init];
        mindeModel3.cellMessage =@[@"设置"];
        mindeModel3.cellImage = @[[UIImage imageNamed:@"seting"]];
        _groupArray = @[mindeModel1,mindeModel2,mindeModel3];
    }
    return _groupArray;
}

- (void)initUI{    
    
    _mineView = [XJHMineView jhMineView];
    _mineView.height = 154;
    _mineView.iconImageVIew.layer.masksToBounds = YES;
    _mineView.iconImageVIew.layer.cornerRadius = 65 * 0.5;
    _mineView.iconImageVIew.layer.borderWidth = 2;
    _mineView.iconImageVIew.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    _mineView.next.hidden = NO;
    _mineView.width = SCREEN_WIDTH;
    _mineView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_mineView addGestureRecognizer:tap];
    _mineView.delegate = self;
//    self.jxTableView.tableHeaderView = _mineView;
    [self.view addSubview:_mineView];
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(_mineView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 49 );
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.backgroundColor = [UIColor clearColor];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.scrollEnabled = YES;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"CompanyWallentCell" bundle:nil] forCellReuseIdentifier:@"companyWallentCell"];
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
    
}

- (void)tapAction{

    [self xjhMineViewDidClickUserInfoBtn:nil];
}

- (void)initRequest{
    WEAKSELF(_mineView);
    // 只在第一次加载的时候 显示
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self showLoadingIndicator];
    });
    MJWeakSelf
    [MineRequest getCompanyMineWithCompanyId:_membeEntity.CompanyId success:^(CompanySummary *companySummary) {
        [weakSelf dismissLoadingIndicator];
        if (![CompanySummary isKindOfClass:[NSNull class]]) {
            
            [UserAuthentication SaveCompanySummary:companySummary];
            [UserAuthentication SaveBossInformation:companySummary.BossInformation];
            [UserAuthentication SaveMyInformation:companySummary.MyInformation];
            _companySummary = companySummary;
            _walletEntity = companySummary.Wallet;
            //服务到期
            weakSelf.days = [companySummary getServiceDays];
            weak_mineView.nameLabel.text = companySummary.MyInformation.RealName;
            [_mineView.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:_account.UserProfile.Avatar] placeholderImage:UserImage];

            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

#pragma mark - tablevie delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 3) {
    
        if (_userEntity.Role == Role_BuildMembers || _userEntity.Role == Role_HightManager) {
            return 0;
        }else{
            return 44;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 && self.days <= 30) return 40;
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (self.days>30) {
            return nil;
        }
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        bgView.backgroundColor = [PublicUseMethod setColor:KColor_Text_WhiterColor];
        NSString * titleStr;
        
        UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openBtn.frame = CGRectMake((SCREEN_WIDTH - 95), (44 - 25) * 0.5, 80, 25);
        [openBtn setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
        openBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        openBtn.layer.masksToBounds = YES;
        openBtn.layer.cornerRadius = 4;
        openBtn.layer.borderWidth = 1;
        openBtn.layer.borderColor = [PublicUseMethod setColor:KColor_RedColor].CGColor;
        [openBtn addTarget:self action:@selector(openService) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.days >= 0 && self.days<=30) {
            titleStr = [NSString stringWithFormat:@"您的服务剩余时间：%ld天",(long)self.days + 1];
            [openBtn setTitle:@"开通服务" forState:UIControlStateNormal];

        }else{
            titleStr = @"您的服务已经到期，请续费后继续使用";
            [openBtn setTitle:@"开通服务" forState:UIControlStateNormal];
        }
        UILabel * myLabel = [UILabel labelWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH - 95), 43) title:titleStr titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:15.0 numberOfLines:1];
        [bgView addSubview:myLabel];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = KColor_CellColor;
        [bgView addSubview:lineView];
        myLabel.text = titleStr;
#pragma mark -- 服务时间小于30天才有开通服务的按钮
        if (self.days <= 30) {
            [bgView addSubview:openBtn];
        }
        return bgView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//我的评价
            JXJudgeListVC * judgeVC = [[JXJudgeListVC alloc] init];
            judgeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:judgeVC animated:YES];
        }else if (indexPath.row == 1){// 我的公司
            
            if ([_account.MobilePhone isEqualToString:DemoPhone]) {
                [PublicUseMethod showAlertView:@"演示账号不能使用此功能"];
            }else{
                if (_companySummary.myCompanys > 1) {
                    ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
                    choiceVC.secondVC = self;
                    [self.navigationController pushViewController:choiceVC animated:YES];
                }else{
                    OpenCommentVC * openVC = [[OpenCommentVC alloc] init];
                    openVC.isChangeCompany = YES;
                    [self.navigationController pushViewController:openVC animated:YES];
                }
            }
        }else{//邀请公司
        
            InvitationRegistVC * invitationVC = [[InvitationRegistVC alloc] init];
            invitationVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:invitationVC animated:YES];
        }
    }else if (indexPath.section == 1) {//第二组
        if (indexPath.row == 0) {//企业信息
            FixCompanyVC * fixVC = [[FixCompanyVC alloc] init];
            fixVC.companySummary =  _companySummary;
            fixVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:fixVC animated:YES];
        }else if (indexPath.row == 1){//企业金库
            
            JXGoldDescriptionVC * goldWeb = [[JXGoldDescriptionVC alloc] init];
            goldWeb.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:goldWeb animated:YES];
        }else if (indexPath.row == 2){//授权管理 交易记录
            
            BossReviewRechargeVC * bossReview = [[BossReviewRechargeVC alloc] init];
            bossReview.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bossReview animated:YES];
        }else if (indexPath.row == 3){//授权管理
            JXAuthorizationManagerVC * authorizationManagerVC = [[JXAuthorizationManagerVC alloc] init];
            authorizationManagerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:authorizationManagerVC animated:YES];
        }else{//部门管理
            SectionManagerVC * sectionManager= [[SectionManagerVC alloc] init];
            [self.navigationController pushViewController:sectionManager animated:YES];
        }
    }else {//第三组
        //系统设置
        SystemconfigureVC * systemVC = [[SystemconfigureVC alloc] init];
        systemVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:systemVC animated:YES];
    }
}

#pragma mark - tableview dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    JXMineModel * message = self.groupArray[section];
    return message.cellMessage.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    if (indexPath.section == 1 && indexPath.row == 1) {//金库
        CompanyWallentCell * wallentCell = [tableView dequeueReusableCellWithIdentifier:@"companyWallentCell" forIndexPath:indexPath];
        wallentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        wallentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        wallentCell.delegate = self;
        wallentCell.walletModel = _walletEntity;
        return wallentCell;
    }else{
        static NSString *identifier = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            _myLabel = [UILabel labelWithFrame:CGRectMake((SCREEN_WIDTH - 50) - 33, 0, 50, 44) title:@" " titleColor:[PublicUseMethod setColor:KColor_GoldColor] fontSize:14.0 numberOfLines:1];
            _myLabel.textAlignment = NSTextAlignmentRight;
            _myLabel.hidden = YES;
            [cell.contentView addSubview:_myLabel];
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

        if (indexPath.section == 0 && indexPath.row == 1) {//我的公司
            if (_companySummary.myCompanys > 1) {
                cell.textLabel.text = @"我的其他公司";
            }else{
                cell.textLabel.text = @"创建新的公司";
            }
        }
        CompanySummary * company= [UserAuthentication GetCompanySummary];
        if (indexPath.section == 1 && indexPath.row == 0) {//企业信息
            cell.textLabel.text = _companySummary.CompanyAbbr;
            _myLabel.hidden = NO;
            if (company.AuditStatus == 2) {
                _myLabel.text = @"已认证";
            }else if (company.AuditStatus == 9){
                _myLabel.text = @"被拒绝";
            }else if (self.days < 0){
                _myLabel.text = @"服务到期";
            }
        }else{
            _myLabel.hidden = YES;
        }
        if (indexPath.section == 1 && indexPath.row == 3) {//建党员不能看授权管理
            if (_userEntity.Role == Role_BuildMembers || _userEntity.Role == Role_HightManager) {
                cell.hidden = YES;
            }else{
                cell.hidden = NO;;
            }
        }
            return cell;
    }
}

#pragma mark - function
- (void)workHeaderViewDidClickFixBtn:(WorkHeaderView *)workView{
    if (self.days < 0) {//服务已经到期
        [self alertWithString:@"此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？"];
    }else{
        FixCompanyVC * fixVC = [[FixCompanyVC alloc] init];
        fixVC.companySummary =  _companySummary;
        fixVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fixVC animated:YES];
    }
}

#pragma mark -- 开通服务 目前是h5页面
- (void)openService{
    
    JXOpenServiceWebVC * webVC = [[JXOpenServiceWebVC alloc] init];
    webVC.companyId = _membeEntity.CompanyId;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)alertWithString:(NSString*)string{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"稍后开通" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"开通服务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openService];
        
    }];
    [cancel setValue:ColorWithHex(KColor_Text_BlackColor) forKey:@"titleTextColor"];
    [okAction setValue:ColorWithHex(KColor_GoldColor) forKey:@"titleTextColor"];
    [alert addAction:cancel];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark --- 提现
-  (void)companyWallentCellDidClickedSubmitMoney:(CompanyWallentCell *)companyWallentCell{

    //有银行卡
    if (self.companySummary.ExistBankCard) {
        //                [self initCardList];
        SubAddCardVC *vc = [[SubAddCardVC alloc]init];
        vc.title = @"企业提现";
        vc.secondVC = self;
        vc.hidesBottomBarWhenPushed= YES;
        vc.companySummary = self.companySummary;
        vc.cardListArray = self.cardListArray;
        [self.navigationController pushViewController:vc animated:YES];
    }else
    {
        //没有银行卡
        JXGetMoneyVC *VC = [[JXGetMoneyVC alloc]init];
        VC.companySummary = self.companySummary;
        VC.secondVC = self;
        VC.hidesBottomBarWhenPushed= YES;
        VC.title = @"企业提现";
        [self.navigationController pushViewController:VC animated:YES];
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        _mineView.bgImageView.frame = CGRectMake(offsetY/2, offsetY, ScreenWidth - offsetY, 154 - offsetY);
        _mineView.systemSetBt.transform = CGAffineTransformMakeTranslation(0,20);
    }else{
        
        [UIView animateWithDuration:.1 animations:^{
            _mineView.systemSetBt.transform = CGAffineTransformIdentity;
        }];
    }
    
}

#pragma mark -- 个人信息
- (void)xjhMineViewDidClickUserInfoBtn:(XJHMineView *)jhMineView{

    //我的信息
    JXAccountInformationVC * accountVC = [[JXAccountInformationVC alloc] init];
    accountVC.companySummary = _companySummary;
    [self.navigationController pushViewController:accountVC animated:YES];
}

//请求卡列表
-(void)initCardList
{
    [MineRequest getDrawMoneyRequestBankCardListCompanyId:5 success:^(JSONModelArray *array) {
        
        self.cardListArray = [NSMutableArray array];
        for (CompanyBankCard *cardModel in array) {
            if (cardModel != nil) {
                [self.cardListArray addObject:cardModel];
            }
        }
    } fail:^(NSError *error) {

    }];
}



@end
