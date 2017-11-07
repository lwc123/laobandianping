
//
//  SignInMemberPublic.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/11.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SignInMemberPublic.h"
#import "ChoiceCompanyVC.h"
#import "OpenCommentVC.h"
#import "PublicUseMethod.h"
#import "BossCommentTabBarCtr.h"
#import "ProveOneViewController.h"
#import "CompanyMembeEntity.h"
#import "CompanyModel.h"
#import "ChoiceIdentityVC.h"
#import "JXUserTabBarCtrVC.h"

@interface SignInMemberPublic ()<UIAlertViewDelegate>

@property (nonatomic, assign) long companyId;

@end

@implementation SignInMemberPublic
+ (instancetype)sharedInstance{

    static SignInMemberPublic *signInMemberPublic ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!signInMemberPublic) {
            signInMemberPublic = [[SignInMemberPublic alloc]init];

        }
    });
    
    return signInMemberPublic;
    
}

+ (void)SignInWithCompanyId:(long)companyId{
    
    SignInMemberPublic* signInMemberPublic = [SignInMemberPublic sharedInstance];
    signInMemberPublic.companyId = companyId;

    [MineDataRequest InformationWithSuccess:^(JSONModelArray *array) {
        if ([array isKindOfClass:[NSNull class]]) {
            OpenCommentVC * openCommentVC= [[OpenCommentVC alloc] init];
            [PublicUseMethod changeRootNavController:openCommentVC];
        }else{
        
            CompanyModel *compModel;
            for (CompanyMembeEntity *model in array) {
                compModel = model.myCompany;
            }
            
            if (companyId > 0) {
                for (CompanyMembeEntity *model in array) {
                    compModel = model.myCompany;
                    if (companyId == model.CompanyId) {
                        [self isAuditStatus: compModel];
                    }
                }
            }else{
                if (array.count == 0) {//判断有几个企业 0 -> 就去开户
                    OpenCommentVC * openCommentVC= [[OpenCommentVC alloc] init];
                    [PublicUseMethod changeRootNavController:openCommentVC];
                }
                if (array.count == 1) {// 1 (认证被拒绝 重新认证  认证通过或是认证中 进入工作台)
                    [self isAuditStatus:compModel];
                }
                if (array.count > 1) {//多个 就要选择公司
                    ChoiceCompanyVC * choiceVC = [[ChoiceCompanyVC alloc] init];
                    choiceVC.inforArray = array.copy;
                    choiceVC.currentProfile = 2;
                    [PublicUseMethod changeRootNavController:choiceVC];
                }
            }
        }
    } fail:^(NSError *error) {
        
        // 请求超时 提示失败 重新加载
        if (error.code == -1001) { // 请求超时
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络链接超时,请稍后再试" delegate:signInMemberPublic cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
            [alert show];
            
        }else if (error.code == -1009) {         // 没有网络 提示失败 重新加载

            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络好像断开了,请检查网络设置" delegate:signInMemberPublic cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
            [alert show];
            
        }else{
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:signInMemberPublic cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
            [alert show];

        }
    }];
}

- (void)reloadWithCompanyId:(long)companyId{
    [SignInMemberPublic SignInWithCompanyId:companyId];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [[SignInMemberPublic sharedInstance] reloadWithCompanyId:[SignInMemberPublic sharedInstance].companyId];
    
}


+ (void)SignInLoginWithAccount:(AnonymousAccount *) account{
    
    

    if (account.UserProfile.CurrentProfileType == UserProfile || account.MultipleProfiles == 1) {//当前是个人
        [PublicUseMethod goViewController:[JXUserTabBarCtrVC class]];
    }else{//企业
        [SignInMemberPublic SignInWithCompanyId:0];
    }   
}

+ (void)isAuditStatus:(CompanyModel *)compModel{
    
    if (compModel.AuditStatus == 1 || compModel.AuditStatus == 2) {
        
        NSString  * companyStr = [NSString stringWithFormat:@"%ld",compModel.CompanyId];
        [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:CompanyChoiceKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
        return;
    }
    if (compModel.AuditStatus == 0 || compModel.AuditStatus == 9) {
        NSString  * companyStr = [NSString stringWithFormat:@"%ld",compModel.CompanyId];
        [[NSUserDefaults standardUserDefaults] setObject:companyStr forKey:CompanyChoiceKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //保存企业名称
        [[NSUserDefaults standardUserDefaults] setObject:compModel.CompanyName forKey:CompanyNameKey];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        ProveOneViewController * proveoneVC= [[ProveOneViewController alloc] init];
        proveoneVC.companyModel = compModel;
        [PublicUseMethod changeRootNavController:proveoneVC];
        return;
    }
}

+ (NSInteger)isApplePayWithBizSource:(NSString *)bizSource{
    
   __block NSInteger applepay;
    [MineDataRequest getPaywaysForAppleWithBizSource:bizSource success:^(id result) {
        if ([result isKindOfClass:[NSNull class]]) {
            return ;
        }else{
            
            if ([result containsObject:@"AppleIAP"]) {
                applepay = 2;
            }else{
                applepay = 1;
            }
        }
    } fail:^(NSError *error) {
        [SignInMemberPublic createNewFail:error ];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    return applepay;
}

//传递设备信息失败
+(void)createNewFail:(NSError *)error
{
    // 请求超时 提示失败 重新加载
    if (error.code == -1001) { // 请求超时
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络链接超时,请稍后再试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        
    }else if (error.code == -1009) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"网络好像断开了,请检查网络设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:self cancelButtonTitle:nil otherButtonTitles:@"重试", nil];
        [alert show];
    }
    
}

#pragma mark - 重新加载
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [SignInMemberPublic isApplePayWithBizSource:PaymentEngine.BizSources_RenewalEnterpriseService];
}

@end
