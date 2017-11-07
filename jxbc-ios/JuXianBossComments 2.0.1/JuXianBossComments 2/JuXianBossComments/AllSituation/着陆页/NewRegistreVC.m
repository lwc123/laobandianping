//
//  NewRegistreVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "NewRegistreVC.h"
#import "LoginViewController.h"
#import "OpenCommentVC.h"
#import "AccountRepository.h"
#import "BossCommentTabBarCtr.h"
#import "ProveOneViewController.h"
#import "ChoiceCompanyVC.h"

#import "bossCommentsProtocolVC.h"
#import "CompanyProtocolWebVC.h"

@interface NewRegistreVC ()<UITextFieldDelegate>{

    dispatch_source_t _timer;
    MBProgressHUD *myHUD;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *passwardTF;
/**
 验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@property (weak, nonatomic) IBOutlet ColorButton *registerBtn;

@property (weak, nonatomic) IBOutlet ColorButton *sendBtn;

@property (weak, nonatomic) IBOutlet UIButton *protocolBtn;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
//判断button是否被点击了
@property (nonatomic ,assign)BOOL isClicked;

@property (weak, nonatomic) IBOutlet UIButton *proyocolImageBtn;

@end

@implementation NewRegistreVC

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self isShowLeftButton:NO];
}
- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self isShowLeftButton:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.title = @"企业注册";
    [self isShowLeftButton:YES];
    [self initUI];
    
    myHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:myHUD];
    //    myHUD.labelText = @"登录中...";
    myHUD.label.text = @"注册中...";
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.phoneNumTF];
}


- (void)initUI{
    
    _registerBtn.layer.cornerRadius = 4;
    _registerBtn.layer.masksToBounds = YES;
    NSString  * myStr = @"已有账号,马上登录";
    NSRange range = [myStr rangeOfString: @"马上登录"];
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:myStr];
    [str addAttribute:NSForegroundColorAttributeName value:[PublicUseMethod setColor:KColor_Add_BlueColor] range:range];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
    self.loginLabel.attributedText = str;
    
    _phoneNumTF.delegate = self;
    [_phoneNumTF becomeFirstResponder];
    _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    self.passwardTF.secureTextEntry = YES;
    self.proyocolImageBtn.selected = YES;
    [self.protocolBtn setImage:[UIImage imageNamed:@"redsection"] forState:UIControlStateNormal];


}


- (IBAction)protocolClick:(UIButton *)sender {
    
    if (self.proyocolImageBtn.selected == YES) {
        
        [self.protocolBtn setImage:[UIImage imageNamed:@"groupprotocol"] forState:UIControlStateNormal];
        self.proyocolImageBtn.selected = NO;
        
    }else{
        self.proyocolImageBtn.selected = YES;
        [self.protocolBtn setImage:[UIImage imageNamed:@"redsection"] forState:UIControlStateNormal];
    }
    
}
#pragma mark -- 企业用户隐私政策
- (IBAction)companyProtocol:(id)sender {
    CompanyProtocolWebVC * companyVC = [[CompanyProtocolWebVC alloc] init];
    companyVC.title = @"企业用户隐私政策";
    companyVC.secondVC = self;
    [self.navigationController pushViewController:companyVC animated:YES];
}
#pragma mark --  企业用户协议
- (IBAction)bossCommentsProtocol:(id)sender {
    
    bossCommentsProtocolVC * bossComments = [[bossCommentsProtocolVC alloc] init];
    bossComments.title = @"企业用户协议";
    bossComments.secondVC = self;
    [self.navigationController pushViewController:bossComments animated:YES];
}

#pragma mark -- 注册
- (IBAction)registerbtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
        btn.selected = NO;
    }
    else
    {
        //写要执行的语句
        if (self.phoneNumTF.text.length == 0) {
            
            [PublicUseMethod showAlertView:@"请输入手机号"];
            return;
        }
        
        if ([PublicUseMethod textField:self.phoneNumTF length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        if ([PublicUseMethod isMobileNumber:self.phoneNumTF.text]==NO)
        {
            return;
        }
        
        if ([self.passwardTF.text length] == 0)
        {
            [SVProgressHUD showInfoWithStatus:@"请输入密码"];
            return;
        }
        if ([self.passwardTF.text length] > 20)
        {
            [SVProgressHUD showInfoWithStatus:@"密码为6-18位数字与字母的组合"];
            return;
        }
        if ([self.passwardTF.text length] < 6)
        {
            [SVProgressHUD showInfoWithStatus:@"密码为6-18位数字与字母的组合"];
            return ;
        }
        self.passwardTF.text = [self.passwardTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (self.codeTF.text.length == 0) {
            [PublicUseMethod showAlertView:@"验证码不能为空"];
            return;
        }
                
        
        if (self.proyocolImageBtn.selected == NO) {
            [PublicUseMethod showAlertView:@"请阅读老板点评协议"];
            return;
        }
        
        btn.userInteractionEnabled = NO;
        [self gotoMainView];
        btn.userInteractionEnabled = YES;
    }

}

- (void)gotoMainView{
    
    __weak NewRegistreVC *weakSelf = self;
    AccountSign *sign = [[AccountSign alloc]init];
    
    sign.MobilePhone = self.phoneNumTF.text;
    sign.Password = self.passwardTF.text;
    sign.ValidationCode = self.codeTF.text;
    sign.SelectedProfileType = self.SelectedProfileType;
    
    NSLog(@"%@",sign.MobilePhone);
    NSLog(@"%@",sign.ValidationCode);
    [self showLoadingIndicator];
    [AccountRepository signUPWith:sign success:^(AccountSignResult *result) {
        [self dismissLoadingIndicator];
//        Log(@"result===%@",result);
        if (result.SignStatus == 1) {
            [weakSelf signUpSuccess:result];
            
            //演示的时候保存真实的电话 和密码
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNumTF.text forKey:RealyPhoneNum];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwardTF.text forKey:RealyPasswordStr];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
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
            [MobClick event:UMNewRegister label:@"企业注册"];
        }
        [MobClick profileSignInWithPUID:result.Account.UserProfile.MobilePhone];
    }
    
    if (self.SelectedProfileType == 1) {//个人用户
        
        NSString * organization = [NSString stringWithFormat:@"%d",1];
        [[NSUserDefaults standardUserDefaults] setObject:organization forKey:@"currentIdentity"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [UIView animateWithDuration:0.5 animations:^{
            [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
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
    Log(@"\nsignUp注册失败:\nerror===%@",error.localizedDescription
          );
    if (error.code == -1001) { // 请求超时
        [PublicUseMethod showAlertView:@"网络链接超时,请稍后再试"];
        
    }else if (error.code == -1009) {// 没有网络
        
        [PublicUseMethod showAlertView:@"网络好像断开了,请检查网络设置"];
        
    }else{// 其他
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }

}


#pragma mark -- 已有账号登录
- (IBAction)loginBtnClick:(id)sender {
    
    LoginViewController * loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark -- 获取验证码
- (IBAction)getCodeBtnClick:(UIButton *)sender {
    
    if (sender.selected) {
        sender.selected = NO;
    }else{
        //判断手机号是否注册  写要执行的语句
        if ([PublicUseMethod textField:self.phoneNumTF length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        
        if ([PublicUseMethod isMobileNumber:self.phoneNumTF.text]==NO)
        {
            return;
        }
        
        __weak NewRegistreVC *weakSelf = self;
        //判断是否已经注册
        [self showLoadingIndicator];
        [AccountRepository isExistsMobilePhone:self.phoneNumTF.text success:^(id result)
         {
             [weakSelf dismissLoadingIndicator];
             [weakSelf isExistsSuccess:result];
         } fail:^(NSError *error)
         {
             [weakSelf dismissLoadingIndicator];
             [SVProgressHUD dismiss];
             [PublicUseMethod showAlertView:error.localizedDescription];
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
    __weak NewRegistreVC *weakSelf = self;
    [self showLoadingIndicator];
    [AccountRepository signUpSendGetCode:self.phoneNumTF.text success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        if (result) {
            //停止计时
            [SVProgressHUD showInfoWithStatus:@"发送成功"];
            
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        
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
                [self.sendBtn setTitle:[NSString stringWithFormat:@"获取%@s",strTime] forState:UIControlStateNormal];
                
                self.sendBtn.userInteractionEnabled = NO;
                self.sendBtn.backgroundColor = [PublicUseMethod setColor:KColor_CodeColor];
                [self.sendBtn setBackgroundImage:nil forState:UIControlStateNormal];
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
        [self.sendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.sendBtn.userInteractionEnabled = YES;
        [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"codebutton"] forState:UIControlStateNormal];

        
    });
}

-(void)isExistsFail:(NSError *)error
{
    NSLog(@"验证码不存在,原因是:%@",error.localizedDescription);
}

#pragma mark----------UIAlertViewDelegate-------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1)
    {
        [self.phoneNumTF resignFirstResponder];
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        NSString *str = self.phoneNumTF.text;
        loginVC.myUserNumberPhone = str;
        loginVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else{
        
    }
}


#pragma mark -- TextField  delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneNumTF)
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
    
    if (self.phoneNumTF.text.length > 11)
    {
        self.phoneNumTF.text = [self.phoneNumTF.text substringToIndex:11];
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

#pragma mark -- 协议
- (IBAction)protocolBtnClick:(id)sender {
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
