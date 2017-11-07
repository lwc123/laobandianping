//
//  QuickLoginViewController.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/6/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "QuickLoginViewController.h"


//#import "UserTabBarViewController.h"
//#import "HunterTabBarViewController.h"
//-------
//#import "MainViewController.h"
#import "JXAPIs.h"
#import "AccountSignResult.h"
#import "AccountRepository.h"
#import "SuccessAndFail.h"
#import "AppDelegate.h"
#import "PublicUseMethod.h"

#import "StartViewController.h"

#import "LeadRegisterVController.h"

//#import "MBProgressHUD.h"
//忘记密码
#import "ChangeSecretCodeViewCtrl.h"
#import "UserProtocolViewController.h"
#import "BossCommentTabBarCtr.h"
//环信
//#import "EMSDK.h"

#import "LoginViewController.h"
//#import "ChatViewController.h"
//#import "JXHtmlChatVC.h"
//#import "PerfectUserInfoViewController.h"
//#import "JXTransitionViewController.h"
//#import "UserInfoViewController.h"
//#import "ServiceDetailVC.h"
//#import "ApplyHunterVC.h"
//#import "ApplyThreeVC.h"


//#import "DescribeQuestionVC.h"
//#import "ServiceDetailVC.h"


@interface QuickLoginViewController ()<UITextFieldDelegate>{
    
    dispatch_source_t _timer;
}

@property(nonatomic,strong) IQKeyboardReturnKeyHandler *returnKeyHander;
@property(nonatomic,strong) IQKeyboardManager *KeyBoardManger;
@property (nonatomic,strong)MBProgressHUD *myHUD;
@end

@implementation QuickLoginViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//[self.navigationController setNavigationBarHidden:YES animated:animated];
//    self.navigationController.navigationBarHidden = YES;
    
    
    
    //xjh
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//[self.navigationController setNavigationBarHidden:NO animated:animated];
//    self.navigationController.navigationBarHidden = NO;
    
    
    
   [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[PublicUseMethod setColor:KColor_MainColor]] forBarMetrics:UIBarMetricsDefault];
   
}
- (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect=CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
    [self isShowLeftButton:YES];
    self.myHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.myHUD];
    
    self.myHUD.label.text = @"登录中...";
    self.telephoneField.delegate = self;
    self.codeField.delegate = self;
    
    self.returnKeyHander = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    
    self.returnKeyHander.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.telephoneField];
    
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.codeField];
    
    
}
- (void)setUpSubViews
{
    self.loginBt.layer.cornerRadius = 21.5;
    self.loginBt.layer.masksToBounds = YES;
    self.telephoneField.textColor = [PublicUseMethod setColor:KColor_LineColor];
    [self.telephoneField setValue:[PublicUseMethod setColor:KColor_Text_ListColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.codeField.textColor = [PublicUseMethod setColor:KColor_LineColor];
    [self.codeField setValue:[PublicUseMethod setColor:KColor_Text_ListColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 12;
}

#pragma mark -- TextField  delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.telephoneField)
    {
        if ([textField.text length] > 11)
        {
            textField.text = [textField.text substringToIndex:11];
            [SVProgressHUD showInfoWithStatus:@"请输入11位正确的手机号码"];
            return NO;
        }
    }
    
    return YES;
}
-(void)changeText
{
    if (self.telephoneField.text.length > 11)
    {
        self.telephoneField.text = [self.telephoneField.text substringToIndex:11];
        [SVProgressHUD showInfoWithStatus:@"请输入11位正确的手机号码"];
        return;
    }
    
}



#pragma mark -- -- --
#pragma mark --   用户点击事件

#pragma mark -- 登录
- (IBAction)loginAction:(id)sender {
    
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
        [SVProgressHUD show];
        //新号第一次登录
        [AccountRepository createNew:^(AccountSignResult *result) {
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loginVC:btn];
            });
        } fail:^(NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"error===%@",error.localizedDescription);
            [SVProgressHUD showErrorWithStatus:@"登录失败，请重试"];
        }];
    }
    
    
    
}
- (void)loginVC:(UIButton *)btn
{
    self.loginBt.titleLabel.backgroundColor = [UIColor clearColor];
    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
        btn.selected = NO;
    }
    else
    {
        //在这里做按钮的想做的事情。
        if ([self.telephoneField.text isEqualToString:@""])
        {
            [SVProgressHUD showInfoWithStatus:@"手机号不能为空"];
            return;
        }
        if ([PublicUseMethod textField:self.telephoneField length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入11位的手机号"];
            return;
        }
        if ([PublicUseMethod isMobileNumber:self.telephoneField.text]==NO)
        {
            return;
        }
        if ([self.codeField.text isEqualToString:@""])
        {
            [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
            return;
        }
        
//        [self.myHUD show:YES];
        [self.myHUD showAnimated:YES];
        
        __weak QuickLoginViewController *weakSelf = self;

//        [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeNone];

        //判断是否已经注册

        [AccountRepository isExistsMobilePhone:self.telephoneField.text success:^(id result)
         {

             [weakSelf isExistsSuccess:result];
             
         } fail:^(NSError *error)
         {
             [SVProgressHUD dismiss];
//             [self isExistsFail:error];
         }];
        
        
        [self gotoMainView];
        btn.selected = YES;
    }
}

//判断是否注册过
- (void)isExistsSuccess:(NSNumber *)isExist{

    //0不存在  1存在
    if ([isExist intValue]==1)
    {

    }else{

//    注册通知 发送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RigisterSuccess" object:nil userInfo:@{@"bageNumber":@"1"}];

    }


}

-(void)gotoMainView
{
    //直接登陆的回调方法
    __weak typeof(self) weakSelf = self;
    [AccountRepository quickSignIn:self.telephoneField.text code:self.codeField.text success:^(AccountSignResult *result, NSString *platformAccountId, NSString *platformAccountPassword)
     
     {
        if(result.SignStatus == 1){
             
             [[NSUserDefaults standardUserDefaults]setObject:self.telephoneField.text forKey:@"phone"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             NSLog(@"----:登录成功数据:----%@",result);
             //登录
            [self.myHUD hideAnimated:YES];
             [weakSelf signInSuccess:result];
             
         }else{
             
             [self.myHUD hideAnimated:YES];
             [weakSelf signInFail:nil];
             
             
         }
         
     } fail:^(NSError *error)
     {
//         [self.myHUD hide:YES];
         [self.myHUD hideAnimated:YES];
         [weakSelf signInFail:error];
     }];
    
}


//登录成功
-(void)signInSuccess:(AccountSignResult *)result
{
    if (result.SignStatus == 1)
    {
        if([result.CreatedNewPassport boolValue]){//注册，新用户
        
            //友盟
//            [MobClick event:UMNewRegister label:@"快速注册(验证码)"];
            
        }
         //友盟
//        [MobClick profileSignInWithPUID:result.Account.UserProfile.MobilePhone];
        
        
        [UserAuthentication SaveCurrentAccount:result.Account];
        NSLog(@"快速登录页：self.navigationController====%@",self.navigationController);
        
        //直接push 有动画 这么没有
        [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];

        
//        if ([self isUserProfile]) {
        
//            [[NSUserDefaults standardUserDefaults] setObject:userCurrentIndustry forKey:@"CurrentIndustry"];
//            [[NSUserDefaults standardUserDefaults] synchronize];

//        }
        
    }else
    {
        [SVProgressHUD showSuccessWithStatus:result.ErrorMessage];
        return;
        
    }
    
}
//失败
-(void)signInFail:(NSError *)error
{
    NSLog(@"登录失败:%@",error);
    [SVProgressHUD showInfoWithStatus:@"账号或密码错误"];
    
}


#pragma mark---------UIAlertViewDelegate---------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0||buttonIndex == 1)
    {
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.telephoneField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.codeField];
}
// 让键盘下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -- 忘记密码
- (IBAction)forgetPassWordAction:(id)sender {
    ChangeSecretCodeViewCtrl *changeCtrl = [[ChangeSecretCodeViewCtrl alloc]init];
    changeCtrl.secondVC = _secondVC;
    [self.navigationController pushViewController:changeCtrl animated:YES];
}
#pragma mark -- 举贤令用户协议
- (IBAction)delegateAction:(id)sender {
    UserProtocolViewController *userProtocolVC = [[UserProtocolViewController alloc] init];
    [self.navigationController pushViewController:userProtocolVC animated:YES];
    
}
#pragma mark -- 注册
- (IBAction)registerAction:(id)sender {
    LeadRegisterVController *leadRegistVC = [[LeadRegisterVController alloc] init];
    
    leadRegistVC.identifi = @"来自loginVC界面";
    leadRegistVC.secondVC = _secondVC;
    leadRegistVC.isCollect = _isCollect;
    leadRegistVC.popVC = _popVC;
    [self.navigationController pushViewController:leadRegistVC animated:YES];
}
#pragma mark -- 密码登录
- (IBAction)passWordLogin:(id)sender {
    
    NSLog(@"self.navigationController)===%@",self.navigationController);
    
    LoginViewController *login = [[LoginViewController alloc] init];
    login.tag = self.tag;
    login.navigationItem.hidesBackButton = YES;
    login.secondVC = _secondVC;
    login.isCollect = _isCollect;
    login.popVC = _popVC;
    
    JXBasedNavigationController *navc = [[JXBasedNavigationController alloc] initWithRootViewController:login];
    APPDELEGATE.window.rootViewController = navc;
    
//    [self.navigationController pushViewController:login animated:YES];
    
}
#pragma mark -- 发送验证码
- (IBAction)sendCodeAction:(id)sender {
    
    
    if ([PublicUseMethod textField:self.telephoneField length:11]==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入11位的手机号"];
        return;
    }
    if ([PublicUseMethod isMobileNumber:self.telephoneField.text]==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        return;
    }
    
    [AccountRepository signUpSendGetCode:self.telephoneField.text success:^(id result) {
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
-(void)startTime
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            [self endTimer];
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout %61;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                self.timeLabel.text = [NSString stringWithFormat:@"获取%@s",strTime];
                self.codeBt.userInteractionEnabled = NO;
                
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
        self.timeLabel.text = @"重新获取";
        self.codeBt.userInteractionEnabled = YES;
        
    });
    
}


#pragma mark -- 返回
- (IBAction)goBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
