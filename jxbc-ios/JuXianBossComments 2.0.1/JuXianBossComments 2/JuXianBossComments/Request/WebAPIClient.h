//
//  WebAPIClient.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/11.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface WebAPIClient : NSObject


+ (void)netWorkStatus;

+ (AFHTTPSessionManager*)CreateOperationManager;
//get方法
+ (void)getJSONWithUrl:(NSString *)path parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;
/// 4.post提交json数据
+ (void)postJSONWithUrl:(NSString *)path parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;

@end
