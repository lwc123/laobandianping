//
//  ChangeSecretCodeViewCtrl.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/14.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBasedViewController.h"

@interface ChangeSecretCodeViewCtrl : JXBasedViewController
@property (weak, nonatomic) IBOutlet UITextField *textField_Phone;
@property (weak, nonatomic) IBOutlet UITextField *textField_Pwd;
@property (weak, nonatomic) IBOutlet UIButton *change_Btn;
@property (weak, nonatomic) IBOutlet UITextField *textField_EnsureCode;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *sendNumLabel;
@property (nonatomic,strong)UIViewController *secondVC;
- (IBAction)ChangeAction:(id)sender;
- (IBAction)getCodeAction:(id)sender;
@end
