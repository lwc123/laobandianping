//
//  ApplyAccountThreeVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ApplyAccountThreeVC.h"
#import "ApplyAccountFourVC.h"
#import "AccountSign.h"
#import "AccountRepository.h"
#import "BossCommentTabBarCtr.h"
#import "OpenAccountRequest.h"

@interface ApplyAccountThreeVC ()<JXFooterViewDelegate,UITextFieldDelegate>

@end

@implementation ApplyAccountThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavView];
    
    [self initUI];
    self.oneSetPasswordTF.delegate = self;
    self.twoPasswordTF.delegate = self;
}

- (void)initNavView{
    self.title = @"企业认证";
    [self isShowLeftButton:YES];
    
}

- (void)initUI{
    self.oneSetPasswordTF.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    self.twoPasswordTF.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];

    self.oneSetPasswordTF.secureTextEntry = YES;
    self.twoPasswordTF.secureTextEntry = YES;
    
    JXBecomeHunterView * headerView = [JXBecomeHunterView becomeHunterView];
    headerView.frame = CGRectMake(0, 30, SCREEN_WIDTH, 65);
    [self.view addSubview:headerView];

    JXFooterView * footerView = [JXFooterView footerView];
    footerView.frame = CGRectMake((SCREEN_WIDTH - 270) * 0.5, CGRectGetMaxY(self.twoView.frame) + 25, 270, 60);
    footerView.nextLabel.text = @"提交";
    footerView.delegate = self;
    [self.view addSubview:footerView];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController pushViewController:[[ApplyAccountFourVC alloc] init] animated:YES];
    
    if (textField == self.oneSetPasswordTF)
    {
        if (range.location >= 20)
        {
            return NO;
        }
    }
    
    if (textField == self.twoPasswordTF)
    {
        if (range.location >= 20)
        {
            return NO;
        }
    }

    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    if (jxFooterView.nextBtn.selected)
    {
        //如果当前是选中的状态就不执行任何代码，防止多次请求网络数据
        jxFooterView.nextBtn.selected = NO;
    }
    else
    {
        if (self.oneSetPasswordTF.text.length < 6) {
            [PublicUseMethod showAlertView:NSLocalizedString(@"password length must be 6-24 bit character", @"")];
            return;
        }
        
        if (![self.twoPasswordTF.text isEqualToString:self.oneSetPasswordTF.text]) {
            
            [PublicUseMethod showAlertView:NSLocalizedString(@"two times the password is not consistent", @"")];
            return;
        }

    }
    
    
    self.oneSetPasswordTF.text = [self.oneSetPasswordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.twoPasswordTF.text = [self.twoPasswordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([self.oneSetPasswordTF.text length] > 20)
    {
        
        [SVProgressHUD showInfoWithStatus:@"密码长度必须6-20位字符"];
        return;
    }
    if ([self.oneSetPasswordTF.text length] < 6)
    {
        [SVProgressHUD showInfoWithStatus:@"密码长度必须6-20位字符"];
        return ;
    }
    
    
    if (![self.oneSetPasswordTF.text isEqualToString:self.twoPasswordTF.text]) {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"two times the password is not consistent", @"")];
        return;
    }
    OpenAccountRequest * openAccount = [[OpenAccountRequest alloc] init];
    openAccount.Password = self.oneSetPasswordTF.text;
    openAccount.AttestationImages = self.photoArray;
    
    
    [self showLoadingIndicator];
    [AccountRepository OpenAccountWith:openAccount success:^(id result) {
        [self dismissLoadingIndicator];
        
//        Log(@"result===%@",result);
        [PublicUseMethod showAlertView:@"提交成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:[[ApplyAccountFourVC alloc] init] animated:YES];
        });
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"开户提交===%@",error.localizedDescription);
    }];
    
    
//    [AccountRepository ResetPassWordWith:sign success:^(AccountSignResult *result) {
//        NSLog(@"设置密码(long)sult -- %ld",(long)result.SignStatus);
//        
//        [self dismissLoadingIndicator];
//        [PublicUseMethod showAlertView:@"设置密码成功"];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//                [self.navigationController pushViewController:[[ApplyAccountFourVC alloc] init] animated:YES];
//            
////            [PublicUseMethod goViewController:[BossCommentTabBarCtr class]];
//
//        });
//        
//        
//    } fail:^(NSError *error) {
//        [self dismissLoadingIndicator];
//        [PublicUseMethod showAlertView:@"设置密码失败"];
//        
//    }];
    

}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    [self.view endEditing:YES];
//    
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    return YES;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
