//
//  NoStaffView.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "NoStaffView.h"

@implementation NoStaffView


- (void)awakeFromNib{
    [super awakeFromNib];

    self.zaiZhiView.layer.borderWidth = 1;
    self.zaiZhiView.layer.borderColor = [PublicUseMethod setColor:KColor_TabbarColor].CGColor;
    
    self.departureView.layer.borderWidth = 1;
    self.departureView.layer.borderColor = [PublicUseMethod setColor:KColor_TabbarColor].CGColor;
}


+ (instancetype)noStaffView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"NoStaffView" owner:nil options:nil].lastObject;
}



@end
