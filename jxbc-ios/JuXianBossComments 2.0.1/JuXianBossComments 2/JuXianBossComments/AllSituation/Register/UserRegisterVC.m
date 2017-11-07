
//
//  UserRegisterVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserRegisterVC.h"
#import "AccountSign.h"
#import "MineDataRequest.h"
#import "AccountRepository.h"
#import "OpenCommentVC.h"
#import "BossCommentTabBarCtr.h"
#import "LoginViewController.h"
#import "UserWorkbenchVC.h"


#import "bossCommentsProtocolVC.h"
#import "CompanyProtocolWebVC.h"

@interface UserRegisterVC ()<UITextFieldDelegate>{

    dispatch_source_t _timer;
    MBProgressHUD *myHUD;

}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTf;

@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;
@property (weak, nonatomic) IBOutlet ColorButton *codeBtn;

@property (weak, nonatomic) IBOutlet ColorButton *registerBtn;
//协议的对号的btn
@property (weak, nonatomic) IBOutlet UIButton *protocolBtnImage;
@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end

@implementation UserRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.title = @"个人注册";
    [self isShowLeftButton:YES];
    [self initUI];
    myHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:myHUD];
    myHUD.label.text = @"注册中...";
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.phoneNumTf];
    
}
- (void)initUI{
    NSString  * myStr = @"已有账号,马上登录";
    NSRange range = [myStr rangeOfString: @"马上登录"];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
    [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Add_BlueColor] range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    self.loginLabel.attributedText = str;
    
    _phoneNumTf.delegate = self;
    [_phoneNumTf becomeFirstResponder];
    _phoneNumTf.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTf.secureTextEntry = YES;
    [self.protocolBtnImage setImage:[UIImage imageNamed:@"redsection"] forState:UIControlStateNormal];
    self.protocolBtn.selected = YES;
}


#pragma mark -- 协议按钮 换图片
- (IBAction)protocolClick:(id)sender {
    
    if (self.protocolBtn.selected == YES) {
        
        [self.protocolBtnImage setImage:[UIImage imageNamed:@"groupprotocol"] forState:UIControlStateNormal];
        self.protocolBtn.selected = NO;
        
    }else{
        self.protocolBtn.selected = YES;
        [self.protocolBtnImage setImage:[UIImage imageNamed:@"redsection"] forState:UIControlStateNormal];
    }
}
#pragma mark -- 个人用户协议
- (IBAction)compayProtocolClick:(id)sender {
    
    bossCommentsProtocolVC * bossComments = [[bossCommentsProtocolVC alloc] init];
    bossComments.title = @"个人用户协议";
    bossComments.secondVC = self;
    [self.navigationController pushViewController:bossComments animated:YES];
}
#pragma mark -- 个人用户隐私政策
- (IBAction)CompanySecreClick:(id)sender {
    
    CompanyProtocolWebVC * companyVC = [[CompanyProtocolWebVC alloc] init];
    companyVC.title = @"个人用户隐私政策";
    companyVC.secondVC = self;
    [self.navigationController pushViewController:companyVC animated:YES];

}

#pragma mark -- 获取验证码
- (IBAction)getCodeBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
    }else{
        //判断手机号是否注册  写要执行的语句
        if ([PublicUseMethod textField:self.phoneNumTf length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        
        if ([PublicUseMethod isMobileNumber:self.phoneNumTf.text]==NO)
        {
            return;
        }
        __weak UserRegisterVC *weakSelf = self;
        //判断是否已经注册
        [AccountRepository isExistsMobilePhone:self.phoneNumTf.text success:^(id result)
         {
             [weakSelf isExistsSuccess:result];
         } fail:^(NSError *error)
         {
             [SVProgressHUD dismiss];
             [weakSelf isExistsFail:error];
         }];
    }

}

#pragma 验证手机注册与否
-(void)isExistsSuccess:(NSNumber *)isExist
{
    //0不存在  1存在
    if ([isExist intValue]==1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已被注册，可以直接去登录哦~~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去登录",nil];
        
        [alertView show];
        return;
    }
    else
    {
        [SVProgressHUD dismiss];
        [self sendEnsureCode];
    }
}
#pragma mark - 获取验证码
- (void)sendEnsureCode
{
    [AccountRepository signUpSendGetCode:self.phoneNumTf.text success:^(id result) {
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
                [self.codeBtn setTitle:[NSString stringWithFormat:@"获取%@s",strTime] forState:UIControlStateNormal];
                
                self.codeBtn.userInteractionEnabled = NO;
                self.codeBtn.backgroundColor = [PublicUseMethod setColor:KColor_CodeColor];
                [self.codeBtn setBackgroundImage:nil forState:UIControlStateNormal];
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
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
        [self.codeBtn setBackgroundImage:[UIImage imageNamed:@"codebutton"] forState:UIControlStateNormal];
        
        
    });
}

-(void)isExistsFail:(NSError *)error
{
    NSLog(@"验证码不存在,原因是:%@",error.localizedDescription);
}


#pragma mark -- 已有账号马上登陆
- (IBAction)loginBtnClick:(id)sender {
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark -- 注册
- (IBAction)registerbtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
//    btn.selected = YES;
//    UserWorkbenchVC * userVC = [[UserWorkbenchVC alloc] init];
//    [PublicUseMethod changeRootNavController:userVC];
    
    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
        btn.selected = NO;
    }
    else
    {
        //写要执行的语句
        if (self.phoneNumTf.text.length == 0) {
            
            [PublicUseMethod showAlertView:@"请输入手机号"];
            return;
        }
        
        if ([PublicUseMethod textField:self.phoneNumTf length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        if ([PublicUseMethod isMobileNumber:self.phoneNumTf.text]==NO)
        {
            return;
        }
        
        if ([self.passwordTf.text length] == 0)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入密码"];
            return;
        }
        if ([self.passwordTf.text length] > 20)
        {
            [SVProgressHUD showInfoWithStatus:@"密码为6-18位数字与字母的组合"];
            return;
        }
        if ([self.passwordTf.text length] < 6)
        {
            [SVProgressHUD showInfoWithStatus:@"密码为6-18位数字与字母的组合"];
            return ;
        }
        self.passwordTf.text = [self.passwordTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (self.codeTf.text.length == 0) {
            [PublicUseMethod showAlertView:@"验证码不能为空"];
            return;
        }
        
        
        if (self.protocolBtn.selected == NO) {
            [PublicUseMethod showAlertView:@"请阅读个人用户协议"];
            return;
        }
        
        btn.userInteractionEnabled = NO;
        [self gotoMainView];
        btn.userInteractionEnabled = YES;
    }
    
}

- (void)gotoMainView{

    __weak UserRegisterVC *weakSelf = self;
    AccountSign *sign = [[AccountSign alloc]init];
    
    sign.MobilePhone = self.phoneNumTf.text;
    sign.Password = self.passwordTf.text;
    sign.ValidationCode = self.codeTf.text;
    sign.SelectedProfileType = self.SelectedProfileType;
    
    NSLog(@"%@",sign.MobilePhone);
    NSLog(@"%@",sign.ValidationCode);
    [self showLoadingIndicator];
    [AccountRepository signUPWith:sign success:^(AccountSignResult *result) {
        [self dismissLoadingIndicator];
//        Log(@"result===%@",result);
        if (result.SignStatus == 1) {
            [weakSelf signUpSuccess:result];
            [PublicUseMethod showAlertView:@"注册成功"];
        }else
        {
            [PublicUseMethod showAlertView:result.ErrorMessage];
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [weakSelf signUpFail:error];
        
    }];

}

#pragma mark - 注册成功
-(void)signUpSuccess:(AccountSignResult *)result
{
    self.registerBtn.enabled = YES;
    //    需强制转换
    if(result.SignStatus == 1)
    {
        if([result.CreatedNewPassport boolValue]){
            //友盟统计
            [MobClick event:UMNewRegister label:@"个人注册"];
        }
        [MobClick profileSignInWithPUID:result.Account.UserProfile.MobilePhone];
    }
    
    if (self.SelectedProfileType == 1) {//个人用户
        
        NSString * organization = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults] setObject:organization forKey:@"currentIdentity"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [UIView animateWithDuration:0.5 animations:^{
            
            UserWorkbenchVC * userVC = [[UserWorkbenchVC alloc] init];
            [PublicUseMethod changeRootNavController:userVC];
        }];
    }
    if (self.SelectedProfileType == 2) {//企业用户
        NSString * organization = [NSString stringWithFormat:@"%d",2];
        [[NSUserDefaults standardUserDefaults] setObject:organization forKey:@"currentIdentity"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        OpenCommentVC * openCommentVC = [[OpenCommentVC alloc] init];
        [PublicUseMethod changeRootNavController:openCommentVC];
    }
}

-(void)signUpFail:(NSError *)error
{
    NSLog(@"\nsignUp注册失败:\nerror===%@",error.localizedDescription
          );
    [PublicUseMethod showAlertView:@"注册失败，请稍候再试~~"];
}


#pragma mark -- TextField  delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTf)
    {
        if ([textField.text length] > 11)
        {
            textField.text = [textField.text substringToIndex:11];
            [PublicUseMethod showAlertView:@"请输入11位正确的手机号码"];
            return NO;
        }
    }
    
    return YES;
}

- (void)changeText{
    
    if (self.phoneNumTf.text.length > 11)
    {
        self.phoneNumTf.text = [self.phoneNumTf.text substringToIndex:11];
        [PublicUseMethod showAlertView:@"请输入11位正确的手机号码"];
        return;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
