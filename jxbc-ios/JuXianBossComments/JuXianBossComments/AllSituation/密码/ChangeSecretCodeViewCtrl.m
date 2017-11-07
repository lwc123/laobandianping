//
//  ChangeSecretCodeViewCtrl.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/14.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "ChangeSecretCodeViewCtrl.h"
#import "AccountRepository.h"
#import "AccountSign.h"
#import "AccountSignResult.h"
#import "LoginViewController.h"
#import "BossCommentTabBarCtr.h"
@interface ChangeSecretCodeViewCtrl ()<UITextFieldDelegate>
{
    dispatch_source_t _timer;
    
}
@end

@implementation ChangeSecretCodeViewCtrl
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self sendEnsureCode];
    [self setUpNaviBar];
    [self setUpSubViews];
    [self.getCodeButton setTitle:@"获取" forState:UIControlStateNormal];
    self.getCodeButton.userInteractionEnabled = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)setUpNaviBar
{
    [self isShowLeftButton:YES];
    self.navigationItem.title = @"修改密码";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    
}
- (void)setUpSubViews
{
    
    self.change_Btn.layer.masksToBounds = YES;
    self.change_Btn.layer.cornerRadius = 4;
    self.change_Btn.layer.borderWidth = 2;
    self.change_Btn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;

    self.getCodeButton.layer.cornerRadius = 4;
    self.getCodeButton.layer.masksToBounds = YES;
    self.getCodeButton.layer.borderWidth = 2;
    self.getCodeButton.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
    
    
    self.textField_Phone.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.textField_Phone.delegate = self;
    
    self.textField_Pwd.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.textField_Pwd.delegate = self;
    
    self.textField_EnsureCode.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.textField_EnsureCode.delegate = self;
    self.sendNumLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.sendNumLabel.text = [NSString stringWithFormat:@"验证码已发送至手机+86%@",self.textField_Phone.text];
    

}


#pragma mark - 获取验证码
- (void)sendEnsureCode
{//[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]
    __weak typeof(self) weakSelf = self;
    //判断是否已经注册
    [AccountRepository isExistsMobilePhone:self.textField_Phone.text success:^(id result)
     {
//         [weakSelf dismissLoadingIndicator];
         if ([result integerValue] == 1) {
             
             [weakSelf accountCode];
         }else{
             
             [PublicUseMethod showAlertView:@"未注册，请先注册账号"];
         }

     } fail:^(NSError *error)
     {
//         [weakSelf dismissLoadingIndicator];
         NSLog(@"error :%@",error);
         [weakSelf accountCode];
         return;
     }];
    
//    [AccountRepository signUpSendGetCode:self.textField_Phone.text success:^(id result) {
//        if (result) {
//            //停止计时
//            
//            [SVProgressHUD showInfoWithStatus:@"发送成功"];
//            
//        }
//    } fail:^(NSError *error) {
//        
//    }];
//    //把按钮改变倒计时
//    [self startTime];
}

- (void)accountCode{

    [AccountRepository signUpSendGetCode:self.textField_Phone.text success:^(id result) {
        
        [SVProgressHUD showInfoWithStatus:@"发送成功"];

        if (result) {
            //停止计时

            [self startTime];
        }
    } fail:^(NSError *error) {
        
        
    }];
    //把按钮改变倒计时
//    [self startTime];


}

#pragma 按钮只点击一次方法
-(void)startTime
{
    __block int timeout=120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            [self endTimer];
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout %121;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"获取%@s",strTime] forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


- (void)endTimer
{
    dispatch_source_cancel(_timer);
    dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        [self.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getCodeButton.userInteractionEnabled = YES;
    });
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField_EnsureCode)
    {
        //        if (range.location >= 6)
        //        {
        //            [self endTimer];
        //            return NO;
        //        }
    }
    if (textField == self.textField_Pwd)
    {
        if (range.location >= 20)
        {
            return NO;
        }
    }
    
    
    if (textField == self.textField_Phone) {
        if (range.location >= 11) {
            
            self.change_Btn.backgroundColor = [PublicUseMethod setColor:KColor_SubColor];
            return NO;
            
        }
        
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ChangeAction:(id)sender {
    UIButton *button =(UIButton*)sender;
    
    
    self.textField_Phone.text = [self.textField_Phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.textField_EnsureCode.text = [self.textField_EnsureCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
     self.textField_Pwd.text = [self.textField_Pwd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.textField_Phone.text isEqualToString:@""]) {
        
        [PublicUseMethod showAlertView:@"手机号不能为空"];
        button.userInteractionEnabled = NO;
        return;
    }
    if (self.textField_Phone.text.length < 10) {
        
        [PublicUseMethod showAlertView:@"请输入正确的手机号"];
        button.userInteractionEnabled = NO;
        return;
    }
    if (![PublicUseMethod isMobileNumber:self.textField_Phone.text]) {
        
        [PublicUseMethod showAlertView:@"手机号输入不合法"];
        button.userInteractionEnabled = NO;
        return;
    }
    
    if ([self.textField_EnsureCode.text isEqualToString:@""])
    {
        [PublicUseMethod showAlertView:@"验证码不能为空"];
        button.userInteractionEnabled = NO;
        return;
    }
    if ([self.textField_Pwd.text isEqualToString:@""])
    {
        [PublicUseMethod showAlertView:@"密码不能为空"];
        button.userInteractionEnabled = NO;
        return;
    }
    AccountSign *sign = [[AccountSign alloc]init];
    sign.Password = self.textField_Pwd.text;
    sign.MobilePhone = self.textField_Phone.text;
    sign.ValidationCode = self.textField_EnsureCode.text;
    //修改密码
    [self showLoadingIndicator];
    [AccountRepository ChangePassWordWith:sign success:^(AccountSignResult *result) {
        [self dismissLoadingIndicator];
        NSLog(@"%@",result);
        
        if (result.SignStatus==1) {
            //修改成功
            [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LoginViewController *loginVC = [[LoginViewController alloc]init];
                loginVC.secondVC = _secondVC;
                
                [self.navigationController pushViewController:loginVC animated:YES];
            });
            
        }else
        {
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];

        NSLog(@"===error%@",error);
        NSLog(@"%@",error.localizedDescription);
        [SVProgressHUD showInfoWithStatus:@"密码设置失败，稍后再试"];
    }];
}

- (IBAction)getCodeAction:(UIButton *)btn {
    
    
    if (self.textField_Phone.text.length < 11) {
        
        [PublicUseMethod showAlertView:@"输入的手机号小于11位,"];
        btn.enabled = NO;
        btn.enabled = YES;
        return;
    }
    
    [self sendEnsureCode];
}
@end
