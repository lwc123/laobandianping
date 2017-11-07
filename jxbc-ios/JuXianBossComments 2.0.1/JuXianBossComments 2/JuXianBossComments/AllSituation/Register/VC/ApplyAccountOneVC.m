//
//  ApplyAccountOneVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ApplyAccountOneVC.h"
#import "ApplyAccountTwoVC.h"
#import "AccountRepository.h"
#import "LoginViewController.h"

@interface ApplyAccountOneVC (){

    dispatch_source_t _timer;

}

@property(nonatomic,strong) IQKeyboardReturnKeyHandler *returnKeyHander;
@property(nonatomic,strong) IQKeyboardManager *KeyBoardManger;



@end

@implementation ApplyAccountOneVC


//- (void)viewWillAppear:(BOOL)animated{
//
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
//
//- (void)viewDidDisappear:(BOOL)animated{
//
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    [self initNavView];
    [self initUI];
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.phoneNumTF];
}

- (void)initNavView{
    self.title = @"企业认证";
    [self isShowLeftButton:YES];
    self.returnKeyHander = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];

    self.returnKeyHander.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
 
}

- (void)initUI{
    JXBecomeHunterView * headerView = [JXBecomeHunterView becomeHunterView];
    headerView.frame = CGRectMake(0, 30, SCREEN_WIDTH, 50);
    [self.view addSubview:headerView];
    
    self.nexBtn.layer.masksToBounds = YES;
    self.nexBtn.layer.cornerRadius = 8;
}


#pragma mark -- TextField  delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    if (range.location >= 11)
//    {
//        return NO; // return NO to not change text
//    }
//    return YES;
    
    if (textField == self.phoneNumTF)
    {
        if ([textField.text length] > 11)
        {
            textField.text = [textField.text substringToIndex:11];
//            [SVProgressHUD showInfoWithStatus:@"请输入11位正确的手机号码"];
//            [SVProgressHUD showProgress:3 status:@"请输入11位正确的手机号码"];
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
//        [SVProgressHUD showInfoWithStatus:@"请输入11位正确的手机号码"];
//        [SVProgressHUD showProgress:3 status:@"请输入11位正确的手机号码"];
        [PublicUseMethod showAlertView:@"请输入11位正确的手机号码"];

        return;
    }

}


#pragma mark -- 发送验证码
- (IBAction)sendCode:(id)sender {
    
    //判断手机号是否注册
//    [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeNone];
    
    //        [SVProgressHUD showErrorWithStatus:<#(NSString *)#>];
    
    
    //写要执行的语句
    if ([PublicUseMethod textField:self.phoneNumTF length:11]==NO)
    {
        [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
        return;
    }
    
    if ([PublicUseMethod isMobileNumber:self.phoneNumTF.text]==NO)
    {
        return;
    }
    
    
    __weak ApplyAccountOneVC *weakSelf = self;
    //判断是否已经注册
    [AccountRepository isExistsMobilePhone:self.phoneNumTF.text success:^(id result)
     {
         
         [weakSelf isExistsSuccess:result];
     } fail:^(NSError *error)
     {
         [SVProgressHUD dismiss];
         [weakSelf isExistsFail:error];
     }];
    
}

#pragma mark -- 下一步
- (IBAction)nextBtn:(id)sender {

//    ApplyAccountTwoVC * twoVC = [[ApplyAccountTwoVC alloc] init];
//    twoVC.name_text = self.nameTF.text;
//    twoVC.company_text = self.companyTF.text;
//    twoVC.phoneNum_text = self.phoneNumTF.text;
//    twoVC.EnsureCode_text = self.codeTF.text;
//    [self.navigationController pushViewController:twoVC animated:YES];
    
    NSLog(@"self.navigationController===%@",self.navigationController);
    
    UIButton *btn = (UIButton *)sender;
    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
    }
    else
    {
//        [self.view endEditing:YES];
        if (self.companyTF.text.length == 0) {
            
            [PublicUseMethod showAlertView:NSLocalizedString(@"enter the name of the enterprise", @"")];
            return;
        }
        if (self.companyTF.text.length <2) {
            [PublicUseMethod showAlertView:NSLocalizedString(@"company name lenth than two charachers", @"")];
            return;
        }
        
        if (self.nameTF.text.length == 0) {
            
            [PublicUseMethod showAlertView:NSLocalizedString(@"enter the name of the legal person", @"")];
            return;
        }
        
        if (self.nameTF.text.length>10||self.nameTF.text.length<2) {
            [PublicUseMethod showAlertView:@"法人姓名长度必须2-10位字符"];
            return;
        }
        
        //写要执行的语句
        if ([PublicUseMethod textField:self.phoneNumTF length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        if ([PublicUseMethod isMobileNumber:self.phoneNumTF.text]==NO)
        {
            return;
        }
        
        if (self.codeTF.text.length == 0) {
            
            [PublicUseMethod showAlertView:@"验证码不能为空"];
            return;
        }
        
        btn.userInteractionEnabled = NO;
        [self gotoMainView];
        btn.userInteractionEnabled = YES;


        
//        //判断手机号是否注册
//        [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeNone];
//        
////        [SVProgressHUD showErrorWithStatus:<#(NSString *)#>];
//        
//        __weak ApplyAccountOneVC *weakSelf = self;
//        //判断是否已经注册
//        [AccountRepository isExistsMobilePhone:self.phoneNumTF.text success:^(id result)
//         {
//             
//             [weakSelf isExistsSuccess:result];
//         } fail:^(NSError *error)
//         {
//             [SVProgressHUD dismiss];
//             [weakSelf isExistsFail:error];
//         }];
    }
    
}


- (void)gotoMainView{

    __weak ApplyAccountOneVC *weakSelf = self;
    AccountSign *sign = [[AccountSign alloc]init];
    
    sign.MobilePhone = self.phoneNumTF.text;
    //企业名称
    sign.EntName = self.companyTF.text;
    //法人代表
    sign.LegalRepresentative = self.nameTF.text;
    sign.ValidationCode = self.codeTF.text;
    
    
    NSLog(@"%@",sign.MobilePhone);
    NSLog(@"%@",sign.EntName);
    NSLog(@"%@",sign.LegalRepresentative);
    NSLog(@"%@",sign.ValidationCode);

    
//    sign.Password = @"123456";
//    sign.CurrentIndustry = @"";
//    sign.CurrentJobCategory = @"";
    [AccountRepository signUPWith:sign success:^(AccountSignResult *result) {
        
//        Log(@"result===%@",result);
        if (result.SignStatus == 1) {
            [weakSelf signUpSuccess:result];
        }else
        {
            
//            NSString * errorStr = result.ErrorMessage;
            [PublicUseMethod showAlertView:result.ErrorMessage];
            
        }
    } fail:^(NSError *error) {
        
        [weakSelf signUpFail:error];
        
    }];
}

#pragma mark - 注册成功
-(void)signUpSuccess:(AccountSignResult *)result
{
        self.nexBtn.enabled = YES;

    //    需强制转换
    if(result.SignStatus == 1)
    {
        if([result.CreatedNewPassport boolValue]){
            //友盟统计
            //            [MobClick event:UMNewRegister label:@"普通注册"];
            
        }
        //         [MobClick profileSignInWithPUID:result.Account.UserProfile.MobilePhone];
        
        //为活动传值写的
        [[NSUserDefaults standardUserDefaults]setObject:self.phoneNumTF.text forKey:@"phone"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        //        跳转至登陆界面采用alertView的代理方法,new一个loginVC push至登陆界面!
        //        UserTabBarViewController *user = [[UserTabBarViewController alloc]init];
        //        [PublicUseMethod changeRootViewController:user];
        //        注册通知 发送消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RigisterSuccess" object:nil userInfo:@{@"bageNumber":@"1"}];
    }
    
    NSLog(@"注册页：self.navigationController====%@",self.navigationController);
    
        ApplyAccountTwoVC * twoVC = [[ApplyAccountTwoVC alloc] init];
        twoVC.name_text = self.nameTF.text;
        twoVC.company_text = self.companyTF.text;
        twoVC.phoneNum_text = self.phoneNumTF.text;
        twoVC.EnsureCode_text = self.codeTF.text;
        [self.navigationController pushViewController:twoVC animated:YES];
    
}


-(void)signUpFail:(NSError *)error
{
    NSLog(@"\nsignUp注册失败:\nerror===%@",error.localizedDescription
          );
    //    self.registerBtn.enabled = YES;
    //    self.registerBtn.backgroundColor = setColorWithRGB(229, 55, 55);
    //    [self.registerBtn setTitle:@"完成注册" forState:UIControlStateNormal];
    
    [PublicUseMethod showAlertView:@"注册失败，请稍候再试~~"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma 验证手机注册与否
-(void)isExistsSuccess:(NSNumber *)isExist
{
    //0不存在  1存在
    if ([isExist intValue]==1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该手机号已被注册，可以直接去登录哦~~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"去登录",nil];
        
        [alertView show];
        
//        [SVProgressHUD dismiss];
        
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
    [AccountRepository signUpSendGetCode:self.phoneNumTF.text success:^(id result) {
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
                [self.sendBtn setTitle:[NSString stringWithFormat:@"获取%@s",strTime] forState:UIControlStateNormal];
                
                self.sendBtn.userInteractionEnabled = NO;
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
        [self.sendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        self.sendBtn.userInteractionEnabled = YES;
        [self.sendBtn setBackgroundColor:[PublicUseMethod setColor:KColor_SubColor]];
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

#pragma mark-------------
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (range.location >= 11)
//    {
//        return NO; // return NO to not change text
//    }
//    return YES;
//}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.phoneNumTF];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}



@end
