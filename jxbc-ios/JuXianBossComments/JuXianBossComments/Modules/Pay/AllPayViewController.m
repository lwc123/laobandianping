//
//  AllPayViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/8.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AllPayViewController.h"

@interface AllPayViewController ()
@property (nonatomic,strong)PaymentEntity *entity;
@end

@implementation AllPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self alipayActionWith:];
}

- (void)alipayActionWith:(PaymentEntity *)model{

    __weak typeof(self) weakSelf = self;
    // 签名
    [PaymentRepository createTrade:model success:^(PaymentResult *result) {
        
        weakSelf.entity.TradeCode = result.TradeCode;
        
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
//        [weakSelf dismissLoadingIndicator];
        
        NSLog(@"Alipay fail!%@",error.localizedDescription);
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];

}

//校验支付返回结果
- (void)successfulAlipayAction:(NSDictionary *)dic{
    NSLog(@"dic:%@",dic);
    __weak typeof(self) weakSelf = self;
    PaymentResult *completResult = [[PaymentResult alloc] init];
    completResult.Success = true;
    completResult.PaidDetail = [dic objectForKey:@"result"];
    completResult.TradeCode = self.entity.TradeCode;
    completResult.PayWay = self.entity.PayWay;
    NSLog(@"支付模型resultPay:%@",completResult);
    [self showLoadingIndicator];
    
    [PaymentRepository paymentCompleted:completResult success:^(PaymentResult *result) {
        NSLog(@"支付成功 :%@",result);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"支付成功!"];
//        [weakSelf performSelector:@selector(payDetailView:) withObject:result afterDelay:1];
        
    } fail:^(NSError *error) {
        NSLog(@"error:%@",error);
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
