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

@interface MineAccountViewController ()<WorkHeaderViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CompanyWallentCellDelegate>

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
@property(nonatomic,copy)NSString *role;
@property (nonatomic, assign) NSInteger days;

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
    _account = [UserAuthentication GetCurrentAccount];
    _walletEntity = [[WalletEntity alloc] init];
    _membeEntity = [UserAuthentication GetBossInformation];
    _companySummary = [[CompanySummary alloc] init];
    _walletEntity = [[WalletEntity alloc] init];
    [self initRequest];
    _userEntity = [UserAuthentication GetMyInformation];
    
    }

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - init
- (NSArray *)groupArray{

    if (_groupArray == nil) {
        JXMineModel * mindeModel1 = [[JXMineModel alloc] init];
        mindeModel1.cellMessage =@[@"金库",@"交易记录"];
        mindeModel1.cellImage = @[[UIImage imageNamed:@"jinku"],[UIImage imageNamed:@"jiaoyi"]];
        
        JXMineModel * mindeModel2 = [[JXMineModel alloc] init];
        mindeModel2.cellMessage =@[@"管理员",@"我的评价",@"授权管理",@"部门管理",@" "];
        mindeModel2.cellImage = @[[UIImage imageNamed:@"manager"],[UIImage imageNamed:@"comments"],[UIImage imageNamed:@"shouquan"],[UIImage imageNamed:@"jhmanager"],[UIImage imageNamed:@"jhcompany"]];
        
        JXMineModel * mindeModel3 = [[JXMineModel alloc] init];
        mindeModel3.cellMessage =@[@"设置"];
        mindeModel3.cellImage = @[[UIImage imageNamed:@"seting"]];
        _groupArray = @[mindeModel1,mindeModel2,mindeModel3];
    }
    return _groupArray;
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.backgroundColor = [UIColor clearColor];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.scrollEnabled = YES;
    _workHeaderView = [WorkHeaderView workHeaderView];
    _workHeaderView.delegate = self;
    _workHeaderView.stageEvaluationNum.hidden = YES;
    _workHeaderView.reportNum.hidden = YES;
    _workHeaderView.linethreeView.hidden = YES;
    _workHeaderView.height = 110;
    _workHeaderView.indiorBtn.hidden = NO;
    self.jxTableView.tableHeaderView = _workHeaderView;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"CompanyWallentCell" bundle:nil] forCellReuseIdentifier:@"companyWallentCell"];
}

- (void)initRequest{
    WEAKSELF(_workHeaderView);
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
            [weak_workHeaderView.iconImageView sd_setImageWithURL:[NSURL URLWithString:companySummary.CompanyLogo] placeholderImage:Company_LOGO_Image];
            weak_workHeaderView.companyName.text = companySummary.CompanyAbbr;
            weak_workHeaderView.LegalName.text = companySummary.LegalName;
            
            if (companySummary.AuditStatus == 1) {
                weak_workHeaderView.auditSatus.text = @"认证审核中";
            }
            if (companySummary.AuditStatus == 2) {
                weak_workHeaderView.auditSatus.text = @" ";
                weak_workHeaderView.auditImageView.hidden = NO;
            }
            weak_workHeaderView.EmployedNum.text = [NSString stringWithFormat:@"在职员工：%ld",companySummary.EmployedNum];
            weak_workHeaderView.DimissionNum.text = [NSString stringWithFormat:@"离任员工：%ld",companySummary.DimissionNum];
            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

#pragma mark - tablevie delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return 0;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
    
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
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        bgView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        NSString * titleStr;
        
        UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        openBtn.frame = CGRectMake((SCREEN_WIDTH - 90), 0, 90, 40);
        [openBtn setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
        openBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [openBtn addTarget:self action:@selector(openService) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.days >= 0 && self.days<=30) {
            titleStr = [NSString stringWithFormat:@"您的服务剩余时间：%ld天",(long)self.days + 1];
            [openBtn setTitle:@"开通服务" forState:UIControlStateNormal];

        }else{
            titleStr = @"您的服务已经到期，请续费后继续使用";
            [openBtn setTitle:@"开通服务" forState:UIControlStateNormal];
        }
        UILabel * myLabel = [UILabel labelWithFrame:CGRectMake(10, 0, 300, 40) title:titleStr titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:15.0 numberOfLines:1];
        [bgView addSubview:myLabel];

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
    
    if (indexPath.section == 0) {//老板充值
        if (indexPath.row == 0) {
        }else if (indexPath.row == 1){//消费记录
            BossReviewRechargeVC * bossReview = [[BossReviewRechargeVC alloc] init];
            bossReview.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bossReview animated:YES];
        }
    }else if (indexPath.section == 1) {//第二组
        
        if (indexPath.row == 0) {//管理员
            
            JXAccountInformationVC * accountVC = [[JXAccountInformationVC alloc] init];
            [self.navigationController pushViewController:accountVC animated:YES];
        }else if (indexPath.row == 1){//我添加的评价
            
            JXJudgeListVC * judgeVC = [[JXJudgeListVC alloc] init];
            judgeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:judgeVC animated:YES];
        }else if (indexPath.row == 2){//授权管理
        
            JXAuthorizationManagerVC * authorizationManagerVC = [[JXAuthorizationManagerVC alloc] init];
            authorizationManagerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:authorizationManagerVC animated:YES];
            
        }else if (indexPath.row == 3){//部门管理
            
            SectionManagerVC * sectionManager= [[SectionManagerVC alloc] init];
            [self.navigationController pushViewController:sectionManager animated:YES];
        }else{//我的公司
        
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {//金库
        CompanyWallentCell * wallentCell = [tableView dequeueReusableCellWithIdentifier:@"companyWallentCell" forIndexPath:indexPath];
        wallentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        wallentCell.delegate = self;
        
        if (_userEntity.Role == Role_BuildMembers || _userEntity.Role == Role_HightManager) {//只有管理员和老板提现 其他人不能看见提现两个字
            wallentCell.subBtn.hidden = YES;
            wallentCell.subBtn.enabled = NO;
        }
        wallentCell.hidden = YES;
        wallentCell.walletModel = _walletEntity;
        return wallentCell;
    }else{
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
        
        if (_userEntity.Role == Role_BuildMembers || _userEntity.Role == Role_HightManager) {//建党员不能看授权管理
            if (indexPath.section == 1 && indexPath.row == 2) {
                cell.hidden = YES;
            }
        }
        if (_userEntity.Role == Role_Boss) {
            _role = @"法人";
        }else if (_userEntity.Role == Role_manager){
            _role = @"管理员";
        }else if (_userEntity.Role == Role_HightManager){
            
            _role = @"高管";
        }else if (_userEntity.Role == Role_BuildMembers){
            _role = @"建档员";
        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",_userEntity.RealName,_role];
        }
        if (indexPath.section == 1 && indexPath.row == 4) {//我的公司
            
            if (_companySummary.myCompanys > 1) {
                cell.textLabel.text = @"我的其他公司";
            }else{
                cell.textLabel.text = @"创建新的公司";
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
//请求卡列表
-(void)initCardList
{
    [MineRequest getDrawMoneyRequestBankCardListCompanyId:5 success:^(JSONModelArray *array) {
        NSLog(@"成功");
        
        self.cardListArray = [NSMutableArray array];
        NSLog(@"%ld",array.count);
        for (CompanyBankCard *cardModel in array) {
            NSLog(@"%@",cardModel);
            if (cardModel != nil) {
                [self.cardListArray addObject:cardModel];
                NSLog(@"%ld",cardModel.PresenterId);
            }
        }
        
        
    } fail:^(NSError *error) {
        NSLog(@"失败");
        NSLog(@" error === %@",error);
    }];
}



@end
