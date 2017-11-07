//
//  ApplyAccountOneVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

@interface ApplyAccountOneVC : JXBasedViewController<UIAlertViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
/**
 获取验证码btn
 */
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
/**
 输入验证码的TextField
 */
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *nexBtn;


@end
