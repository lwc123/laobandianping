//
//  InputEditVC.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/28.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "InputEditVC.h"

@interface InputEditVC ()

@end

@implementation InputEditVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
//    [self.placesHoladerView removeFromSuperview];
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES];
    
    if (self.label) {
        if (self.label.text.length!=0) {
            self.textField.text = self.label.text;
            
        }
    }
    
    if (self.tf) {
        if (self.tf.text.length!=0) {
            //self.tf.text
            self.textField.text = @"";
        }
    }

    self.view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    
}
-(void)rightButtonAction:(UIButton*)button
{
    NSString *textStr = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (self.label) {
        if (textStr.length!=0) {
            self.label.text = _textField.text;
        }else{
        
            [PublicUseMethod showAlertView:@"请填写正确!"];
        }
    }
    if (self.tf) {
            if (textStr.length!=0) {
            self.tf.text = _textField.text;
        }else{
        
            [PublicUseMethod showAlertView:@"请填写正确!"];
        }
        
    }
    
    if (self.isEmail) {
     
      BOOL isEmailFormat = [PublicUseMethod validateEmail:_textField.text];
        if (!isEmailFormat) {
            [PublicUseMethod showAlertView:@"请输入正确格式的邮箱!"];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
