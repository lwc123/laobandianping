//
//  RegisterViewController.h
//  My
//
//  Created by 马欣欣 on 15/7/30.
//  Copyright (c) 2015年 Max. All rights reserved.
//

//#import <UIKit/UIKit.h>

#import "JXBasedViewController.h"
//#import "EditIndustryAndFunctionVC.h"

@interface RegisterViewController : JXBasedViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField_EnsureCode;
@property (weak, nonatomic) IBOutlet UITextField *textField_Pwd;
@property (weak, nonatomic) IBOutlet UITextField *textField_realName;
@property (weak, nonatomic) IBOutlet UITextField *industryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendNumLabel;
- (IBAction)industrySelect:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (copy,nonatomic) NSString *num_TF;

@property (nonatomic,strong)UIViewController *secondVC;
@property (nonatomic,assign)BOOL isCollect;
@property (nonatomic,strong)UIViewController *popVC;
@end
