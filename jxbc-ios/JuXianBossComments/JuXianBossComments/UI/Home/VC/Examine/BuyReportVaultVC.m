//
//  BuyReportVaultVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "BuyReportVaultVC.h"
#import "PayMethodCell.h"
#import "BackSurveyBuyDetailVC.h"
#import "JXRechargeMoneyVC.h"
#import "BuyReportVC.h"

@interface BuyReportVaultVC ()<JXFooterViewDelegate>{

    NSString *payStr;
    BOOL _isApppay;
}

@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)NSNumber * availableBalance;
@property (nonatomic, strong) JXRechargeMoneyVC * chargeMoneyVC;
@property (nonatomic, strong) BuyReportVC * payVC;
@end

@implementation BuyReportVaultVC

- (void)viewWillAppear:(BOOL)animated{
    _bossEntity = [UserAuthentication GetBossInformation];
    [super viewWillAppear:animated];
    [self initRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"支付";
    [self isShowLeftButton:YES];
    _bossEntity = [UserAuthentication GetBossInformation];
    payStr = [NSString stringWithFormat:@"%f",self.entity.TotalFee];
    [self initVC];
    [self initUI];
}

- (void)initVC{

    _chargeMoneyVC = [[JXRechargeMoneyVC alloc] init];
    _chargeMoneyVC.bhentity = self.entity;
    _payVC = [[BuyReportVC alloc] init];
    _payVC.entity = self.entity;
}

- (void)initRequest{

    [self showLoadingIndicator];
    MJWeakSelf
    [WorkbenchRequest getCompanyWalletWithCompanyId:_bossEntity.CompanyId success:^(WalletEntity *walletEntity) {
        [weakSelf dismissLoadingIndicator];
        _availableBalance  = walletEntity.AvailableBalance;
        if ([_availableBalance doubleValue] < self.entity.TotalFee) {
            
            [PublicUseMethod showAlertView:@"金币不够，请先充值"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakSelf getPayways];
            });
        }
        [weakSelf.jxTableView reloadData];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf faile:error];
    }];
}

- (void)faile:(NSError*)error{
    if (error.code == -1001) { // 请求超时
        [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
        
    }else if (error.code == -1009) {// 没有网络
        
        [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
        
    }else{// 其他
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }
}


- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.jxTableView.separatorColor = KColor_CellColor;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"PayMethodCell" bundle:nil] forCellReuseIdentifier:@"payMethodCell"];

    JXFooterView * footerView = [JXFooterView footerView];
    footerView.nextLabel.text = @"确定扣除金币";
    footerView.delegate = self;
    self.jxTableView.tableFooterView = footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        
        return 1;
    }else{
    
        return 3;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    bgView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    return bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        PayMethodCell * payCell = [tableView dequeueReusableCellWithIdentifier:@"payMethodCell" forIndexPath:indexPath];
        payCell.imageView.image = [UIImage imageNamed:@"kuku"];
        payCell.titlelabel.text = @"企业金库";
        payCell.valutExplan.hidden = NO;
        payCell.valutExplan.text = [NSString stringWithFormat:@"余额：%1.f金币",[_availableBalance doubleValue]];
        payCell.button.hidden = YES;
        payCell.companyKuLabel.hidden = YES;
        payCell.moneylabel.hidden = YES;

        return payCell;
    }else{
        
        if (indexPath.row == 0 || indexPath.row == 1) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"explain"];
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"explain"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            if (indexPath.row == 0) {//支付说明
                cell.textLabel.text = [NSString stringWithFormat:@"消耗：%1.f金币",self.entity.TotalFee];
            }else{
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];

                NSString  * myStr = [NSString stringWithFormat:@"消耗说明：%@",self.entity.CommoditySubject];
                NSRange range = [myStr rangeOfString: @"消耗说明："];
                NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
                [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_BlackColor] range:range];
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
                cell.textLabel.attributedText = str;
                
            }
            return cell;
        }else{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fff"];
            if (!cell) {
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fff"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            cell.textLabel.font = [UIFont systemFontOfSize:24];
            cell.textLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
            NSString  * myStr = [NSString stringWithFormat:@"应扣除：%1.f金币",self.entity.TotalFee];
            NSRange range = [myStr rangeOfString: @"应扣除："];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
            [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            cell.textLabel.attributedText = str;
            return cell;
        
        }
//        return nil;
    }
}

#pragma mark -- 支付
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    //判断金币是否够 不够则去充值
    if ([_availableBalance doubleValue] >= self.entity.TotalFee) {//金库金币够支付
        self.entity.PayWay = PaymentEngine.PayWays_Wallet;
        [self alertWithTitle:nil message:@"确认使用企业金库支付？" cancelTitle:@"关闭" okTitle:@"确定"];
    }else{
        [self getPayways];
//        [self getPaywaysText];
    }
}


- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancel];
    
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self walletPay];

    }];
    
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- 判断是苹果支付还是第三方支付  -- 线上
- (void)getPayways{
    
    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getPaywaysForAppleWithBizSource:self.entity.BizSource success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        if ([result isKindOfClass:[NSNull class]]) {
            return ;
        }else{
            
            _isApppay = [result containsObject:@"AppleIAP"];
            
            if (_isApppay) {
                
                [self.navigationController pushViewController:_chargeMoneyVC animated:YES];
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
    [MineDataRequest getPaywaysForAppleTextWithBizSource:self.entity.BizSource success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        _isApppay = [result containsObject:@"AppleIAP"];
        if (_isApppay) {//苹果内购
            [self.navigationController pushViewController:_chargeMoneyVC animated:YES];
        }else{
            [self.navigationController pushViewController:_payVC animated:YES];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}



#pragma mark -- 金库支付
- (void)walletPay{
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [PaymentRepository createTrade:self.entity success:^(PaymentResult * result) {
//        [weakSelf dismissLoadingIndicator];
        
        if (result.Success) {
            
            [MineDataRequest postWalletPayWithCompanyId:_bossEntity.CompanyId tradeCode:result.TradeCode Success:^(PaymentResult *paymentResult) {
                if (result.Success) {
                    
                    [weakSelf successfulWallet:paymentResult];
                }else{
                    
                    [PublicUseMethod showAlertView:paymentResult.ErrorMessage];
                }
                
            } fail:^(NSError *error) {
                [PublicUseMethod showAlertView:error.localizedDescription];
            }];
            
        }else{
            
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
        
    } fail:^(NSError * error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];

//        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
}

#pragma mark -- 金库支付成功
- (void)successfulWallet:(PaymentResult *)result{
    __weak typeof(self) weakSelf = self;
    PaymentResult *completResult = [[PaymentResult alloc] init];
    completResult.Success = true;
    completResult.PaidDetail = result.PaidDetail;
    completResult.TradeCode = result.TradeCode;
    completResult.PayWay = self.entity.PayWay;
    [self showLoadingIndicator];
    
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult * result) {
        [weakSelf dismissLoadingIndicator];
        if (result.Success) {
            [PublicUseMethod showAlertView:@"支付成功!"];
            [weakSelf performSelector:@selector(payDetailViewKu:) withObject:result afterDelay:0.5];
        }
        
    } fail:^(NSError * error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}

#pragma mark -- 详情页
- (void)payDetailViewKu:(PaymentResult *)payResult{
    
    NSDictionary *dic;
    //    服务购买成功
    dic = @{@"payWay":@"金库",@"money":payStr};
    UMBuyBackgoundSuccessEvent(dic);
    BackSurveyBuyDetailVC * oneVC = [[BackSurveyBuyDetailVC alloc]init];
//    oneVC.recordId = [payResult.TargetBizTradeCode longLongValue];
    oneVC.recordIdStr = payResult.TargetBizTradeCode;
    NSLog(@"登录页：self.navigationController====%@",self.navigationController);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:oneVC animated:YES];
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
