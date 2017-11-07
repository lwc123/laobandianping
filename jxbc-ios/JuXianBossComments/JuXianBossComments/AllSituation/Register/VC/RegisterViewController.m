//
//  RegisterViewController.m
//  My
//
//  Created by 马欣欣 on 15/7/30.
//  Copyright (c) 2015年 Max. All rights reserved.
//
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "AccountRepository.h"
#import "SVProgressHUD.h"
#import "SuccessAndFail.h"
#import "PublicUseMethod.h"
#import "MBProgressHUD.h"
#import "UserProtocolViewController.h"
#import "LoginViewController.h"
//#import "MainViewController.h"
#import "UserAuthentication.h"
//#import "JXCreditWallVC.h"
#import "AccountRepository.h"
#import "AccountSign.h"
#import "BossCommentTabBarCtr.h"

//关于系统通知
//#import "JXNotificationRequest.h"
//#import "MessaheNotificationModel.h"
//#import "PerfectUserInfoViewController.h"
//#import "JXTransitionViewController.h"
//#import "UserInfoViewController.h"
//#import "ServiceDetailVC.h"
//#import "ChatViewController.h"
//#import "JXHtmlChatVC.h"
//#import "ApplyHunterVC.h"
//#import "ApplyThreeVC.h"
//#import "DescribeQuestionVC.h"

#define Length 6
@interface RegisterViewController ()
{
    BOOL btnSelected;
    MBProgressHUD *myHUD;
    dispatch_source_t _timer;
}

//通知
@property (nonatomic,strong)NSMutableArray * dataNotificationArray;
@property (nonatomic,copy)NSString *industryCode;
@property (nonatomic,copy)NSString *jobCode;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendEnsureCode];
    [self setUpSubViews];
    //显示正在请求view
    myHUD = [[MBProgressHUD alloc] initWithView:self.view];
    myHUD.labelText = @"注册中...";
    [self.view addSubview:myHUD];
    //测试专用验证码
//    self.textField_EnsureCode.text = @"FRUIT1204";
    
    //验证码框获取焦点
    [self.textField_EnsureCode becomeFirstResponder];
    //返回按钮
    self.navigationItem.title = @"设置密码";
    
    self.textField_EnsureCode.delegate = self;
    self.textField_realName.delegate = self;
    self.textField_Pwd.delegate = self;
    self.industryLabel.delegate = self;
    
//    //监听文本框
//   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)changeText
{
    if (self.textField_EnsureCode.text.length&&self.textField_Pwd.text.length&&self.textField_realName.text.length) {
        self.registerBtn.backgroundColor = [PublicUseMethod setColor:KColor_SubColor];
    }else
    {
     self.registerBtn.backgroundColor = [PublicUseMethod setColor:KColor_LineColor];
    }
}
- (void)setUpSubViews
{
    [self isShowLeftButton:YES];
//    self.placesHoladerView.hidden = YES;
    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    self.getCodeButton.backgroundColor = [PublicUseMethod setColor:KColor_LineColor];
    self.getCodeButton.layer.cornerRadius = 12.5;
    self.getCodeButton.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 21.5;
    self.registerBtn.layer.masksToBounds = YES;
    self.registerBtn.backgroundColor = [PublicUseMethod setColor:KColor_LineColor];
    self.textField_EnsureCode.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.textField_Pwd.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.textField_realName.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.industryLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.label1.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.label2.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.label3.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.label4.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.sendNumLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.sendNumLabel.text = [NSString stringWithFormat:@"验证码已发送至手机+86%@",self.num_TF];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textField_EnsureCode)
    {
        if (range.location >= 6)
        {
            //[self endTimer];
            return NO;
        }
    }
    if (textField == self.textField_Pwd)
    {
        if (range.location >= 20)
        {
            return NO;
        }
    }
    if (textField == self.textField_realName)
    {
    }
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navBarBackView.backgroundColor = [UIColor clearColor];
   
}
-(void)viewWillAppear:(BOOL)animated
{
//    self.navBarBackView.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];

    [super viewWillAppear:animated];
    if (self.industryLabel.text.length) {
        [self changeText];
    }else
    {
    }
   
}
//获取验证码Btn
- (IBAction)getCodeButton:(id)sender
{
    
    [self sendEnsureCode];
}


#pragma mark - 获取验证码
- (void)sendEnsureCode
{
    [AccountRepository signUpSendGetCode:self.num_TF success:^(id result) {
        if (result) {
            //停止计时
            
            [SVProgressHUD showInfoWithStatus:@"发送成功"];
            
        }
    } fail:^(NSError *error) {
        
    }];
    //把按钮改变倒计时
    [self startTime];

}
#pragma 按钮只点击一次方法
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
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"获取%@s",strTime] forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = NO;
//                self.getCodeButton.backgroundColor = [PublicUseMethod setColor:@"CBCBCB"];
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
        [self.getCodeButton setBackgroundColor:[PublicUseMethod setColor:KColor_SubColor]];
    });
}
//改变跟视图
-(void)changeRootViewController:(UIViewController *)vc{
    UIWindow *window =[[[UIApplication sharedApplication]delegate]window];
    window.rootViewController =vc;
}
//注册按钮
// 逻辑流程 先获取 判断后台是否返回了 参数 没有就CreateNew
- (IBAction)registerBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    //设置请求头
    NSString *AccessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AccessToken"];
    NSString *DeviceKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceKey"];
    if (AccessToken.length > 0 && DeviceKey.length > 0)
    {
        [self registerAccount:btn];//第一次注册
    }else
    {
        [SVProgressHUD show];
        __weak RegisterViewController *wself = self;
        [AccountRepository createNew:^(AccountSignResult *result)
         {
             [SVProgressHUD dismiss];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [wself registerAccount:btn];
             });
             
        } fail:^(NSError *error)
        {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"注册失败，请重试"];
            
            NSLog(@"%@",error.localizedDescription);
            
        }];
    }
    

//    之前调试消息通知写的
//    UserTabBarViewController *user = [[UserTabBarViewController alloc]init];
//    [PublicUseMethod changeRootViewController:user];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"RigisterSuccess" object:nil userInfo:@{@"bageNumber":@"1"}];
}
- (void)registerAccount:(UIButton *)btn
{
    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
        btn.selected = NO;
    }
    else
    {
        if ([self.textField_EnsureCode.text isEqualToString:@""])
        {
            [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
            return;
        }
        
        if (self.textField_Pwd.text.length < 6) {
            
            [PublicUseMethod showAlertView:@"密码最少6位,请重新输入"];
            return;
        }
        
        if ([self.textField_Pwd.text isEqualToString:@""])
        {
            [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
            return;
        }
        if ([self.textField_realName.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"姓名不能为空"];
            return;
        }
        if (self.textField_realName.text.length>10||self.textField_realName.text.length<2) {
            [SVProgressHUD showInfoWithStatus:@"昵称长度必须2-10位字符"];
            return;
        }
//        __weak RegisterViewController *weakSelf = self;
//        [AccountRepository signUp:self.num_TF code:self.textField_EnsureCode.text pwd:self.textField_Pwd.text nickName:self.textField_NickName.text success:^(AccountSignResult *result)
//         {
//             [weakSelf signUpSuccess:result];
//             
//         } fail:^(NSError *error) {
//             [weakSelf signUpFail:error];
//         }];
        
        self.registerBtn.enabled = NO;
        [myHUD showAnimated:YES];
        [self gotoMainView];
//        [myHUD showAnimated:YES whileExecutingBlock:nil];
        btn.selected = YES;
    }
}


//-(void)confirmRegister
//{
//    sleep(.5);
//    [self performSelectorOnMainThread:@selector(gotoMainView) withObject:nil waitUntilDone:NO];
//}
-(void)gotoMainView
{
    if ([self.textField_EnsureCode.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"验证码不能为空"];
        return;
    }
    if ([self.textField_Pwd.text isEqualToString:@""])
    {
        [SVProgressHUD showInfoWithStatus:@"密码不能为空"];
        return;
    }if (self.industryLabel.text.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"行业不能为空"];
//        return;
    }else
    {
        
    }
    //2.填写验证码后,点击注册按钮
    
    NSLog(@"%@",self.num_TF);
    NSLog(@"%@",self.textField_EnsureCode.text);
    NSLog(@"%@",self.textField_Pwd.text);
    NSLog(@"%@",self.textField_realName.text);
    NSLog(@"%@",self.industryLabel.text);
    __weak RegisterViewController *weakSelf = self;
    AccountSign *sign = [[AccountSign alloc]init];
    sign.MobilePhone = self.num_TF;
    sign.Password = self.textField_Pwd.text;
//    sign.CurrentIndustry = self.industryLabel.text;
//    sign.CurrentJobCategory = self.industryLabel.text;
    
    sign.CurrentIndustry = _industryCode;
    sign.CurrentJobCategory = _jobCode;
    
    sign.Nickname = self.textField_realName.text;
    sign.ValidationCode = self.textField_EnsureCode.text;
    
    //用于存储用户信息的
//    JXUserProfile *user = [[JXUserProfile alloc]init];
//    //user.MobilePhone = self.num_TF;
//    user.CurrentIndustry = self.industryLabel.text;
//    user.Nickname = self.textField_realName.text;
//    user.CurrentIndustry = _industryCode;
//    [UserAuthentication SaVeUserInfoWith:user];
    
    
    [AccountRepository signUPWith:sign success:^(AccountSignResult *result) {
        if (result.SignStatus == 1) {
            
            [weakSelf signUpSuccess:result];
        }else
        {
            [PublicUseMethod showAlertView:@"验证码错误"];
        }
    } fail:^(NSError *error) {
        
        [weakSelf signUpFail:error];
        
    }];
}
#pragma mark - 注册成功
-(void)signUpSuccess:(AccountSignResult *)result
{
    self.registerBtn.enabled = YES;
    
    [self.registerBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    
    //用于存储用户信息的
    [[NSUserDefaults standardUserDefaults] setObject:_industryCode forKey:@"CurrentIndustry"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [PublicUseMethod showAlertView:result.ErrorMessage];
//    DUPLICATE_MOBILEPHONE
//    需强制转换
    if(result.SignStatus == 1)
    {
        if([result.CreatedNewPassport boolValue]){
        
            //友盟统计
//            [MobClick event:UMNewRegister label:@"普通注册"];
            
        }
//         [MobClick profileSignInWithPUID:result.Account.UserProfile.MobilePhone];
        
        
        //为活动传值写的
        [[NSUserDefaults standardUserDefaults]setObject:self.num_TF forKey:@"phone"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
//        跳转至登陆界面采用alertView的代理方法,new一个loginVC push至登陆界面!

//        注册通知 发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RigisterSuccess" object:nil userInfo:@{@"bageNumber":@"1"}];
    }
  
    NSLog(@"注册页：self.navigationController====%@",self.navigationController);
    
//    [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
    [self.navigationController pushViewController:[[BossCommentTabBarCtr alloc] init] animated:YES];
}

-(void)signUpFail:(NSError *)error
{
    NSLog(@"\nsignUp注册失败:\nerror===%@",error);
//    self.registerBtn.enabled = YES;
//    self.registerBtn.backgroundColor = setColorWithRGB(229, 55, 55);
//    [self.registerBtn setTitle:@"完成注册" forState:UIControlStateNormal];

    [PublicUseMethod showAlertView:@"注册失败，请稍候再试~~"];
}


//清除文本信息
-(void)clearMessage
{
    self.textField_EnsureCode.text = @"";
    self.textField_Pwd.text = @"";
    
}
//判断适合合法,为空等
-(void)checkTextField
{
    if ([PublicUseMethod isMobileNumber:self.num_TF]==NO)
    {
        return;
    }
    return;
}
// 让键盘下去
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)industrySelect:(id)sender {
    //选择行业
//    EditIndustryAndFunctionVC *industryVC = [[EditIndustryAndFunctionVC alloc]init];
//    industryVC.textfield = self.industryLabel;
//    industryVC.block = ^(NSString *industryCode,NSString *jobCode){
//    
//        _industryCode = industryCode;
//        _jobCode = jobCode;
//    };
//    [self.navigationController pushViewController:industryVC animated:YES];
    
}

@end
