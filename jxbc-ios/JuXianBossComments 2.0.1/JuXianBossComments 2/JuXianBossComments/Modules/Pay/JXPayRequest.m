//
//  JXPayRequest.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXPayRequest.h"

@implementation JXPayRequest
//获取支付方式
+ (void)getPaymentMethodWithSuccess:(void (^)(id result))success fail:(void(^)(NSError*error))fail;
{
   [WebAPIClient getJSONWithUrl:API_Payment_getPaymentMethod parameters:nil success:^(id result) {
       if (![result isKindOfClass:[NSNull class]]) {
           success (result);
       }
       else
       {
           [PublicUseMethod showAlertView:@"未获取支付方式"];
       }
   } fail:^(NSError *error) {
       fail(error);
   }];
}
//购买服务----
+ (void)getPaymentParamsWithA:(NSString*)a withB:(NSNumber*)b withC:(NSNumber*)c withD:(NSNumber*)d withE:(NSString*)e Success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;
{
        [WebAPIClient postJSONWithUrl:ApI_Payment_GetPaymentParams(a, b, c, d,e) parameters:nil success:^(id result) {
        if (![result isKindOfClass:[NSNull class]]) {
            success (result);
        }
        else
        {
            [PublicUseMethod showAlertView:@"支付参数未获取"];
        }
        
    } fail:^(NSError *error) {
        fail (error);
    }];

}


//支付成功 发送POST请求到服务器
+  (void)postalipayCallBack:(NSString*)string success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;
{
 [WebAPIClient postJSONWithUrl:API_Payment_MobileAlipayPaymentSynNotify(string) parameters:nil success:^(id result) {
     success(result);
     //注册通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"Notification" object:nil];
     
     
 } fail:^(NSError *error) {
     fail(error);
 }];
}


- (void)notificationAction:(NSNotification *)noti{
    NSLog(@"收到通知了");

}


@end
