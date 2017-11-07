//
//  LeadRegisterVController.m
//  JuXianTalentBank
//
//  Created by 秦万里 on 16/4/14.
//  Copyright (c) 2016年 Max. All rights reserved.
//

#import "LeadRegisterVController.h"
#import "UserProtocolViewController.h"
#import "RegisterViewController.h"
#import "PublicUseMethod.h"
#import "StartViewController.h"
#import "SVProgressHUD.h"

#import "AccountRepository.h"
#import "LoginViewController.h"


@interface LeadRegisterVController ()
@property (nonatomic,strong)MBProgressHUD *myHUD;
@end

@implementation LeadRegisterVController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    self.navBarBackView.hidden = YES;

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
  
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[PublicUseMethod setColor:KColor_MainColor]] forBarMetrics:UIBarMetricsDefault];
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
//    self.edgesForExtendedLayout  = UIRectEdgeNone;
//    [self.number_TextField becomeFirstResponder];
    self.number_TextField.delegate = self;
   
    [self isShowLeftButton:YES];

    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:self.number_TextField];
}
- (void)setUpSubViews
{
    self.nextBtn.layer.cornerRadius = 21.5;
    self.nextBtn.layer.masksToBounds = YES;
    self.btnBgview.layer.cornerRadius = 21.5;
    self.btnBgview.layer.masksToBounds = YES;
    
    self.btnBgview.backgroundColor = [[PublicUseMethod setColor:KColor_Text_WhiterColor]colorWithAlphaComponent:.5];
    self.label1.textColor = [PublicUseMethod setColor:KColor_LineColor];
    self.label2.textColor = [PublicUseMethod setColor:KColor_LineColor];
    self.number_TextField.textColor = [PublicUseMethod setColor:KColor_LineColor];
    [self.number_TextField setValue:[PublicUseMethod setColor:KColor_Text_ListColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.line1.backgroundColor = [PublicUseMethod setColor:KColor_Text_ListColor];
    self.line2.backgroundColor = [PublicUseMethod setColor:KColor_Text_ListColor];
    
    [self.protocolButton setTitleColor:[PublicUseMethod setColor:KColor_LineColor] forState:UIControlStateNormal];
    
    
}
#pragma mark-------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 11)
    {
        return NO; // return NO to not change text
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:1 animations:^{
        self.xianlingView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.xianlingView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        
    }];

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:1 animations:^{
        self.xianlingView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.xianlingView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        
    }];

    
}
-(void)changeText
{
    if (self.number_TextField.text.length == 11)
    {
        self.nextBtn.enabled = YES;
        self.btnBgview.backgroundColor = [UIColor whiteColor];
        self.label1.textColor = [PublicUseMethod setColor:KColor_MainColor];
        self.label2.textColor = [PublicUseMethod setColor:KColor_MainColor];
    }
    else
    {
        self.nextBtn.enabled = NO;
        self.btnBgview.backgroundColor = [[PublicUseMethod setColor:KColor_Text_WhiterColor]colorWithAlphaComponent:.5];
        self.label1.textColor = [PublicUseMethod setColor:KColor_LineColor];
        self.label2.textColor = [PublicUseMethod setColor:KColor_LineColor];
    }
}

-(void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)protocol_Btn:(id)sender
{
    UserProtocolViewController *userProtocolVC = [[UserProtocolViewController alloc] init];
    [self.navigationController pushViewController:userProtocolVC animated:YES];
}
-(IBAction)next_Btn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
    }
    else
    {
        [self.view endEditing:YES];
        //写要执行的语句
        if ([PublicUseMethod textField:self.number_TextField length:11]==NO)
        {
            [SVProgressHUD showInfoWithStatus:@"手机号为11位数字"];
            return;
        }
        if ([PublicUseMethod isMobileNumber:self.number_TextField.text]==NO)
        {
            return;
        }
        //判断手机号是否注册
        [SVProgressHUD showWithStatus:@"正在发送..." maskType:SVProgressHUDMaskTypeNone];
        __weak LeadRegisterVController *weakSelf = self;
        //判断是否已经注册 
        [AccountRepository isExistsMobilePhone:self.number_TextField.text success:^(id result)
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
        [SVProgressHUD dismiss];
        
        return;
    }
    else
    {
        //这手机号没被登录 发送验证码
        
        [SVProgressHUD dismiss];
        RegisterViewController *registVC = [[RegisterViewController alloc] init];
        registVC.num_TF = self.number_TextField.text;
        registVC.secondVC = _secondVC;
        registVC.isCollect = _isCollect;
        registVC.popVC = _popVC;
        [self.navigationController pushViewController:registVC animated:YES];
    }
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
        [self.number_TextField resignFirstResponder];
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        NSString *str = self.number_TextField.text;
        loginVC.myUserNumberPhone = str;
        loginVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else{
        
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.number_TextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)protocolAction:(id)sender {
}
@end
