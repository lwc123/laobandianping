//
//  LoginViewController.h
//  My
//
//  Created by 马欣欣 on 15/7/30.
//  Copyright (c) 2015年 Max. All rights reserved.
//
 
#import <UIKit/UIKit.h>
//#import "JXBasedViewController.h"


//第一行代码是为要声明的Block重新定义了一个名字ReturnTextBlock
typedef void (^ReturnTextBlock)(NSString *showText);
@interface LoginViewController : JXBasedViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField_Phone;
@property (weak, nonatomic) IBOutlet UITextField *textField_Pwd;
- (IBAction)forgetSecretCode:(id)sender;
//忘记密码
@property (weak, nonatomic) IBOutlet UIButton *secretCode;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *goBackBtn;

//第三行是定义的一个Block属性
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
//第四行是一个在第一个界面传进来一个Block语句块的函数，不用也可以，不过加上会减少代码的书写量
- (void)returnText:(ReturnTextBlock)block;

@property (nonatomic,copy) NSString *sendUserInfo;
@property (weak, nonatomic) IBOutlet ColorButton *login_Btn;

@property (nonatomic,strong) NSString *myUserNumberPhone;
@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIImageView *xianlingView;

@property (strong, nonatomic) NSString *tag;
@property (nonatomic,strong)UIViewController *secondVC;

@property (nonatomic,assign)BOOL isCollect;
@property (nonatomic,strong)UIViewController *popVC;
@end
