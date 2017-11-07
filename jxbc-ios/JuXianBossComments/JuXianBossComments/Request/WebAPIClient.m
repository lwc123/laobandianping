//
//  WebAPIClient.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/11.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "WebAPIClient.h"
#import "ApiEnvironment.h"
#import "AppDelegate.h"

@implementation WebAPIClient{


    AFHTTPSessionManager * _manager;

}

/// 1.检测网络状态
+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
         delegate.netStatus = status;
     }];
    
}



+ (void)getJSONWithUrl:(NSString *)path parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [self CreateOperationManager];
    
    //拼接请求URL路径
    NSString *absolute_Path = path;
    if(![path hasPrefix:@"http"]) {
        absolute_Path = [NSString stringWithFormat:@"%@%@", API_HOST_API_Appbase, path];
    }
    
    absolute_Path = [absolute_Path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [manager GET:absolute_Path parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSLog(@"Request:%@, [GET]URL:%@", @"Succcess", absolute_Path);
         if (success)
         {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Request:%@, [GET]URL:%@  Error:%ld %@", @"Fail", absolute_Path,(long)error.code, error.localizedDescription);
         if (fail) {
             fail(error);
         }
     }];
    
    
}

+ (void)postJSONWithUrl:(NSString *)path parameters:(id)parameters success:(void (^)(id result))success fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [self CreateOperationManager];
    
    NSString *absolute_Path = path;
    if(![path hasPrefix:@"http"])
    {
        absolute_Path = [NSString stringWithFormat:@"%@%@", API_HOST_API_Appbase, path];
    }
    
    [manager POST:absolute_Path parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"Request:%@, [POST]URL:%@", @"Succcess", absolute_Path);
        if (success)
        {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Request:%@, [POST]URL:%@", @"Fail", absolute_Path);
        NSLog(@"error===%@",error.localizedDescription);
        if (fail)
        {
            fail(error);
        }
    }];
}
//#warning 附加的请求头。。。。。。。。。。
+ (AFHTTPSessionManager*)CreateOperationManager
{
    AFHTTPSessionManager *manager = [WebAPIClient shareWebApiclient];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 24;
    
    // 设置返回格式
    manager.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.responseSerializer.acceptableContentTypes  = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    //设置请求头
    NSString *AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    NSString *DeviceKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceKey"];
    
    [manager.requestSerializer setValue:DeviceKey forHTTPHeaderField:@"DeviceKey"];
    [manager.requestSerializer setValue:AccessToken forHTTPHeaderField:@"JX-TOKEN"];
    
    return manager;
}

+ (AFHTTPSessionManager *)shareWebApiclient
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return manager;
}



@end
