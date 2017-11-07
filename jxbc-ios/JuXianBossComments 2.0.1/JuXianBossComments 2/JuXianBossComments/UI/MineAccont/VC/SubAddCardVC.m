//
//  SubAddCardVC.m
//  JuXianBossComments
//
//  Created by wy on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SubAddCardVC.h"
#import "JXTableView.h"
#import "JXCardDetailCell.h"
#import "JXAddCardFootView.h"
#import "JXGetMoneyVC.h"
#import "JXSubmitApplyVC.h"
#import "GetMoneyView.h"
#import "CompanyBankCard.h"

#import "UserWorkbenchVC.h"
#import "MineAccountViewController.h"

@interface SubAddCardVC ()<UITextFieldDelegate,JXFooterViewDelegate>

@property (nonatomic,copy)NSString *str;
@property (nonatomic,strong)GetMoneyView * moneyView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)CGFloat jinku;

@property (nonatomic, strong) UIView *textView;

@end

@implementation SubAddCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self initData];
    
    if ([self.secondVC isKindOfClass:[UserWorkbenchVC class]]) {//个人提现
        
        [self initUserCardList];
        
    }else if ([self.secondVC isKindOfClass:[MineAccountViewController class]]){//企业提现
    
        [self initCardList];
    }
    
    self.jxTableView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0);
    
    [self setupUI];
}


- (void)initData{
    _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _bossEntity = [UserAuthentication GetBossInformation];
    _cardListArray = [NSMutableArray array];

}

-(void)setupUI
{

    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    _moneyView = [GetMoneyView getMoneyView];
    
    if ([self.title isEqualToString:@"企业提现"]) {
        
        //金库总额
        if (_companySummary.Wallet.AvailableBalance) {
            
            _moneyView.allMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[_companySummary.Wallet.AvailableBalance floatValue]];
        }else{
            _moneyView.allMoneyLabel.text = @"0.00";
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
    
    
    self.jxTableView.tableHeaderView = _moneyView;
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 140)];
    UIButton * addIdCard = [UIButton buttonWithFrame:CGRectMake(100, 20, SCREEN_WIDTH - 200, 44) title:@"+ 新建对公账号" fontSize:15.0 titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] imageName:nil bgImageName:nil];
    addIdCard.backgroundColor = [UIColor whiteColor];
    addIdCard.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addIdCard addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addIdCard];
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.x = 15;
    footerView.width = SCREEN_WIDTH - 30;
    footerView.y = CGRectGetMaxY(addIdCard.frame) + 10;
    footerView.delegate = self;
    footerView.nextLabel.text = @"提现";
    [bgView addSubview:footerView];
    self.jxTableView.tableFooterView = bgView;
    
    // 文案视图
    [footerView addSubview:self.textView];
}

//请求卡列表
-(void)initCardList
{
    [MineRequest getDrawMoneyRequestBankCardListCompanyId:_bossEntity.CompanyId success:^(JSONModelArray *array) {
        NSLog(@"array===%@",array);
        for (CompanyBankCard *cardModel in array) {
            [self.cardListArray addObject:cardModel];
        }
        [self.jxTableView reloadData];
        
    } fail:^(NSError *error) {
        NSLog(@"失败");
        NSLog(@" error === %@",error);
    }];
}

//个人银行卡列表
- (void)initUserCardList{

    [UserWorkbenchRequest getPrivatenessBankCardListSuccess:^(JSONModelArray *array) {
        
        for (CompanyBankCard *cardModel in array) {
            [self.cardListArray addObject:cardModel];
        }
        [self.jxTableView reloadData];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    self.str = self.headView.moneyTextField.text;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 82;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellid1";
    JXCardDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"JXCardDetailCell" owner:self options:0];
        cell = (JXCardDetailCell*)nibs.lastObject;
    }
    
    if (indexPath.row == _indexPath.row) {
        
        [cell.duiGouBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];

    }else{
    
        [cell.duiGouBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    }
    cell.bankCardModel = self.cardListArray[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXCardDetailCell *oldCell = (JXCardDetailCell*)[tableView cellForRowAtIndexPath:self.indexPath];

    [oldCell.duiGouBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    
    JXCardDetailCell *newcell = (JXCardDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    [newcell.duiGouBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    self.indexPath = indexPath;

    
}
#pragma mark -- 提现
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    
    
    if (_moneyView.putMoneyLabel.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"请输入提现金额"];
        return;
    }
    
    if ([_moneyView.putMoneyLabel.text isEqualToString:@"0"]) {
        
        [PublicUseMethod showAlertView:@"提现金额错误"];
        return;
    }
    
    if ( [_moneyView.putMoneyLabel.text floatValue] > _jinku) {
        [PublicUseMethod showAlertView:@"提现金额不能大于可提现金额"];
        return;
    }
    CompanyBankCard *bankCardModel = self.cardListArray[_indexPath.row];


    JXSubmitApplyVC *vc = [[JXSubmitApplyVC alloc]init];
    vc.companySummary = self.companySummary;
    //赋值数据
    vc.bankCard = bankCardModel;
    vc.companyNameStr = bankCardModel.CompanyName;
    vc.bankStr = bankCardModel.BankName;
    vc.bankAccountStr = bankCardModel.BankCard;
    vc.moneyStr = _moneyView.putMoneyLabel.text;
    if ([self.secondVC isKindOfClass:[UserWorkbenchVC class]]) {
        vc.title = @"口袋";
    }
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        vc.title = @"企业提现";
    }
    vc.secondVC = _secondVC;
    vc.walletEntity = _walletEntity;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)addClick
{
    JXGetMoneyVC *vc = [[JXGetMoneyVC alloc]init];
    vc.companySummary = self.companySummary;
    vc.walletEntity = _walletEntity;
    vc.secondVC = _secondVC;
    if ([self.secondVC isKindOfClass:[UserWorkbenchVC class]]) {
        vc.title = @"口袋";
    }
    if ([self.secondVC isKindOfClass:[MineAccountViewController class]]) {
        vc.title = @"企业提现";
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return textField.text;
}


- (UIView *)textView{
    
    if (!_textView) {
        
        _textView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 200)];
        
        
        // 提现说明
        UILabel* titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, ScreenWidth- 40, 20)];
        titleLable.text = @"提现说明:";
        titleLable.textColor = ColorWithHex(KColor_Text_BlackColor);
        titleLable.font = [UIFont systemFontOfSize:14];
        [_textView addSubview:titleLable];
        
        // 具体文字
        UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, 60)];
        if([self.title isEqualToString: @"口袋"]){
            textLable.text = @"提现成功提交后，老板点评将在一周之内打款";
        }else{
            textLable.text = @" 1、提现需提供专用发票；\n 2、发票抬头为“北京全联职信科技有限公司； \n 3、发票收到后老板点评将在10个工作日内打款；";
        }

        textLable.numberOfLines = 0;
        textLable.textColor = ColorWithHex(KColor_Text_BlackColor);
        
        textLable.font = [UIFont systemFontOfSize:12];
        [_textView addSubview:textLable];
    }
    return _textView;
}

@end
