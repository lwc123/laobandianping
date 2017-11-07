//
//  JXSubmitApplyVC.m
//  JuXianBossComments
//
//  Created by wy on 16/12/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXSubmitApplyVC.h"
#import "DrawMoneyEntity.h"
#import "GetMoneyView.h"
#import "JXCardDetailCell.h"
#import "JXSubmitMoneySueeces.h"
#import "UserMineVC.h"
#import "MineAccountViewController.h"

@interface JXSubmitApplyVC ()<JXFooterViewDelegate>

@property (nonatomic,copy)DrawMoneyEntity *drawppMoney;
@property (nonatomic,assign)NSInteger companyId;
@property (nonatomic,strong)GetMoneyView * moneyView;
@property (nonatomic,assign)CGFloat jinku;


@end

@implementation JXSubmitApplyVC


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%ld",self.bankCard.CompanyId);    
    [self isShowLeftButton:YES];
    [self initUI];
    
}

- (void)initUI{
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    _moneyView = [GetMoneyView getMoneyView];
    //金库总额
    if (_companySummary.Wallet.AvailableBalance) {
        
        _moneyView.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_companySummary.Wallet.AvailableBalance floatValue]];
    }else{
        _moneyView.allMoneyLabel.text = @"0.00元";
    }
    //可提现金额
    CGFloat jinku = [_companySummary.Wallet.AvailableBalance floatValue] - [_companySummary.Wallet.FreezeFee floatValue];
    if (jinku) {
        _moneyView.canWithdrawLabel.text = [NSString stringWithFormat:@"可提现金额%.2f元",jinku];
    }else{
        _moneyView.canWithdrawLabel.text = @"可提现金额0.00元";
    }
    
    if ([self.title isEqualToString:@"企业提现"]) {
        //金库总额
        if (_companySummary.Wallet.AvailableBalance) {
            _moneyView.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_companySummary.Wallet.AvailableBalance floatValue]];
        }else{
            _moneyView.allMoneyLabel.text = @"0.00元";
        }
        //可提现金额
        _jinku = [_companySummary.Wallet.CanWithdrawBalance floatValue];
        if (_jinku) {
            _moneyView.canWithdrawLabel.text = [NSString stringWithFormat:@"可提现金额%.2f元",_jinku];
        }else{
            _moneyView.canWithdrawLabel.text = @"可提现金额0.00元";
        }
    }
    
    if ([self.title isEqualToString:@"口袋"]) {
        
        if (_walletEntity.AvailableBalance) {
            _moneyView.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_walletEntity.AvailableBalance floatValue]];
        }else{
            _moneyView.allMoneyLabel.text = @"0.00元";
        }
        //可提现金额
        _jinku = [_walletEntity.CanWithdrawBalance floatValue];
        if (_jinku) {
            _moneyView.canWithdrawLabel.text = [NSString stringWithFormat:@"可提现金额%.2f元",_jinku];
        }else{
            _moneyView.canWithdrawLabel.text = @"可提现金额0.00元";
        }
        
    }

    
    
    _moneyView.putMoneyLabel.text = self.moneyStr;
    _moneyView.putMoneyLabel.enabled = NO;
    self.jxTableView.tableHeaderView = _moneyView;

    [self.jxTableView registerNib:[UINib nibWithNibName:@"JXCardDetailCell" bundle:nil] forCellReuseIdentifier:@"jXCardDetailCell"];
    
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.height = 80;
    footerView.nextLabel.text = @"提交申请";
    self.jxTableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 87;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    JXCardDetailCell * detailCell = [tableView dequeueReusableCellWithIdentifier:@"jXCardDetailCell" forIndexPath:indexPath];
    detailCell.duiGouBtn.hidden = YES;
    
    
    detailCell.companyNameLabel.text = [NSString stringWithFormat:@"公司名称:%@",_companyNameStr];
    detailCell.bankNameLabel.text = [NSString stringWithFormat:@"开户银行:%@",_bankStr];
    detailCell.cardNumberLabel.text = [NSString stringWithFormat:@"银行账户:%@",_bankAccountStr];
    
    
    
    
    return detailCell;
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    DrawMoneyEntity * drawMoney = [[DrawMoneyEntity alloc] init];
    drawMoney.CompanyName = _companyNameStr;
    drawMoney.BankName = _bankStr;
    drawMoney.BankCard = _bankAccountStr;
    drawMoney.CompanyId = _companySummary.CompanyId;
    drawMoney.MoneyNumber = @([self.moneyStr integerValue]) ;
    if ([self.secondVC isKindOfClass:[UserMineVC class]]) {//个人提现
        
        [self subUserMoney:drawMoney];
    }
    
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        
        [self initCompanyMoeny:drawMoney];
    }
    
   
}

#pragma mark -- 个人
- (void)subUserMoney:(DrawMoneyEntity *)drawMoney{

    [UserWorkbenchRequest postPrivatenessDrawMoneyRequesWith:drawMoney success:^(id result) {
        
        if ([result[@"Success"] integerValue] >0) {
            [PublicUseMethod showAlertView:@"提现成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                JXSubmitMoneySueeces * moneyVC = [[JXSubmitMoneySueeces alloc] init];
                moneyVC.title = @"口袋";
                moneyVC.secondVC = _secondVC;
                [self.navigationController pushViewController:moneyVC animated:YES];
            });
        }
    } fail:^(NSError *error) {
        NSLog(@"error===%@",error);
    }];

}
#pragma mark -- 企业提现
- (void)initCompanyMoeny:(DrawMoneyEntity *)drawMoney{
    
    [self showLoadingIndicator];
    [MineRequest postDrawMoneyRequestAdd:drawMoney success:^(ResultEntity *resultEntity) {
        [self dismissLoadingIndicator];
        if (resultEntity.Success) {
            [PublicUseMethod showAlertView:@"提现成功"];
            JXSubmitMoneySueeces * moneyVC = [[JXSubmitMoneySueeces alloc] init];
            moneyVC.title = @"企业提现";
            moneyVC.secondVC = _secondVC;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:moneyVC animated:YES];

            });
        }else{
        
            [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
        }
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];

        NSLog(@"error===%@",error);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
