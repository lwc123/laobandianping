//
//  UserOpenVipVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserOpenVipVC.h"
#import "PayViewController.h"

#import "AppleOpenServiceVC.h"

@interface UserOpenVipVC ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *iDCard;
@property (nonatomic, strong) PayViewController * payVC;
@property (nonatomic, strong) AppleOpenServiceVC * openVC;


@end

@implementation UserOpenVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的档案";
    [self isShowLeftButton:YES];
    [self initSubView];
}

- (void)initSubView{

    if (_idCardFieldStr) {
        self.iDCard.text = [NSString stringWithFormat:@"身份证号：%@",_idCardFieldStr];;
    }
}

- (IBAction)goPayBtn:(id)sender {
    
    PaymentEntity * payEntity = [[PaymentEntity alloc] init];
    payEntity.TradeMode = PaymentEngine.TradeMode_Payout;
    payEntity.BizSource = PaymentEngine.BizSources_OpenPersonalService;
    payEntity.TradeType  = PaymentEngine.TradeType_PersonalToOrganization;
    payEntity.CommoditySubject = @"开通个人会员";
    payEntity.TotalFee = [_moneyLabel.text doubleValue];
    _payVC = [[PayViewController alloc] init];
    _payVC.secondVC = self;
    _payVC.entity = payEntity;
    
    _openVC = [[AppleOpenServiceVC alloc] init];
    _openVC.entity = payEntity;
    _openVC.secondP = self;
    [self getPayways];
//    [self getPaywaysText];
}

#pragma mark -- 判断是苹果支付还是第三方支付  -- 线上
- (void)getPayways{
    
    
    /*
     //开通企业服务
     static let BizSources_OpenEnterpriseService = "OpenEnterpriseService";
     //查看雇员档案（评价 离任报告）
     static let BizSources_ReadEmployeArchive = "ReadEmployeArchive";
     //充值
     static let BizSources_Deposit = "Deposit";
     //个人开通服务
     static let BizSources_OpenPersonalService = "OpenPersonalService";
     */
    
    
    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getPaywaysForAppleWithBizSource:PaymentEngine.BizSources_OpenPersonalService success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        BOOL isApppay = [result containsObject:@"AppleIAP"];
        
        if (isApppay) {
            
            [self.navigationController pushViewController:_openVC animated:YES];
        }else{
            [self.navigationController pushViewController:_payVC animated:YES];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)getPaywaysText{
    [self showLoadingIndicator];
    MJWeakSelf
    [MineDataRequest getPaywaysForAppleTextWithBizSource:PaymentEngine.BizSources_OpenPersonalService success:^(id result) {
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
