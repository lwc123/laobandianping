//
//  OpenCommentVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "OpenCommentVC.h"
#import "PayViewController.h"
#import "ColorButton.h"
#import "OpenEnterpriseRequest.h"
#import "OpenViewCell.h"
#import "ContactUsViewController.h"
#import "AppleOpenServiceVC.h"
#import "AccountRepository.h"
#import "LoginViewController.h"
#import "OpenPayCell.h"
#import "ProveOneViewController.h"
@interface OpenCommentVC ()<UITextFieldDelegate>{
    
    NSArray * _placehoderArray;
    UIImageView * _iconImage;
}


@property (strong, nonatomic) UITextField *companyTF;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) UITextField *allFieldTex;
@property (weak, nonatomic) IBOutlet UIButton *gotoPayBtn;
@property (strong, nonatomic) AnonymousAccount *account;
@property (nonatomic,strong)PriceStrategyEntity * priceEntity;
@property (nonatomic, strong) UIButton *contactUsButton;

//苹果内购
@property (nonatomic, strong) AppleOpenServiceVC * openVC;
//第三方支付
@property (nonatomic, strong) PayViewController * payVC;
@property (nonatomic, strong) NSArray *payArray;
@property (nonatomic, strong) OpenEnterpriseRequest *openEnterprise;
@end

@implementation OpenCommentVC

#pragma mark - life Cycle
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    [self initPriceRequest];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通服务";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
    
}

#pragma mark - init

- (void)initData{
    _priceEntity = [[PriceStrategyEntity alloc] init];
    self.account = [UserAuthentication GetCurrentAccount];
    _payArray = [NSArray array];
}




- (void)initUI{
    _dataArray = @[@"请填写开户信息",@"公司名称:",@"您的姓名:",@"您的身份:"];
    _placehoderArray = @[@"请填写开户信息",@"请输入和营业执照一致的公司名称",@"请输入您的姓名",@"请输入您的职务，如：总经理"];
    
    UIButton * bbb = [UIButton buttonWithType:UIButtonTypeCustom];
    bbb.frame = CGRectMake(0, 15, 40, 40);
    
    [bbb setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [bbb addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:1];
    [self.view addSubview:bbb];
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _iconImage.image = [UIImage imageNamed:@"opendefault"];
    self.jxTableView.tableHeaderView = _iconImage;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"OpenViewCell" bundle:nil] forCellReuseIdentifier:@"openViewCell"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.jxTableView.backgroundView addGestureRecognizer:tap];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"OpenPayCell" bundle:nil] forCellReuseIdentifier:@"openPayCell"];
    
}

- (void)backButton{
    
    if (self.isChangeCompany == YES) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        LoginViewController * landPageVC = [[LoginViewController alloc] init];
        [PublicUseMethod changeRootNavController:landPageVC];
    }
}

#pragma mark -- 演示
- (void)demoBtn:(UIButton *)btn{
    
    NSString * phoneStr = @"18700000000";
    NSString * passwordStr = @"974539";
    __weak OpenCommentVC *weakSelf = self;
    [self showLoadingIndicator];
    [AccountRepository signIn:phoneStr password:passwordStr success:^(AccountSignResult *result, NSString *platformAccountId, NSString *platformAccountPassword) {
        
        [weakSelf dismissLoadingIndicator];
        if(result.SignStatus == 1){
            [weakSelf signInSuccess:result];
        }else{
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf signInFail:error];
    }];
}

//成功
-(void)signInSuccess:(AccountSignResult *)result
{
    if (result.SignStatus == 1)
    {
        //选择身份
        [SignInMemberPublic SignInLoginWithAccount:result.Account];
    }else{
        [SVProgressHUD showSuccessWithStatus:result.ErrorMessage];
        return;
    }
}

//失败
-(void)signInFail:(NSError *)error
{
    Log(@"登录失败:error===%@",error.localizedDescription);
    if (error.code == -1001) { // 请求超时
        [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
    }else if (error.code == -1009) {// 没有网络
        [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
    }else{// 其他
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }
    
}
#pragma mark -- 支付
- (void)payBtn:(UIButton *)btn{
    UITextField * companyTf = [self.view viewWithTag:301];
    UITextField * nameTf = [self.view viewWithTag:302];
    UITextField * jobTf = [self.view viewWithTag:303];
    
    if (companyTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请输入公司名称"];
        return;
    }
    if (companyTf.text.length > 30) {
        
        [PublicUseMethod showAlertView:@"公司名称超过了30个字"];
        return;
    }

    if (nameTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:_placehoderArray[2]];
        return;
    }
    if (nameTf.text.length > 5) {
        
        [PublicUseMethod showAlertView:@"姓名最多5个字"];
        return;
    }
    if (jobTf.text.length == 0) {
        
        [PublicUseMethod showAlertView:_placehoderArray[3]];
        return;
    }
    if (jobTf.text.length > 20) {
        
        [PublicUseMethod showAlertView:@"职务最多20个字"];
        return;
    }
    _openEnterprise = [[OpenEnterpriseRequest alloc] init];
    
    _openEnterprise.CompanyName = companyTf.text;
    _openEnterprise.RealName = nameTf.text;
    _openEnterprise.JobTitle = jobTf.text;
    NSString *extension = [_openEnterprise toJSONString];
    
    _payVC = [[PayViewController alloc] init];
    
    PaymentEntity *entity = [[PaymentEntity alloc]init];
    entity.TradeMode = PaymentEngine.TradeMode_Payout;
    entity.BizSource = PaymentEngine.BizSources_OpenEnterpriseService;
    entity.TradeType  = PaymentEngine.TradeType_OrganizationToOrganization;
    entity.TotalFee = _priceEntity.IosPreferentialPrice;
    entity.CommodityExtension = extension;
    entity.OwnerId = -1;
    entity.CommoditySubject = @"开通老板点评服务";
    _payVC.entity = entity;
    _payVC.companyName = companyTf.text;
    _payVC.secondVC = self;
    
    
    //保存企业名称
    [[NSUserDefaults standardUserDefaults] setObject:companyTf.text forKey:CompanyNameKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    _openVC = [[AppleOpenServiceVC alloc] init];
    _openVC.entity = entity;
    _openVC.secondP = self.secondVC;
    
    MJWeakSelf
    [self showLoadingIndicator];
    [MineDataRequest getExistsCompanyWith:companyTf.text success:^(id result) {
//        [weakSelf dismissLoadingIndicator];
        
        if ([result integerValue] > 0) {//代表存在这个公司
            [PublicUseMethod showAlertView:@"您输入的公司已开通服务,请联系该公司管理员"];
        }else{
            UMOpenServiceEvent;
            if (_priceEntity.IosPreferentialPrice == 0) {
                [weakSelf createCompany];
            }else{
                [weakSelf getPayways];
    //            [weakSelf getPaywaysText];
            }
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

#pragma mark -- 创建公司
- (void)createCompany{
    
    [MineDataRequest postCreateNewCompanyWith:_openEnterprise Success:^(CompanyModel *company) {
        [self dismissLoadingIndicator];
        NSString * companyIdStr = [NSString stringWithFormat:@"%ld",company.CompanyId];
        [[NSUserDefaults standardUserDefaults] setObject:companyIdStr forKey:CompanyChoiceKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self changeCurrentToOrganizationProfileWith:company.CompanyId];
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}

#pragma mark -- 个人切换企业
- (void)changeCurrentToOrganizationProfileWith:(long)companyId{

    JXOrganizationProfile * profile = [[JXOrganizationProfile alloc] init];
    profile.CurrentOrganizationId = companyId;
    
    [AccountRepository changeCurrentToOrganizationProfileWithprofile:profile success:^(AccountEntity *result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ProveOneViewController * oneVC = [[ProveOneViewController alloc]init];
            [PublicUseMethod changeRootNavController:oneVC];
        });
        
    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];
        
    }];

}


#pragma mark -- 请求价格
- (void)initPriceRequest{
    
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [MineDataRequest getPriceStrategyCurrentActivityWith:ActivityType_CompanyOpen withVersion:app_Version success:^(PriceStrategyEntity *priceStrategyEntity) {
        
        if (priceStrategyEntity) {
            _priceEntity = priceStrategyEntity;
            [_iconImage sd_setImageWithURL:[NSURL URLWithString:priceStrategyEntity.IosActivityHeadFigure] placeholderImage:[UIImage imageNamed:@"headertu"]];
        }
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:0 inSection:0]; //刷新第0段第2行
        [self.jxTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } fail:^(NSError *error) {
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}
#pragma mark -- 关于我们
- (void)contactUsButtonClick:(UIButton*)sender{
    
    ContactUsViewController* contactVc = [[ContactUsViewController alloc]init];
    [self.navigationController pushViewController:contactVc animated:YES];
    
}

#pragma mark -- 判断是苹果支付还是第三方支付  -- 线上
- (void)getPayways{

    [self showLoadingIndicator];
    MJWeakSelf
    
    [MineDataRequest getPaywaysForAppleWithBizSource:PaymentEngine.BizSources_OpenEnterpriseService success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        if ([result isKindOfClass:[NSNull class]]) {
            return ;
        }else{
            _payArray = result;
            BOOL isApppay = [result containsObject:@"AppleIAP"];
            
            if (isApppay) {
                
                [self.navigationController pushViewController:_openVC animated:YES];
            }else{
                [self.navigationController pushViewController:_payVC animated:YES];
            }
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}

#pragma mark -- 判断是苹果支付还是第三方支付 -- 线下
- (void)getPaywaysText{

    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getPaywaysForAppleTextWithBizSource:PaymentEngine.BizSources_OpenEnterpriseService success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        
        BOOL isApppay = [result containsObject:@"AppleIAP"];
        if (isApppay) {//苹果内购
            [self.navigationController pushViewController:_openVC animated:YES];
        }else{
            [self.navigationController pushViewController:_payVC animated:YES];
            
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}

#pragma mark - table datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataArray.count + 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 25;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    bgView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    return bgView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0){
            if (_priceEntity.IsActivity) {//有活动
                if (_priceEntity.IosPreferentialPrice == 0){
                    return 0;
                }else{
                    return 130;
                }
            }else{//没有活动
                return 110;
            }
        }else{
            return 44;
        }
    }else{
        return 90;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OpenViewCell * openCell = [tableView dequeueReusableCellWithIdentifier:@"openViewCell" forIndexPath:indexPath];
            openCell.selectionStyle = UITableViewCellAccessoryNone;
            openCell.priceEntity = _priceEntity;
            return openCell;
            
        }else{
            
            static NSString * cellId = @"myCellId";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                CGFloat allFieldTexW = 235;
                _allFieldTex = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, allFieldTexW, 44)];
                _allFieldTex.textAlignment = NSTextAlignmentLeft;
                _allFieldTex.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
                _allFieldTex.font = [UIFont systemFontOfSize:15];
                _allFieldTex.delegate = self;
                [cell.contentView addSubview:_allFieldTex];
            }
            cell.selectionStyle = UITableViewCellAccessoryNone;
            
            if (indexPath.row == 1) {
                _allFieldTex.hidden = YES;
                cell.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
                cell.textLabel.font = [UIFont systemFontOfSize:15.0];
                cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
            }
            _allFieldTex.tag = 300 +(indexPath.row - 1);
            _allFieldTex.placeholder = _placehoderArray[indexPath.row -1];
            cell.textLabel.text = _dataArray[indexPath.row - 1];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            return cell;
        }
    }else{
        OpenPayCell * payCell = [tableView dequeueReusableCellWithIdentifier:@"openPayCell" forIndexPath:indexPath];
        payCell.selectionStyle = UITableViewCellSelectionStyleNone;
        payCell.separatorInset = UIEdgeInsetsMake(0, 0, 0, payCell.bounds.size.width);
        if (_priceEntity.IosPreferentialPrice == 0) {
            payCell.instructionLabel.hidden = YES;
        }
        //产品演示
        [payCell.demoBtn addTarget:self action:@selector(demoBtn:) forControlEvents:UIControlEventTouchUpInside];
        //支付
        [payCell.payBtn addTarget:self action:@selector(payBtn:) forControlEvents:UIControlEventTouchUpInside];
        //联系我们
        [payCell.contactUsButton addTarget:self action:@selector(contactUsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return payCell;
        
    }
}

#pragma mark --键盘消失
- (void)tap:(UITapGestureRecognizer *)tapGes{
    
    [self.jxTableView endEditing:YES];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    [self.jxTableView endEditing:YES];
    
    return [self hitTest:point withEvent:event];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - lazy load

- (UIButton *)contactUsButton{
    
    if (_contactUsButton == nil) {
        _contactUsButton = [[UIButton alloc] init];
        [_contactUsButton setTitle:@"如需帮助，请联系我们" forState:UIControlStateNormal];
        [_contactUsButton setTitleColor:ColorWithHex(@"64A9FE") forState:UIControlStateNormal];
        _contactUsButton.height = 15;
        [_contactUsButton sizeToFit];
        //        _contactUsButton.contentMode = UIViewContentModeLeft;
        _contactUsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _contactUsButton.titleLabel.x = 0;
        _contactUsButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_contactUsButton addTarget:self action:@selector(contactUsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactUsButton;
}

#pragma mark -- 返回退出账号
- (void)leftButtonAction:(UIButton *)button{
    
    [self showLoadingIndicator];
    
    // 切换公司界面过来的 直接pop
    if (self.isChangeCompany) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    // 返回到登录页面
    [AccountRepository signOut: ^(id result) {
        [self dismissLoadingIndicator];
        if (result) {
            [UserAuthentication removeCurrentAccount];
            
            NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
            [current removeObjectForKey:@"currentIdentity"];
            [current synchronize];
            
            NSUserDefaults *company = [NSUserDefaults standardUserDefaults];
            [company removeObjectForKey:CompanyChoiceKey];
            [company synchronize];
            
            NSString * userProfilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userProfile.data"];
            NSFileManager * userProfileFileManager = [[NSFileManager alloc]init];
            [userProfileFileManager removeItemAtPath:userProfilePath error:nil];
            
            LoginViewController * landingVC = [[LoginViewController alloc] init];
            
            [UIView animateWithDuration:2 animations:^{
                
                [PublicUseMethod changeRootNavController:landingVC];
            }];
            
        }
        else
        {
            [self dismissLoadingIndicator];
            [PublicUseMethod showAlertView:@"返回失败"];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"返回失败"];
    }];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}





@end
