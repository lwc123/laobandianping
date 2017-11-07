//
//  JXPayRequest.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/1.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebAPIClient.h"
@interface JXPayRequest : NSObject
//获取支付方式
+ (void)getPaymentMethodWithSuccess:(void (^)(id result))success fail:(void(^)(NSError*error))fail;
//获取支付参数 购买服务
+ (void)getPaymentParamsWithA:(NSString*)a withB:(NSNumber*)b withC:(NSNumber*)c withD:(NSNumber*)d withE:(NSString*)e Success:(void (^)(id result))seuccss fail:(void (^)(NSError *error))fail;
//支付成功 发送POST请求到服务器
+  (void)postalipayCallBack:(NSString*)string success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;


@end
