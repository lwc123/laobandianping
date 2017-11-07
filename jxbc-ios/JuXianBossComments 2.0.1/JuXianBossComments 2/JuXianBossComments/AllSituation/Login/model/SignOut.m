//
//  SignOut.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "SignOut.h"

@implementation SignOut

+ (void)signOutAccountWith:(UIButton *)btn{

//    JXBasedViewController * base = [[JXBasedViewController alloc] init];
//    [base showLoadingIndicator];
    [AccountRepository signOut: ^(id result) {
//        [base dismissLoadingIndicator];
        AccountSignResult *resultEntity = result;

        if (resultEntity.SignStatus == 1) {
            [UserAuthentication removeCurrentAccount];
            NSUserDefaults *current = [NSUserDefaults standardUserDefaults];
            [current removeObjectForKey:@"currentIdentity"];
            [current synchronize];
            
            NSUserDefaults *companyCurrent = [NSUserDefaults standardUserDefaults];
            [companyCurrent removeObjectForKey:CompanyChoiceKey];
            [companyCurrent synchronize];

            
            NSString * userProfilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"userProfile.data"];
            NSFileManager * userProfileFileManager = [[NSFileManager alloc]init];
            [userProfileFileManager removeItemAtPath:userProfilePath error:nil];
            NSString * passwordStr = [[NSUserDefaults standardUserDefaults] valueForKey:RealyPasswordStr];
            if (passwordStr == nil) {
                LandingPageViewController * landPageVC = [[LandingPageViewController alloc] init];
                [PublicUseMethod changeRootNavController:landPageVC];
            }else{
            
                [SignOut signIn];
            }
        }
        else
        {
            btn.enabled = YES;
            [PublicUseMethod showAlertView:resultEntity.ErrorMessage];
            LandingPageViewController * landPageVC = [[LandingPageViewController alloc] init];
            [PublicUseMethod changeRootNavController:landPageVC];
        }
    } fail:^(NSError *error) {
//        [base dismissLoadingIndicator];
        btn.enabled = YES;
        btn.backgroundColor = [PublicUseMethod setColor:KColor_RedColor];
        [SignOut createNewFails:error];
        
    }];

}

+ (void)signIn{

    NSString * phoneStr = [[NSUserDefaults standardUserDefaults] valueForKey:RealyPhoneNum];
    NSString * passwordStr = [[NSUserDefaults standardUserDefaults] valueForKey:RealyPasswordStr];
    
    [AccountRepository signIn:phoneStr password:passwordStr success:^(AccountSignResult *result, NSString *platformAccountId, NSString *platformAccountPassword) {
        
        if(result.SignStatus == 1){
            
            [SignOut signInSuccess:result];
        }else{
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError *error) {
        [SignOut signInFail:error];
    }];
    
    
}

+ (void)signInSuccess:(AccountSignResult *)result{

    if (result.SignStatus == 1)
    {
        //选择身份
        [SignInMemberPublic SignInLoginWithAccount:result.Account];
    }else{
        [SVProgressHUD showSuccessWithStatus:result.ErrorMessage];
        return;
    }
}

//失败
+ (void)signInFail:(NSError *)error
{
    Log(@"登录失败:error===%@",error.localizedDescription);
    if (error.code == -1001) { // 请求超时
        [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
    }else if (error.code == -1009) {// 没有网络
        [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
    }else{// 其他
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }
    
}

//传递设备信息失败
+(void)createNewFails:(NSError *)error
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


@end
