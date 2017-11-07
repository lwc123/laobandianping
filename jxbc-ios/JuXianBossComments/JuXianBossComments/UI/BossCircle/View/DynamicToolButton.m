//
//  DynamicToolButton.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "DynamicToolButton.h"

@implementation DynamicToolButton

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self);
        make.width.height.mas_equalTo(18);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.imageView.mas_right).offset(7);
        make.width.mas_equalTo(25);
        make.top.bottom.right.equalTo(self);
        
    }];
    
}

@end
