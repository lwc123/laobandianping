//
//  JHOneCheckViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHOneCheckViewController.h"
#import "JHCheckCompanyVC.h"


@interface JHOneCheckViewController ()



@end

@implementation JHOneCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//http://gsxt.saic.gov.cn/
    
    [self initRequset];

    
}

- (void)initRequset{


    //网络请求管理的类
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //如果不写这个方法 会自动解析,有解析的功能
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * url = @"http://gsxt.saic.gov.cn/";
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject===%@",responseObject);
        NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"str===%@",str);
        
        //        [self analysisData:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error===%@",error.localizedDescription);
        
    }];
    

}


- (IBAction)beijingClick:(id)sender {
    //http://gsxt.saic.gov.cn/
    
    JHCheckCompanyVC * checkVC = [[JHCheckCompanyVC alloc] init];
    [self.navigationController pushViewController:checkVC animated:YES];
}

- (IBAction)tianJianClick:(id)sender {
    
}

- (IBAction)heBeiClcik:(id)sender {
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}


@end
