//
//  JHNilView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHNilView.h"

@implementation JHNilView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createNilView];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createNilView];
    }
    
    return self;
}

- (void)setLabelStr:(NSString *)labelStr{
    
    _labelStr = labelStr;
    UILabel *label = [self viewWithTag:1000];
    
    label.text = _labelStr;
    
}

- (void)setMyStr:(NSString *)myStr{

    _myStr = myStr;
    UILabel *label = [self viewWithTag:1001];
    label.text = _myStr;
}

- (void)createNilView{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 64) * 0.5, 40, 64, 64)];
    imageView.image = [UIImage imageNamed:@"不开心"];
    imageView.tag = 2005;
    
    [self addSubview:imageView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 160) * 0.5, CGRectGetMaxY(imageView.frame) + 25, 160, 14)];
    label.text = self.labelStr;
    label.tag = 1000;
    label.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    [self addSubview:label];
    
    UILabel * myLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 160) * 0.5, CGRectGetMaxY(label.frame)+18,160, 60)];
    myLabel.tag = 1001;
    myLabel.numberOfLines = 0;
    myLabel.text = self.myStr;
    myLabel.textAlignment = NSTextAlignmentLeft;
    myLabel.font = [UIFont systemFontOfSize:14.0];

    myLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    [self addSubview:myLabel];
}

@end
