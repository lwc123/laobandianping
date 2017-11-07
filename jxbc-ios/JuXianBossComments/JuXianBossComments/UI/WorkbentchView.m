//
//  workbentchView.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "WorkbentchView.h"

@implementation WorkbentchView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.myLabel.hidden = YES;

    self.unReadMassage.layer.cornerRadius = 9;
    self.unReadMassage.layer.masksToBounds = YES;
    self.unReadMassage.layer.borderWidth = 1;
    self.unReadMassage.layer.borderColor = [PublicUseMethod setColor:KColor_RedColor].CGColor;
    
    self.fixUnreadMessage.layer.cornerRadius = 9;
    self.fixUnreadMessage.layer.masksToBounds = YES;
    self.fixUnreadMessage.layer.borderWidth = 1;
    self.fixUnreadMessage.layer.borderColor = [PublicUseMethod setColor:KColor_RedColor].CGColor;
    
    self.userUnRead.layer.cornerRadius = 9;
    self.userUnRead.layer.masksToBounds = YES;
    self.userUnRead.layer.borderWidth = 1;
    self.userUnRead.layer.borderColor = [PublicUseMethod setColor:KColor_RedColor].CGColor;
    
}


+ (instancetype)workbentchView{
    return [[NSBundle mainBundle] loadNibNamed:@"WorkbentchView" owner:nil options:nil].lastObject;
}

@end
