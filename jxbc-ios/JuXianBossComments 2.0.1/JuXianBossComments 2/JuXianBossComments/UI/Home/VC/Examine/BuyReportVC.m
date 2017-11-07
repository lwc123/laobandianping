//
//  BuyReportVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//


#import "BuyReportVC.h"
#import "PayMethodCell.h"
#import "JXPayRequest.h"
#import "PayMethodCell.h"
#import "PaymentResult.h"
#import "JXAPIs.h"
#import "PayDetailViewController.h"
#import "MineAccountViewController.h"
#import "JSONKit.h"
#import "JuXianBossComments-Bridging-Header.h"
#import "paySucessVC.h"
#import "ChoiceCompanyCell.h"
#import "BackSurveyBuyDetailVC.h"
#import "TopAlertView.h"

@interface BuyReportVC ()<JXFooterViewDelegate>{

    NSString *payStr;

}

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSString *moneyStr;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)AnonymousAccount * account;
@property (nonatomic,strong)NSString *companyIdStr;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
//可用余额
@property (nonatomic,strong)NSNumber * availableBalance;


@end

@implementation BuyReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    [self isShowLeftButton:YES];
    [self initData];
    //金库余额
    [self initRequest];
    [self initUI];
    __weak typeof(self) weakSelf = self;
    APPDELEGATE.block = ^{
        
        [weakSelf successfulWXAction];
    };
}

- (void)initData{

    _bossEntity= [UserAuthentication GetBossInformation];
    payStr = [NSString stringWithFormat:@"%f",self.entity.TotalFee];
}

- (void)initRequest{
    [WorkbenchRequest getCompanyWalletWithCompanyId:_bossEntity.CompanyId success:^(WalletEntity *walletEntity) {
        
        NSLog(@"walletEntity===%@",walletEntity);
        _availableBalance  = walletEntity.AvailableBalance;
        [self.jxTableView reloadData];
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)initUI{
    
    self.jxTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    TopAlertView * topView = [TopAlertView topAlertView];
    topView.height = 30;
    topView.delagateBtn.hidden = YES;
    topView.addOnPcBtn.hidden = YES;
    topView.myLabel.text = @"企业金库余额不足,请购买金币进行支付,1人民币=1金币";
    self.jxTableView.tableHeaderView = topView;
    
    [self.jxTableView registerNib:[UINib nibWithNibName:@"PayMethodCell" bundle:nil] forCellReuseIdentifier:@"payMethodCell"];
    //支付宝
    [self.jxTableView registerNib:[UINib nibWithNibName:@"PayMethodCell" bundle:nil] forCellReuseIdentifier:@"aplayPayCell"];
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"支付";
    self.jxTableView.tableFooterView = footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 2;
    }else if (section == 1){
    
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0){
     return 39;
    }else if (section == 1){
        return 10;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        UILabel * payWayLabel = [UILabel labelWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 39) title:@"   选择支付方式" titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:15.0 numberOfLines:1];
        return payWayLabel;
    }else{
    
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        bgView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        return bgView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            PayMethodCell * payCell = [tableView dequeueReusableCellWithIdentifier:@"payMethodCell" forIndexPath:indexPath];
            payCell.titleImageView.image = [UIImage imageNamed:@"weixinzhifu"];
            payCell.button.selected = YES;
            self.indexPath = indexPath;//初始值
            [payCell.button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
            payCell.titlelabel.text = @"微信支付";
            
            return payCell;
            
        }else{
            PayMethodCell * aplayPayCell = [tableView dequeueReusableCellWithIdentifier:@"aplayPayCell" forIndexPath:indexPath];
            aplayPayCell.imageView.image = [UIImage imageNamed:@"zhifubao"];
            [aplayPayCell.button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            aplayPayCell.titlelabel.text = @"支付宝支付";
            return aplayPayCell;
        }
        
//        else{
//            PayMethodCell * goldCell = [tableView dequeueReusableCellWithIdentifier:@"aplayPayCell" forIndexPath:indexPath];
//            goldCell.imageView.image = [UIImage imageNamed:@"kuku"];
//            [goldCell.button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
//            goldCell.titlelabel.hidden = YES;
//            goldCell.companyKuLabel.hidden = NO;
//            goldCell.moneylabel.hidden = NO;
//            if ([_availableBalance integerValue]) {
//                goldCell.moneylabel.text = [NSString stringWithFormat:@"余额：%@元",_availableBalance];
//            }else{
//                goldCell.moneylabel.text = @"余额：0元";
//            }
//            return goldCell;
//        }
        
    }else if (indexPath.section == 1){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"explain"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"explain"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        if (indexPath.row == 0) {//支付说明
            cell.textLabel.text = [NSString stringWithFormat:@"购买金币数量：%1.f个",self.entity.TotalFee];
        }else{
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
            NSString  * myStr = [NSString stringWithFormat:@"支付说明：%@",self.entity.CommoditySubject];
            NSRange range = [myStr rangeOfString: @"支付说明："];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
            [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_BlackColor] range:range];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            cell.textLabel.attributedText = str;
        }
        return cell;
    }else{//最后一个 应付多钱钱
    
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fff"];
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fff"];
        }
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.font = [UIFont systemFontOfSize:24];
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
        NSString  * myStr = [NSString stringWithFormat:@"应支付：%1.f元",self.entity.TotalFee];
        
        NSRange range = [myStr rangeOfString: @"应支付："];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
        [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
        cell.textLabel.attributedText = str;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        PayMethodCell *oldCell = (PayMethodCell*)[tableView cellForRowAtIndexPath:self.indexPath];
        [oldCell.button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
        PayMethodCell *newcell = (PayMethodCell*)[tableView cellForRowAtIndexPath:indexPath];
        [newcell.button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        self.indexPath = indexPath;
    }else{}
}

#pragma marik -- 支付
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    //先给model赋值
    
    if (self.indexPath.section == 0) {
        
        if (self.indexPath.row == 0) {
//            如果安装微信
            if ([WXApi isWXAppInstalled]) {
                self.entity.PayWay = PaymentEngine.PayWays_Wechat;
                [self weixinPayAction];
            }else{
                
                [PublicUseMethod showAlertView:@"您的设备没有安装微信"];
            }
            
        }else if (self.indexPath.row == 1){//支付宝
        
            self.entity.PayWay = PaymentEngine.PayWays_Alipay;
            [self alipayAction];
        }else{//金库
            self.entity.PayWay = PaymentEngine.PayWays_Wallet;
            if ([_availableBalance integerValue] == 0) {
                
                [PublicUseMethod showAlertView:@"企业金库余额不足，请选择其他支付方式"];
            }else{
                [self walletPay];
            }
            
        }
    }
}


#pragma mark -- 金库支付
- (void)walletPay{
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [PaymentRepository createTrade:self.entity success:^(PaymentResult * result) {
//        [weakSelf dismissLoadingIndicator];
        
        if (result.Success) {
            
            [MineDataRequest postWalletPayWithCompanyId:_bossEntity.CompanyId tradeCode:result.TradeCode Success:^(PaymentResult *paymentResult) {
                
                NSLog(@"result==%@",result);
                if (result.Success) {
                    
                    [weakSelf successfulWallet:paymentResult];
                }else{
                
                    [PublicUseMethod showAlertView:paymentResult.ErrorMessage];
                }
                
            } fail:^(NSError *error) {
                [PublicUseMethod showAlertView:error.localizedDescription];
                NSLog(@"error===%@",error);
            }];

        }else{
        
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
 
    } fail:^(NSError * error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
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
    [weakSelf showLoadingIndicator];
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult * result) {
        [weakSelf dismissLoadingIndicator];
        if (result.Success) {
            [PublicUseMethod showAlertView:@"支付成功!"];
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:0.5];
        }
        
    } fail:^(NSError * error) {
        NSLog(@"error:%@",error);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];

}

#pragma mark -- 购买服务 支付宝操作
- (void)alipayAction{
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [PaymentRepository createTrade:self.entity success:^(PaymentResult *result) {
        
        weakSelf.entity.TradeCode = result.TradeCode;
//        [weakSelf dismissLoadingIndicator];
        
        [[AlipaySDK defaultService] payOrder:result.SignedParams fromScheme:AliPayKey callback:^(NSDictionary *resultDic) {
            
            NSLog(@"alipay:%@",resultDic);
            NSString *orderStatus = [resultDic objectForKey:@"resultStatus"];
            
            switch ([orderStatus integerValue]) {
                case 9000:
                {
                    [weakSelf successfulAlipayAction:resultDic];
                }
                    break;
                    
                default:
                {
                    [PublicUseMethod showAlertView:@"貌似出现了一点问题!"];
                    
                }
                    break;
            }
            
        }];
        
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        
        NSLog(@"Alipay fail!%@",error);
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
}


#pragma mark -- 支付宝  支付成功
- (void)successfulAlipayAction:(NSDictionary *)dic{
    NSLog(@"dic:%@",dic);
    
    __weak typeof(self) weakSelf = self;
    PaymentResult *completResult = [[PaymentResult alloc] init];
    completResult.Success = true;
    completResult.PaidDetail = [dic objectForKey:@"result"];
    
    NSLog(@"completResult.PaidDetail===%@",completResult.PaidDetail);
    completResult.TradeCode = self.entity.TradeCode;
    completResult.PayWay = self.entity.PayWay;
    
    NSLog(@"支付模型resultPay:%@",completResult);
    [self showLoadingIndicator];
    
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult *result) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"支付成功 :%@",result);
        
        if (result.Success) {
            [PublicUseMethod showAlertView:@"支付成功!"];
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:0.5];
        }else{
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
    
    
}


#pragma mark -- 微信支付
- (void)weixinPayAction{
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    
    NSLog(@"%@",self.entity);
    
    [PaymentRepository createTrade:self.entity success:^(PaymentResult * result) {
        
//        [weakSelf dismissLoadingIndicator];
        weakSelf.entity.TradeCode = result.TradeCode;
        NSDictionary * dict = [result.SignedParams objectFromJSONString];
        
        
        if (result.Success) {
            PayReq *req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId          = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp          = [[dict objectForKey:@"timestamp"] intValue];
            req.package            = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
        NSLog(@"weixin fail:error===%@!",error.localizedDescription);
    }];
    //
    
}


#pragma mark -- 微信 支付成功
- (void)successfulWXAction{
    __weak typeof(self) weakSelf = self;
    PaymentResult *completResult = [[PaymentResult alloc] init];
    completResult.Success = true;
    completResult.PaidDetail = [NSString stringWithFormat:@"<xml><out_trade_no>%@</out_trade_no></xml>",self.entity.TradeCode];
    
    completResult.TradeCode = self.entity.TradeCode;
    completResult.PayWay = self.entity.PayWay;
    
    NSLog(@"wx支付模型resultPay:%@",completResult);
    [self showLoadingIndicator];
    
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult *result) {
        [weakSelf dismissLoadingIndicator];
        
        if (result.Success) {
            [PublicUseMethod showAlertView:@"支付成功!"];
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:1];
        }else{
        
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"wx-error:%@",error);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
    
}

#pragma mark -- 详情页
- (void)payDetailView:(PaymentResult *)payResult{
    
    NSDictionary *dic;
    //    服务购买成功
    if ([self.entity.PayWay isEqualToString:PaymentEngine.PayWays_Alipay]) {
        dic = @{@"payWay":@"支付宝",@"money":payStr};
        UMBuyBackgoundSuccessEvent(dic);
    }else if ([self.entity.PayWay isEqualToString:PaymentEngine.PayWays_Wechat]){
        dic = @{@"payWay":@"微信",@"money":payStr};
        UMBuyBackgoundSuccessEvent(dic);
    }else{
        dic = @{@"payWay":@"金库",@"money":payStr};
        UMBuyBackgoundSuccessEvent(dic);
    }
    
    BackSurveyBuyDetailVC * oneVC = [[BackSurveyBuyDetailVC alloc]init];
//    oneVC.recordId = [payResult.TargetBizTradeCode longLongValue];
    oneVC.recordIdStr = payResult.TargetBizTradeCode;
    NSLog(@"登录页：self.navigationController====%@",self.navigationController);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:oneVC animated:YES];
    });
    
}
- (void)dealloc{
    
    NSLog(@"支付页面 dello");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
