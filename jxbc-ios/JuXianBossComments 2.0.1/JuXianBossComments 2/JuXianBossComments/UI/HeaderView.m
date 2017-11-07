//
//  HeaderView.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

+ (instancetype)headerView{

    return [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 35;

}

@end
