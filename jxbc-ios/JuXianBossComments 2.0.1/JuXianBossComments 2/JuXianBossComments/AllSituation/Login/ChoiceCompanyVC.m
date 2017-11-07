//
//  ChoiceCompanyVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ChoiceCompanyVC.h"
#import "ChoiceCompanyCell.h"
#import "BossCommentTabBarCtr.h"
#import "CompanyMembeEntity.h"
#import "CompanyModel.h"
#import "ProveOneViewController.h"
#import "OpenCommentVC.h"
#import "JXJudgeListVC.h"
#import "OpenCommentVC.h"
#import "MineAccountViewController.h"
#import "AccountRepository.h"
#import "SetingVC.h"
#import "JXOpenServiceWebVC.h"
@interface ChoiceCompanyVC ()
{
    NSMutableArray * _dataArray;
    NSMutableArray * _companyArray;
}
@property (nonatomic,strong)CompanyModel * companyModel;
@property (nonatomic,strong)AnonymousAccount * account;
@end

@implementation ChoiceCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"企业登录";
    
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]] || [self.secondVC isKindOfClass:[SetingVC class]]) {
        [self isShowLeftButton:YES];
    }else{
        [self isShowLeftButton:NO];
    }
    //        //判断有几个企业 0 -> 就去开户 1 (认证被拒绝 重新认证  认证通过或是认证中 进入工作台) 多个 就要选择公司
    
    [self initData];
    if (_inforArray.count == 0) {
        [self initRequest];
    }
    [self initUI];
}

- (void)initData{

    _companyModel = [[CompanyModel alloc] init];
    _dataArray = [NSMutableArray array];
//    _inforArray = [NSArray array];
    _companyArray = [NSMutableArray array];
    _account = [UserAuthentication GetCurrentAccount];
}

- (void)initRequest{

    [self showLoadingIndicator];
    CompanyModel *__block compModel;
    [MineDataRequest InformationWithSuccess:^(JSONModelArray *array) {
        [self dismissLoadingIndicator];
        
        if ([array isKindOfClass:[NSNull class]]) {
            return ;
        }
        for (CompanyMembeEntity * membeEntity in array) {
            if ([membeEntity isKindOfClass:[CompanyMembeEntity class]]) {
                [_dataArray addObject:membeEntity];
                compModel = membeEntity.myCompany;
                [_companyArray addObject:compModel];
            }
        }
        _inforArray = _dataArray;
        [self.jxTableView reloadData];
        [self.jxTableView endRefresh];
        
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [self.jxTableView endRefresh];
        Log(@"%@",error.localizedDescription);
        NSLog(@"error===%@",error);
    }];


}

- (void)initUI{

    UILabel * myLabel = [UILabel labelWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20) title:@"请选择您所在的公司" titleColor:nil fontSize:17 numberOfLines:1];
    myLabel.font = [UIFont boldSystemFontOfSize:17.0];
    myLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:myLabel];
    
    
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(myLabel.frame) + 20, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"ChoiceCompanyCell" bundle:nil] forCellReuseIdentifier:@"choiceCompanyCell"];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 75)];
    footerView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    UIButton * addCompanyBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) * 0.5, 30, 150, 45)];
    [addCompanyBtn setTitle:@" 创建新公司" forState:UIControlStateNormal];
    addCompanyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [addCompanyBtn setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
    [addCompanyBtn setImage:[UIImage imageNamed:@"goldadd"] forState:UIControlStateNormal];
    addCompanyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 25);
    addCompanyBtn.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    addCompanyBtn.layer.masksToBounds = YES;
    addCompanyBtn.layer.cornerRadius = 4;
    addCompanyBtn.layer.borderWidth = 1;
    addCompanyBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    [footerView addSubview:addCompanyBtn];
    [addCompanyBtn addTarget:self action:@selector(addCompanyClick) forControlEvents:UIControlEventTouchUpInside];
    self.jxTableView.tableFooterView = footerView;
    
}

#pragma mark -- 创建新公司
- (void)addCompanyClick{
    //开户页
    OpenCommentVC * openVC = [[OpenCommentVC  alloc] init];
    openVC.isChangeCompany = YES;
    [self.navigationController pushViewController:openVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _inforArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChoiceCompanyCell * companyCell = [tableView dequeueReusableCellWithIdentifier:@"choiceCompanyCell" forIndexPath:indexPath];
    
    [companyCell.watiBtn addTarget:self action:@selector(watiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    companyCell.watiBtn.tag = 100 + indexPath.row;
    CompanyMembeEntity * model = _inforArray[indexPath.row];
    CompanyModel * company = model.myCompany;
    companyCell.membeEntity = model;
    
    companyCell.moneyLabel.textColor = ColorWithHex(KColor_Text_ListColor);
    [companyCell.watiBtn setTitleColor:ColorWithHex(KColor_Text_BlackColor) forState:UIControlStateNormal];
    companyCell.moneyLabel.font = [UIFont systemFontOfSize:13];
    // 未读消息数，显示
    companyCell.watiBtn.hidden = YES;
    companyCell.moneyLabel.hidden = NO;
    companyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (company.AuditStatus == 2) { // 已通过
        
        // 先判断服务到期时间
        if (!company.getServiceDays || company.getServiceDays >= 30) { // 未到期
            
            // 未读消息数
            if (model.UnreadMessageNum > 0) {
                companyCell.watiBtn.hidden = NO;
                companyCell.moneyLabel.hidden = YES;
                NSString * countStr = [NSString stringWithFormat:@"%ld条待审核评价",(long)model.UnreadMessageNum];
                [companyCell.watiBtn setTitle:countStr forState:UIControlStateNormal];
            }
            
        }else{ // 不足一个月的
            
            if (company.getServiceDays < 0) { // 到期
                
                // 禁掉按钮功能
                companyCell.watiBtn.enabled = NO;
                companyCell.watiBtn.hidden = NO;
                companyCell.moneyLabel.hidden = YES;
                [companyCell.watiBtn setTitle:@"服务到期" forState:UIControlStateNormal];
                [companyCell.watiBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{ // 未到期
                companyCell.moneyLabel.text = [NSString stringWithFormat:@"剩余%zd天",company.getServiceDays];
            }
            
        }
        
        
    }else if (company.AuditStatus == 0){ // 未提交
        companyCell.moneyLabel.text = @"未提交认证";
    }else if (company.AuditStatus == 1){ // 审核中
        companyCell.moneyLabel.text = @"审核中";
    }else if (company.AuditStatus == 9){ // 审核未通过
        companyCell.moneyLabel.text = @"审核不通过";
    }


    // 如果是切换公司时
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        // 显示登录中的公司，并禁止点击
        if (company.CompanyId == [UserAuthentication GetCompanySummary].CompanyId) {
            companyCell.moneyLabel.hidden = NO;
            companyCell.watiBtn.hidden = YES;
            companyCell.moneyLabel.text = @"登录中";
            companyCell.userInteractionEnabled = NO;
            companyCell.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        }else{
            companyCell.userInteractionEnabled = YES;
            companyCell.backgroundColor = [UIColor whiteColor];
        }
    }
    
    //取出公司的名称
    companyCell.companyLabel.text = [NSString stringWithFormat:@"%@",company.CompanyName];
    return companyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
   //选择公司的时候 要把公司id 存在本地  同时也要存储当前的身份
    CompanyMembeEntity * infoModel = _inforArray[indexPath.row];
    CompanyModel * compModel = infoModel.myCompany;
    
    // 如果是切换公司时
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]] || [self.secondVC isKindOfClass:[SetingVC class]]) {
        
        if (compModel.AuditStatus == 0 ) { // 未提交
            [self alertWithTitle:@"尚未提交认证" String:@"请重新登录后，再次选择此企业提交认证信息"];
            return;
        }
        if (compModel.AuditStatus == 1 ) { // 审核中
            [self alertWithTitle:@"企业认证审核中" String:@"通过后将以短信形式告知企业法人，请耐心等待。"];
            return;
        }
        if (compModel.AuditStatus == 9 ) { // 未通过
            [self alertWithTitle:@"企业认证审核不通过" String:@"请重新登录后，再次选择此企业提交认证信息。"];
            return;
        }
        
        if (compModel.AuditStatus == 2) { // 审核通过
            //保存企业Id
            NSString  * companyStr = [NSString stringWithFormat:@"%ld",infoModel.CompanyId];
            [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:CompanyChoiceKey];
            [[NSUserDefaults standardUserDefaults]synchronize];
            NSString * organization = [NSString stringWithFormat:@"%d",2];
            [[NSUserDefaults standardUserDefaults] setObject:organization forKey:@"currentIdentity"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            JXOrganizationProfile * pp = [[JXOrganizationProfile alloc] init];
            pp.CurrentOrganizationId = infoModel.CompanyId;
            //个人切换身份 选择公司
            [AccountRepository changeCurrentToOrganizationProfileWithprofile:pp success:^(AccountEntity *result) {
                [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];

            } fail:^(NSError *error) {
                [PublicUseMethod showAlertView:error.localizedDescription];

            }];
            return;
        }
    }
    
//    if ([self.secondVC isKindOfClass:[MineAccountViewController class]] || [self.secondVC isKindOfClass:[SetingVC class]]) {
//        
//        if (compModel.AuditStatus == 0 ) { // 未提交
//            [self alertWithString:@"该企业尚未提交企业认证。请退出重新登录，选择此企业重新提交认证信息"];
//            return;
//        }
//        if (compModel.AuditStatus == 1 ) { // 审核中
//            [self alertWithString:@"该企业正在审核当中，审核通过后会以短信通知的方式告知，请耐心等待"];
//            return;
//        }
//        if (compModel.AuditStatus == 9 ) { // 未通过
//            [self alertWithString:@"该企业认证尚未通过。请退出重新登录，选择此企业重新提交认证信息"];
//            return;
//        }
//        
//        if (compModel.AuditStatus == 2) { // 审核通过
//            //保存企业Id
//            NSString  * companyStr = [NSString stringWithFormat:@"%ld",infoModel.CompanyId];
//            [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:CompanyChoiceKey];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            NSString * organization = [NSString stringWithFormat:@"%d",2];
//            [[NSUserDefaults standardUserDefaults] setObject:organization forKey:@"currentIdentity"];
//            [[NSUserDefaults standardUserDefaults]synchronize];
//            JXOrganizationProfile * pp = [[JXOrganizationProfile alloc] init];
//            pp.CurrentOrganizationId = infoModel.CompanyId;
//            //个人切换身份 选择公司
//            [AccountRepository changeCurrentToOrganizationProfileWithprofile:pp success:^(AccountEntity *result) {
//                AnonymousAccount *anonymousAccount = [UserAuthentication GetCurrentAccount];
//                anonymousAccount.UserProfile.CurrentProfileType = OrganizationProfile;
//                [UserAuthentication SaveCurrentAccount:anonymousAccount];
//                [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
//            } fail:^(NSError *error) {
//                [PublicUseMethod showAlertView:error.localizedDescription];
//
//            }];
//            
//            return;
//        }
//        
//    }

    // 选择公司时
    if ( compModel.AuditStatus == 1) { // 审核中
        
        [self alertWithTitle:@"企业认证审核中" String:@"通过后将以短信形式告知企业法人，请耐心等待。"];
        return;
    }
    
    if (compModel.AuditStatus == 2 ) { // 已通过
        //保存企业Id
        NSString  * companyStr = [NSString stringWithFormat:@"%ld",infoModel.CompanyId];
        [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:CompanyChoiceKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        NSString * organization = [NSString stringWithFormat:@"%d",2];
        [[NSUserDefaults standardUserDefaults] setObject:organization forKey:@"currentIdentity"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        JXOrganizationProfile * pp = [[JXOrganizationProfile alloc] init];
        pp.CurrentOrganizationId = infoModel.CompanyId;
        //个人切换身份 选择公司
        [AccountRepository changeCurrentToOrganizationProfileWithprofile:pp success:^(AccountEntity *result) {
            AnonymousAccount *anonymousAccount = [UserAuthentication GetCurrentAccount];
            anonymousAccount.UserProfile.CurrentProfileType = OrganizationProfile;
            [UserAuthentication SaveCurrentAccount:anonymousAccount];
            [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
        } fail:^(NSError *error) {
            [PublicUseMethod showAlertView:error.localizedDescription];
            
        }];

        return;
    }
    
    if (compModel.AuditStatus == 0 || compModel.AuditStatus == 9) { // 未认证 和 未通过
    
        ProveOneViewController * proveoneVC= [[ProveOneViewController alloc] init];
        proveoneVC.copanyName = compModel.CompanyName;
        proveoneVC.companyModel = compModel;
        //保存企业名称
        [[NSUserDefaults standardUserDefaults] setObject:compModel.CompanyName forKey:CompanyNameKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSString * companyIdStr = [NSString stringWithFormat:@"%ld",compModel.CompanyId];
        [[NSUserDefaults standardUserDefaults] setObject:companyIdStr forKey:CompanyChoiceKey];
        [[NSUserDefaults standardUserDefaults]synchronize];

        // 如果是切换公司时
        if ([self.secondVC isKindOfClass:[MineAccountViewController class]] || [self.secondVC isKindOfClass:[SetingVC class]]) {
        proveoneVC.canPop = YES;
        [self.navigationController pushViewController:proveoneVC animated:YES];
            
        }else{ // 选择公司时
        
            [PublicUseMethod changeRootNavController:proveoneVC];
        }
        return;
    }
}
             

- (void)alertWithTitle:(NSString*)title String:(NSString*)string{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- 待审核的
- (void)watiBtnClick:(UIButton *)btn{

    CompanyMembeEntity * infoModel = _inforArray[btn.tag - 100];
    CompanyModel * company = infoModel.myCompany;
    // 服务到期 开通服务
    if([btn.currentTitle isEqualToString:@"服务到期"]){
        JXOpenServiceWebVC* openServiceWebVC = [[JXOpenServiceWebVC alloc]init];
        [self.navigationController pushViewController:openServiceWebVC animated:YES];
        openServiceWebVC.companyId = company.CompanyId;
        return;
    }
//跳到企业我的评价里面
    //保存企业Id
    NSString  * companyStr = [NSString stringWithFormat:@"%ld",infoModel.CompanyId];
    [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:CompanyChoiceKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [UserAuthentication SaveBossInformation:infoModel];
    [UserAuthentication SaveMyInformation:infoModel];
    BossCommentTabBarCtr * tabBar = [[BossCommentTabBarCtr alloc] init];
    tabBar.selectedIndex = 2;
    
    JXJudgeListVC * listVC = [[JXJudgeListVC alloc] init];
    listVC.isQuickLogin = YES;
    listVC.auditStatus = 1;
    [self.navigationController pushViewController:listVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
