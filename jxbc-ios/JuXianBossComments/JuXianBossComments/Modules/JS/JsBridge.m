//
//  JsBridge.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JsBridge.h"
#import "PayViewController.h"
#import "ExamineBackdropVC.h"
//修改记录
#import "JXFixRecordVC.h"
#import "BuyReportVaultVC.h"
#import "AppleOpenServiceVC.h"
#import "SignInMemberPublic.h"

@implementation JsBridge{

    AnonymousAccount *_account;
    CompanyMembeEntity * _bossEntity;
}

- (id)initWithVC:(UIViewController*)VC;
{
    self = [super init];
    if (self) {
        self.viewcontroller = VC;
    }
    return self;
}


+ (void)initForWebView:(UIWebView*)webView with:(UIViewController*)vc
{
    vc.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    JsBridge *jsBridge = [[JsBridge alloc]initWithVC:vc];
    
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 2. 关联打印异常(次要)
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"异常信息：%@", exceptionValue);
    };
    jsContext[@"AppBridge"] = jsBridge;
    
}

- (void)gotoNativePageWith:(NSString *)pageName with:(NSString *)pageParams
{
    NSLog(@"gotoNativePage(pageName===%@, %@)", pageName, pageParams);
    if ([pageName hasPrefix:@"ShowSearchButton"]) {
        [self gotoSearchePage:pageName with:pageParams];
        return;
    }
    
    if ([pageName hasPrefix:@"BuyBackgroundSurvey"]) {
        [self gotoPayPage:pageName with:pageParams];
        return;
    }
    
    if ([pageName hasPrefix:@"CommentChangedHistory"]) {
        
        [self gotoChangedHistoryPage:pageName with:pageParams];
        return;
    }
    if ([pageName hasPrefix:@"RenewalEnterpriseService"]) {
        [self gotoRenewalEnterpriseServicePage:pageName with:pageParams];

        return;
    }
    
}

#pragma mark -- 修改记录
- (void)gotoChangedHistoryPage:(NSString *)pageName with:(NSString *)pageParams {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        JXFixRecordVC * recodeVC = [[JXFixRecordVC alloc] init];
        recodeVC.commentId = [pageParams longLongValue];
        [self.viewcontroller.navigationController pushViewController:recodeVC animated:YES];
    });
}


#pragma mark -- 续费
- (void)gotoRenewalEnterpriseServicePage:(NSString *)pageName with:(NSString *)pageParams {

    dispatch_async(dispatch_get_main_queue(), ^{
        
        JSONModelError* error = nil;
        PaymentEntity *entity = [[PaymentEntity alloc] initWithString:pageParams error:&error];
        PayViewController * payVC = [[PayViewController alloc] init];
        payVC.entity = entity;
        payVC.secondVC = self.viewcontroller;
        AppleOpenServiceVC * openVC = [[AppleOpenServiceVC alloc] init];
        openVC.entity = entity;
        openVC.secondP = self.viewcontroller;
//        NSInteger applePay;
//       applePay = [SignInMemberPublic isApplePayWithBizSource:entity.BizSource];
        [MineDataRequest getPaywaysForAppleWithBizSource:entity.BizSource success:^(id result) {
            if ([result isKindOfClass:[NSNull class]]) {
                return ;
            }else{
                if ([result containsObject:@"AppleIAP"]) {
                    [self.viewcontroller.navigationController pushViewController:openVC animated:YES];
                }else{
                    [self.viewcontroller.navigationController pushViewController:payVC animated:YES];
                }
            }
        } fail:^(NSError *error) {
            [PublicUseMethod showAlertView:error.localizedDescription];
        }];
        
//        [MineDataRequest getPaywaysForAppleTextWithBizSource:entity.BizSource success:^(id result) {
//            if ([result containsObject:@"AppleIAP"]) {//苹果内购
//                [self.viewcontroller.navigationController pushViewController:openVC animated:YES];
//            }else{
//                [self.viewcontroller.navigationController pushViewController:payVC animated:YES];
//            }
//        } fail:^(NSError *error) {
//            [PublicUseMethod showAlertView:error.localizedDescription];
//        }];
        
        
        
    });
}

//背景调查 -- 搜索btn
- (void)gotoSearchePage:(NSString *)pageName with:(NSString *)pageParams {

      dispatch_async(dispatch_get_main_queue(), ^{
            _bossEntity = [UserAuthentication GetBossInformation];
            ExamineBackdropVC * examineVC = self.viewcontroller.navigationController.viewControllers[1];
             bool isShow = [pageParams isEqualToString:@"true"];
            if (isShow) {//显示
                examineVC.button.hidden = NO;
            }else{
                examineVC.button.hidden = YES;
            }
    });
}

//购买背景调查
- (void)gotoPayPage:(NSString *)pageName with:(NSString *)pageParams {
    dispatch_async(dispatch_get_main_queue(), ^{

        _bossEntity = [UserAuthentication GetBossInformation];
        JSONModelError* error = nil;
        PaymentEntity *entity = [[PaymentEntity alloc] initWithString:pageParams error:&error];
        
        BuyReportVaultVC * vaultVC = [[BuyReportVaultVC alloc] init];
        vaultVC.entity = entity;
        [self.viewcontroller.navigationController pushViewController:vaultVC animated:YES];
    });
}


- (NSString *)getAppInfo;
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"DeviceKey"] forKey:@"device"];
    [dic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:@"AccessToken"] forKey:@"token"];
    
    NSString *str = [NSString string];
    str = [self DataTOjsonString:dic];
    NSLog(@"token=%@", str);
    return str;
}



-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

//讲jsonString  装成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}




@end














