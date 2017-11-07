//
//  GetMoneyView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "GetMoneyView.h"

@implementation GetMoneyView

+ (instancetype)getMoneyView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"GetMoneyView" owner:nil options:nil].lastObject;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.putMoneyLabel.keyboardType = UIKeyboardTypeNumberPad;
    
    AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
    if (myaccount.UserProfile.CurrentProfileType == UserProfile) {// 个人
        self.accountTitleLabel.text = @"口袋余额：";
        self.bankAccountLabel.text = @"  个人银行账号";
    }

}

@end
