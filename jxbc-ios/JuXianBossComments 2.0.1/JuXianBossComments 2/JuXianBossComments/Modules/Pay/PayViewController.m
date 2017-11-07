//
//  PayViewController.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "PayViewController.h"
#import "JXPayRequest.h"
#import "PayMethodCell.h"
#import "PaymentResult.h"
//#import "OrderDetailVC.h"
#import "JXAPIs.h"
//#import "WXApiObject.h"
//#import "WXApi.h"
#import "PayDetailViewController.h"
#import "MineAccountViewController.h"
#import "JSONKit.h"
#import "JuXianBossComments-Bridging-Header.h"
#import "PayRemittanceViewController.h"

#import "paySucessVC.h"
#import "ChoiceCompanyCell.h"
#import "UserOpenVipVC.h"
#import "JXOpenServiceWebVC.h"

@interface PayViewController
(){
    
    NSString *payStr;
}

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSString *moneyStr;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)AnonymousAccount * account;

@end

@implementation PayViewController
- (void)dealloc{

    NSLog(@"支付页面 dello");

}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"支付页"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"支付页"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavigationbar];
    _account = [UserAuthentication GetCurrentAccount];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KColor_CellColor;
    NSMutableArray *colorArray2 = [@[[PublicUseMethod setColor:@"DCC37F "],[PublicUseMethod setColor:@"F7E6B9"],[PublicUseMethod setColor:@"AF8F4D "]] mutableCopy];
    
    UIImage * bgImage = [self.payButton buttonImageFromColors:colorArray2 ByGradientType:upleftTolowRight];
    [self.payButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    self.payButton.layer.cornerRadius = 5.0;
    self.payButton.layer.masksToBounds = YES;

    //返回按钮
    //设置支付label的总价
    //如果是服务支付：
    
    payStr = [PublicUseMethod moneyFormatWith:[NSString stringWithFormat:@"%.2f",self.entity.TotalFee]];
    _index = 1;
    __weak typeof(self) weakSelf = self;
//    微信回调 实现
    APPDELEGATE.block = ^{
        [weakSelf successfulWXAction];
    };
    
}

- (void)setUpNavigationbar
{
    self.navigationItem.title = @"支付";
    //设置背景色
    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    [self isShowLeftButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate & UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }
    
    return 3;

}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
    
        if (indexPath.row==0) {// 微信转账
            static NSString *identifier = @"cellid1";
            PayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PayMethodCell" owner:self options:0];
                NSLog(@"%@",nibs);
                cell = (PayMethodCell*)nibs.lastObject;
            }
            cell.titleImageView.image = [UIImage imageNamed:@"weixinzhifu"];
            cell.button.selected = YES;
            
            self.indexPath = indexPath;//初始值
            NSLog(@"indexPath===%@",self.indexPath);
            
            [cell.button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
            cell.titlelabel.text = @"微信支付";
            return cell;
        }else if (indexPath.row == 1){// 支付宝
            static NSString *identifier = @"cellid2";
            PayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"PayMethodCell" owner:self options:0];
                cell = (PayMethodCell*)nibs.lastObject;
            }
            cell.titleImageView.image = [UIImage imageNamed:@"zhifubao"];
            [cell.button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            cell.titlelabel.text = @"支付宝支付";
            return cell;
        }else {// 银行转账
            PayMethodCell* cell = [[[NSBundle mainBundle]loadNibNamed:@"PayMethodCell" owner:self options:0]lastObject];
            cell.titleImageView.image = [UIImage imageNamed:@"公司转账"];
            cell.titlelabel.text = @"银行转账";
            cell.button.width = 20;
            cell.button.height = 20;
            [cell.button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
            return cell;
        }
        
    }else{
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fff"];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fff"];
        }
        // 关闭选中样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"支付金额：%1.f元",self.entity.TotalFee];

        }else if (indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"支付说明：%@",self.entity.CommoditySubject];
        }else{
        
            cell.textLabel.textAlignment = NSTextAlignmentRight;
            cell.textLabel.font = [UIFont systemFontOfSize:21];
            cell.textLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
            NSString  * myStr = [NSString stringWithFormat:@"应支付：%1.f元",self.entity.TotalFee];
            
            NSRange range = [myStr rangeOfString: @"应支付："];
            NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
            [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Text_EumeColor] range:range];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:range];
            cell.textLabel.attributedText = str;

        }
        return cell;
    }
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 39;
    }
    return 10;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        UILabel * lab = [[UILabel alloc] init];
        lab.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        lab.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        lab.font = [UIFont systemFontOfSize:15.0];
        lab.text = @"  请选择支付方式";
        return lab;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PayMethodCell *oldCell = (PayMethodCell*)[tableView cellForRowAtIndexPath:self.indexPath];    
    
    //XJH 8.15 感觉没什么用
//    oldCell.button.selected = NO;
    [oldCell.button setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    
    PayMethodCell *newcell = (PayMethodCell*)[tableView cellForRowAtIndexPath:indexPath];

    newcell.button.selected = YES;
    [newcell.button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    self.indexPath = indexPath;
    
}

- (IBAction)payButtonAction:(id)sender {
    
    if (self.indexPath.row ==0) {
//        如果安装微信
        if ([WXApi isWXAppInstalled]) {
            self.entity.PayWay = PaymentEngine.PayWays_Wechat;
            [self weixinPayAction];
        }else{
        
            [PublicUseMethod showAlertView:@"您的设备没有安装微信"];
        }
        
    }else if(self.indexPath.row == 1){
        // 支付宝
        self.entity.PayWay = PaymentEngine.PayWays_Alipay;
        [self alipayAction];
    }else{
        // 银行转账
        // 跳转
        PayRemittanceViewController* remVc = [[PayRemittanceViewController alloc]init];
        [self.navigationController pushViewController:remVc animated:YES];
        
    }

}

#pragma mark -- 购买服务 支付宝操作
- (void)alipayAction{
    
    __weak typeof(self) weakSelf = self;
    
    [self showLoadingIndicator];
    
    [PaymentRepository createTrade:self.entity success:^(PaymentResult *result) {
        
        weakSelf.entity.TradeCode = result.TradeCode;
        [weakSelf dismissLoadingIndicator];
        
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
        [PublicUseMethod showAlertView:error.localizedDescription];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];


}

#pragma mark -- 微信支付
- (void)weixinPayAction{
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    
    NSLog(@"%@",self.entity);
    [PaymentRepository createTrade:self.entity success:^(PaymentResult * result) {
        [weakSelf dismissLoadingIndicator];
        
        if (result.Success > 0) {
            
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
        }else{
        
            [PublicUseMethod showAlertView:result.ErrorMessage];
        
        }

    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
        [PublicUseMethod showAlertView:error.localizedDescription];
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
        NSLog(@"支付成功 :%@",result);
        [weakSelf dismissLoadingIndicator];

        if (result.Success) {
            [PublicUseMethod showAlertView:@"支付成功!"];
            
            if ([self.secondVC isKindOfClass:[UserOpenVipVC class]] || [self.secondVC isKindOfClass:[JXOpenServiceWebVC class]]) {
                
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:result.TargetBizTradeCode forKey:CompanyChoiceKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:0.5];
            
        }else{
            
             [PublicUseMethod showAlertView:result.ErrorMessage];
        }
     
        
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
    

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
        NSLog(@"wx-支付成功 :%@",result);
            [weakSelf dismissLoadingIndicator];
        if (result.Success) {
            
            [PublicUseMethod showAlertView:@"支付成功!"];
            
            if ([self.secondVC isKindOfClass:[UserOpenVipVC class]] || [self.secondVC isKindOfClass:[JXOpenServiceWebVC class]]) {
                
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:result.TargetBizTradeCode forKey:CompanyChoiceKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:1];
        }else{
            
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }

    } fail:^(NSError *error) {
        NSLog(@"wx-error:%@",error);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
        [PublicUseMethod showAlertView:error.localizedDescription];
//        [weakSelf performSelector:@selector(payDetailView) withObject:nil afterDelay:1];
    }];

}

#pragma mark -- 详情页
- (void)payDetailView:(PaymentResult *)payResult{
    NSDictionary *dic;
//    服务购买成功
        if ([self.entity.PayWay isEqualToString:PaymentEngine.PayWays_Alipay]) {
            dic = @{@"payWay":@"支付宝",@"money":payStr};
        }else{
            dic = @{@"payWay":@"微信",@"money":payStr};
        }
        paySucessVC * oneVC = [[paySucessVC alloc]init];
        oneVC.secondVC = self.secondVC;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self.secondVC isKindOfClass:[UserOpenVipVC class]] || [self.secondVC isKindOfClass:[JXOpenServiceWebVC class]]) {
            
            [self.navigationController pushViewController:oneVC animated:YES];
        }else{
            [PublicUseMethod changeRootNavController:oneVC];
        }
        
    });
    
}

#pragma mark - 购买服务-——————————————————————获取支付宝参数 请求支付宝服务器
- (void)AlipayWithproductId:(NSNumber*)productId withProductType:(NSNumber*)productType withBizType:(NSString*)bizType withNumber:(NSNumber*)num withPayMethod:(NSString*)interfaceCode
{
    
   //@"BuyProduct"
    [JXPayRequest getPaymentParamsWithA:interfaceCode withB:productId withC:num withD:productType withE:bizType Success:^(id result) {
        NSString *str = (NSString*)result;
        NSString *payParameters = [str stringByReplacingOccurrencesOfString:@"*" withString:@"\"" options:1 range:[str rangeOfString:str]];
//        NSString *appScheme = @"juxianlingapp";//bosscommentsapp
        
        NSString *appScheme = @"bosscommentsapp";
        
        [[AlipaySDK defaultService]payOrder:payParameters fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            
            if ([resultDic[@"resultStatus"]integerValue]== 6001) {
                
            }else
            {
                NSLog(@"支付成功");
                NSLog(@"%ld",self.navigationController.viewControllers.count);
                
                //结果回传 服务器
                NSString *result = resultDic[@"result"];
                NSString *parameter = [result stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:0 range:[result rangeOfString:result]];
                NSString *urlStr = [self getURlStringWith:parameter];
                NSLog(@"%@",API_Payment_MobileAlipayPaymentSynNotify(urlStr));
                [JXPayRequest postalipayCallBack:urlStr success:^(id result) {
                    //这应该是真正的支付成功
                    NSLog(@"%@",result);
                    
                    MineAccountViewController * mineVC = [[MineAccountViewController alloc] init];
                    [self.navigationController pushViewController:mineVC animated:YES];

                    
                } fail:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
                
                NSLog(@"支付成功");
            }
            
            
        }];
        
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];


}

#pragma mark - 打赏——————————————获取支付宝参数 请求支付宝服务器

//url编码//支付成功回传的结果进行编码
- (NSString*)getURlStringWith:(NSString*)String
{
    NSString *params = [NSString string];
    
    NSArray *array = [String componentsSeparatedByString:@"&"];
    for (NSString *pair in array) {
        NSArray *subArray = [pair componentsSeparatedByString:@"="];
        params = [params stringByAppendingString:subArray.firstObject];
        params = [params stringByAppendingString:@"="];
        NSString *value = [NSString string];
        
        value = [pair substringFromIndex:[subArray.firstObject length]+1];
        value = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                     (CFStringRef)value, nil,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        // */
        params = [params stringByAppendingString:value];
        params = [params stringByAppendingString:@"&"];
    }
    return [params substringToIndex:[params length]-1];
}
#pragma mark - 子类可以重写
- (void)clearSelf:(NSNotification*)noti
{
    self.view = nil;
   
}

   
@end
