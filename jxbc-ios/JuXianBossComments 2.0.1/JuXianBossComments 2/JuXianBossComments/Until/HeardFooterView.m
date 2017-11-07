//
//  HeardFooterView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/26.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "HeardFooterView.h"

@implementation HeardFooterView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.titleLabel];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 3.5, SCREEN_WIDTH, 23);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
