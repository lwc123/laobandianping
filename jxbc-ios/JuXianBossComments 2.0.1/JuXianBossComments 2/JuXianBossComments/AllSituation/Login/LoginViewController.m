//
//  LoginViewController.m
//  My
//
//  Created by 马欣欣 on 15/7/30.
//  Copyright (c) 2015年 Max. All rights reserved.
//
#import "LoginViewController.h"
//-------

//-------
#import "JXAPIs.h"
#import "AccountSignResult.h"
#import "AccountRepository.h"
#import "SuccessAndFail.h"
#import "AppDelegate.h"
#import "PublicUseMethod.h"
#import "BossCommentTabBarCtr.h"
#import "MBProgressHUD.h"
#import "ChangeSecretCodeViewCtrl.h"

//xin
#import "LandingPageViewController.h"
#import "ChoiceIdentityVC.h"
#import "ChoiceCompanyVC.h"//选择公司
#import "MineDataRequest.h"
#import "CompanyModel.h"
#import "CompanyMembeEntity.h"
#import "OpenCommentVC.h"



//忘记密码
//#import "ChangeSecretCodeViewCtrl.h"


@interface LoginViewController ()
{
    MBProgressHUD *myHUD;
}

@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,strong)UIImage * bgImage;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"登录";
    [self setUpSubViews];
    
    [self isShowLeftButton:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    //MBProgressHUD进程
    myHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:myHUD];
    //    myHUD.labelText = @"登录中...";
    myHUD.label.text = @"登录中...";
    //不能设置为yes
    self.textField_Phone.delegate = self;
    self.textField_Pwd.delegate = self;
    
    // 取手机号
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.textField_Phone.text = [user stringForKey:@"userPassWord"];
    
    //判断手机号是否已经注册->并赋值
    if (self.myUserNumberPhone)
    {
        self.textField_Phone.text = self.myUserNumberPhone;
    }
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.textField_Phone];
    
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.textField_Pwd];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [UIView animateWithDuration:.8 animations:^{
        
        self.xianlingView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:.8 animations:^{
        
        self.xianlingView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setUpSubViews
{
    //    self.goBackBtn.hidden = YES;
    
    self.oneView.layer.cornerRadius = 4;
    self.oneView.layer.masksToBounds = YES;
    self.twoView.layer.cornerRadius = 4;
    self.twoView.layer.masksToBounds = YES;
    
    NSMutableArray *colorArray2 = [@[[PublicUseMethod setColor:@"DCC37F "],[PublicUseMethod setColor:@"F7E6B9"],[PublicUseMethod setColor:@"AF8F4D "]] mutableCopy];
    
    _bgImage = [self.login_Btn buttonImageFromColors:colorArray2 ByGradientType:upleftTolowRight];
    [self.login_Btn setBackgroundImage:_bgImage forState:UIControlStateNormal];
    
    self.login_Btn.layer.cornerRadius = 4;
    self.login_Btn.layer.masksToBounds = YES;
    [self.login_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.textField_Phone becomeFirstResponder];
    self.textField_Phone.keyboardType = UIKeyboardTypeNumberPad;
    
    
    self.textField_Phone.tintColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.textField_Pwd.tintColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    
    self.textField_Phone.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [self.textField_Phone setValue:[PublicUseMethod setColor:KColor_Text_ListColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    self.textField_Pwd.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [self.textField_Pwd setValue:[PublicUseMethod setColor:KColor_Text_ListColor] forKeyPath:@"_placeholderLabel.textColor"];
    
}

-(void)changeText
{
    if (self.textField_Phone.text.length)
    {
        if (self.textField_Phone.text.length > 11)
        {
            self.textField_Phone.text = [self.textField_Phone.text substringToIndex:11];
            //            [SVProgressHUD showInfoWithStatus:@"请输入11位正确的手机号码"];
            [PublicUseMethod showAlertView:NSLocalizedString(@"phone number more than 11", @"")];
            
            return;
        }if (self.textField_Phone.text.length ==11) {
            //
            
        }else
        {
            
            //            [self.login_Btn setTitleColor:[PublicUseMethod setColor:KColor_Text_WhiterColor] forState:UIControlStateNormal];
            //
            //            self.login_Btn.backgroundColor = [[PublicUseMethod setColor:KColor_MainColor]colorWithAlphaComponent:.5];
        }
    }
    if (self.textField_Pwd.text.length>=6)//最少6个字符
    {
        if (self.textField_Pwd.text.length>=20 )
        {
            self.textField_Pwd.text = [self.textField_Pwd.text substringToIndex:20];
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"password length must be 6-24 bit character", @"")];
            return;
        }
    }
    
}


#pragma mark -  登陆按钮点击
- (IBAction)loginBtnClick:(id)sender
{
    // 手机号存到本地
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:self.textField_Phone.text forKey:@"userPassWord"];
    [user synchronize];
    
    //    选择身份
    //    ChoiceIdentityVC * choiceVC = [[ChoiceIdentityVC alloc] init];
    //    [self.navigationController pushViewController:choiceVC animated:YES];
    //    ChoiceCompanyVC * companyVC = [[ChoiceCompanyVC alloc] init];
    //    [self.navigationController pushViewController:companyVC animated:YES];
    //防止重复点击
    UIButton *btn = (UIButton *)sender;
    //设置请求头
    NSString *AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    NSString *DeviceKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceKey"];
    
    if (AccessToken.length > 0 && DeviceKey.length > 0)
    {
        [self loginVC:btn];
    }else
    {
//        [self showLoadingIndicator];
        //新号第一次登录
        [AccountRepository createNew:^(AccountSignResult *result) {
            //            Log(@"result===%@",result);
            [self dismissLoadingIndicator];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loginVC:btn];
            });
            
        } fail:^(NSError *error) {
            
            [self dismissLoadingIndicator];
            if (error.code == -1001) { // 请求超时
                [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
                
            }else if (error.code == -1009) {// 没有网络
                
                [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
                
            }else{// 其他
                [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }

        }];
    }
    
}


- (void)loginVC:(UIButton *)btn
{
    
    [UIView animateWithDuration:.8 animations:^{
        
        self.xianlingView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
    }];
    
    [self.view endEditing:YES];
    
    //在这里做按钮的想做的事情。
    if ([self.textField_Phone.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"phone number can not be empty", @"")];
        return;
    }
    if ([PublicUseMethod textField:self.textField_Phone length:11]==NO)
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"phone number less than 11", @"")];
        return;
    }
    if ([PublicUseMethod isMobileNumber:self.textField_Phone.text]==NO)
    {
        return;
    }
    if ([self.textField_Pwd.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"enter the password", @"")];
        return;
    }
    [myHUD showAnimated:YES];
    [self gotoMainView];
    
}

-(void)gotoMainView
{
//    [self showLoadingIndicator];
    //直接登陆的回调方法
    __weak LoginViewController *weakSelf = self;
    
    [AccountRepository signIn:self.textField_Phone.text password:self.textField_Pwd.text success:^(AccountSignResult *result, NSString *platformAccountId, NSString *platformAccountPassword)
     {
         [self dismissLoadingIndicator];
         
         if(result.SignStatus == 1){
             
             [[NSUserDefaults standardUserDefaults]setObject:self.textField_Phone.text forKey:@"phone"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             //演示的时候保存真实的电话 和密码
             [[NSUserDefaults standardUserDefaults] setObject:self.textField_Phone.text forKey:RealyPhoneNum];
             [[NSUserDefaults standardUserDefaults]synchronize];
             [[NSUserDefaults standardUserDefaults] setObject:self.textField_Pwd.text forKey:RealyPasswordStr];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             NSLog(@"----:登录成功数据:----%@",result);
             [weakSelf signInSuccess:result];
             
         }else{
             
             [PublicUseMethod showAlertView:result.ErrorMessage];
             [myHUD hideAnimated:YES];

             //             [weakSelf signInFail:nil];
         }
     } fail:^(NSError *error)
     {
         [myHUD hideAnimated:YES];
         [weakSelf signInFail:error];
         [self dismissLoadingIndicator];
         
         NSLog(@"%@",error.localizedDescription);
         
     }];
}

void TTAlertNoTitle(NSString* message)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//成功
-(void)signInSuccess:(AccountSignResult *)result
{
    
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
-(void)signInFail:(NSError *)error
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

#pragma mark---------UIAlertViewDelegate---------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0||buttonIndex == 1)
    {
    }
}
//注册
- (IBAction)registerBtnClick:(id)sender
{
    //11.17
    LandingPageViewController * landingVC= [[LandingPageViewController alloc] init];
    [self.navigationController pushViewController:landingVC animated:YES];
}
//第一个方法就是定义的那个方法，把传进来的Block语句块保存到本类的实例变量
- (void)returnText:(ReturnTextBlock)block
{
    self.returnTextBlock = block;
}
//returnTextBlock（.h中定义的属性）中，然后寻找一个时机调用，而这个时机就是上面说到的，当视图将要消失的时候，需要重写：
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 让键盘下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:.8 animations:^{
        
        self.xianlingView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
    }];
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//忘记密码
- (IBAction)forgetSecretCode:(id)sender {
    
    ChangeSecretCodeViewCtrl *changeCtrl = [[ChangeSecretCodeViewCtrl alloc]init];
    changeCtrl.secondVC = _secondVC;
    [self.navigationController pushViewController:changeCtrl animated:YES];
    
}
- (IBAction)goBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
