//
//  XJHPayDk.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "XJHPayDk.h"

@implementation XJHPayDk
@synthesize resultDic = _resultDic;

- (NSDictionary *)alipayActionWith:(PaymentEntity *)model{
    
    __weak typeof(self) weakSelf = self;
    // 签名
    [PaymentRepository createTrade:model success:^(PaymentResult *result) {
        weakSelf.entity.TradeCode = result.TradeCode;
        
        [[AlipaySDK defaultService] payOrder:result.SignedParams fromScheme:AliPayKey callback:^(NSDictionary *resultDic) {
            _resultDic = resultDic;
        }];
    } fail:^(NSError *error) {
        NSLog(@"Alipay fail!%@",error.localizedDescription);
        [PublicUseMethod showAlertView:@"网络繁忙..."];
    }];
    return _resultDic;
}

- (void)successfulAlipayAction:(NSDictionary *)dic{
    //校验支付返回结果
        NSLog(@"dic:%@",dic);
        PaymentResult *completResult = [[PaymentResult alloc] init];
        completResult.Success = true;
        completResult.PaidDetail = [dic objectForKey:@"result"];
        completResult.TradeCode = self.entity.TradeCode;
        completResult.PayWay = self.entity.PayWay;
        NSLog(@"支付模型resultPay:%@",completResult);
    
        [PaymentRepository paymentCompleted:completResult success:^(PaymentResult *result) {
            NSLog(@"支付成功 :%@",result);
            [PublicUseMethod showAlertView:@"支付成功!"];
            
        } fail:^(NSError *error) {
            NSLog(@"error:%@",error);
            [PublicUseMethod showAlertView:@"网络繁忙..."];
        }];

}

@end
