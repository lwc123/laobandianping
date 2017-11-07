//
//  JXGetMoneyVC.m
//  JuXianBossComments
//
//  Created by wy on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXGetMoneyVC.h"
#import "JXSubmitApplyVC.h"
#import "TextfieldCell.h"
#import "GetMoneyView.h"
#import "JXSubmitMoneySueeces.h"
#import "UserMineVC.h"


#import "MineAccountViewController.h"
#import "BossReviewRechargeVC.h"
@interface JXGetMoneyVC ()<UITextFieldDelegate,JXFooterViewDelegate>

@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NSArray * placehoderArray;
@property (nonatomic,strong)GetMoneyView * moneyView;
@property (nonatomic,assign)CGFloat jinku;

// 文案
@property (nonatomic, strong) UIView *textView;

@end

@implementation JXGetMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
    
    self.jxTableView.contentInset = UIEdgeInsetsMake(0, 0, 100,0);

}


- (void)initData{
    if ([self.secondVC isKindOfClass:[UserMineVC class]]) {
        _dataArray = @[@"开户名",@"开户行",@"银行账号"];
        _placehoderArray = @[@"请输入银行开户名",@"请输入开户银行营业网点",@"请输入银行账号"];
    }
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        _dataArray = @[@"公司名称",@"开户银行",@"银行账号"];
        _placehoderArray = @[@"请输入公司名称",@"请输入开户银行",@"请输入银行账号"];
    }
}

- (void)initUI{
    
    self.jxTableView.scrollEnabled = NO;

    UITapGestureRecognizer *tapClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap:)];
    [self.view addGestureRecognizer:tapClick];
    NSLog(@"%@",self.companySummary.Wallet.CanWithdrawBalance);


    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
    _moneyView = [GetMoneyView getMoneyView];
    
    
    if ([self.title isEqualToString:@"企业提现"]) {
        //金库总额
        if ([_companySummary.Wallet.AvailableBalance integerValue]) {
            _moneyView.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[_companySummary.Wallet.AvailableBalance floatValue]];
        }else{
            _moneyView.allMoneyLabel.text = @"0.00";
        }
        //可提现金额
        _jinku = [_companySummary.Wallet.CanWithdrawBalance floatValue];
        if (_jinku) {
            _moneyView.canWithdrawLabel.text = [NSString stringWithFormat:@"可提现金额:%.2f元",_jinku];
        }else{
            _moneyView.canWithdrawLabel.text = @"可提现金额:0.00元";
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
            _moneyView.canWithdrawLabel.text = [NSString stringWithFormat:@"可提现金额:%.2f元",_jinku];
        }else{
            _moneyView.canWithdrawLabel.text = @"可提现金额:0.00元";
        }
        // 交易记录按钮
        [self isShowRightButton:YES with:@"交易记录"];
    }
    
    self.jxTableView.tableHeaderView = _moneyView;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"提现";
    self.jxTableView.tableFooterView = footerView;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"textfieldCell"];
    [self.jxTableView addSubview:self.textView];

}
#pragma mark - tableview datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    TextfieldCell * cell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell" forIndexPath:indexPath];
    
    cell.jhtextfield.placeholder = _placehoderArray[indexPath.row];
    cell.jhtextfield.tag = 100 + indexPath.row;
    cell.jhLabel.text = _dataArray[indexPath.row];
    return cell;

}

#pragma mark - function
// 导航右侧按钮点击
- (void)rightButtonAction:(UIButton *)button{
    // 交易记录
    BossReviewRechargeVC * bossReview = [[BossReviewRechargeVC alloc] init];
    bossReview.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bossReview animated:YES];
    
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    NSLog(@"%@",self.moneyField.text);
    
    UITextField * companyName = [self.view viewWithTag:100];
    UITextField * bankTf = [self.view viewWithTag:101];
    UITextField * bankAccount = [self.view viewWithTag:102];

    
    if (_moneyView.putMoneyLabel.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请输入提现金额"];
        return;
    }
    
    if ( [_moneyView.putMoneyLabel.text floatValue] > _jinku) {
        [PublicUseMethod showAlertView:@"提现金额不能大于可提现金额"];
        return;
    }
    
    
    if ([self.secondVC isKindOfClass:[UserMineVC class]]) {
        if (companyName.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入开户名称"];
            return;
        }
        if (companyName.text.length > 5) {
            [PublicUseMethod showAlertView:@"姓名超出了5个字"];
            return;
        }
        
        if (bankTf.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入开户银行营业网点"];
            return;
        }
        if (bankTf.text.length > 30) {
            [PublicUseMethod showAlertView:@"开户银行超出了30个字"];
            return;
        }
        if (bankAccount.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入银行账号"];
            return;
        }
        if (bankAccount.text.length > 30) {
            [PublicUseMethod showAlertView:@"银行账号格式错误"];
            return;
        }
    }
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        
        if (companyName.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入公司名称"];
            return;
        }
        if (companyName.text.length > 30) {
            [PublicUseMethod showAlertView:@"公司名称超出了30个字"];
            return;
        }
        
        
        if (bankTf.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入开户银行"];
            return;
        }
        if (bankTf.text.length > 30) {
            [PublicUseMethod showAlertView:@"开户银行超出了30个字"];
            return;
        }
        if (bankAccount.text.length == 0) {
            [PublicUseMethod showAlertView:@"请输入银行账号"];
            return;
        }
        if (bankAccount.text.length > 30) {
            [PublicUseMethod showAlertView:@"银行账号格式错误"];
            return;
        }
        
    }
    
   
    
    
    JXSubmitApplyVC *submitApplyVC = [JXSubmitApplyVC alloc];
    submitApplyVC.moneyStr = _moneyView.putMoneyLabel.text;
    submitApplyVC.companyNameStr = companyName.text;
    submitApplyVC.bankStr = bankTf.text;
    submitApplyVC.bankAccountStr = bankAccount.text;
    submitApplyVC.companySummary = self.companySummary;
    submitApplyVC.secondVC = _secondVC;
    submitApplyVC.walletEntity = _walletEntity;
    if ([self.secondVC isKindOfClass:[UserMineVC class]]) {
        submitApplyVC.title = @"口袋";
    }
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        submitApplyVC.title = @"企业提现";
    }
    
    [self.navigationController pushViewController:submitApplyVC animated:YES];
}

- (IBAction)tijiaoApplyClick:(id)sender {
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}


-(void)clickTap:(UITapGestureRecognizer *)clickTap
{
    //收起键盘
    [self.view endEditing:YES];
}

- (UIView *)textView{
    
    if (!_textView) {

        _textView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.jxTableView.tableFooterView.frame) + 135, ScreenWidth, 200)];

        
        // 提现说明
        UILabel* titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth- 40, 20)];
        titleLable.text = @"提现说明:";
        titleLable.textColor = ColorWithHex(KColor_Text_BlackColor);
        titleLable.font = [UIFont systemFontOfSize:14];
        [_textView addSubview:titleLable];
        
        // 具体文字
        UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 60)];
        if([self.title isEqualToString: @"口袋"]){
            textLable.text = @"提现成功后，老板点评将在一周之内打款";
        }else{
            textLable.text = @" 1、提现需提供专用发票；\n 2、发票抬头为“北京全联职信科技有限公司； \n 3、发票收到后老板点评将在10个工作日内打款；";
        }
        [textLable sizeToFit];
        textLable.numberOfLines = 0;
        textLable.textColor = ColorWithHex(KColor_Text_BlackColor);

        textLable.font = [UIFont systemFontOfSize:12];
        [_textView addSubview:textLable];
    }
    return _textView;
}


@end
