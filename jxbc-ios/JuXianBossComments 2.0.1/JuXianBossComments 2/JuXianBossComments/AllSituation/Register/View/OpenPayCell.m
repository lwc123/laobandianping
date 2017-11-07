//
//  OpenPayCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "OpenPayCell.h"

@implementation OpenPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.demoBtn.layer.masksToBounds = YES;
    self.demoBtn.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
