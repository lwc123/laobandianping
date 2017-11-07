//
//  NilView.m
//  JuXianTalentBank
//
//  Created by  on 16/5/23.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "NilView.h"

@interface NilView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NilView


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

- (void)setIsHiddenButton:(BOOL)isHiddenButton{

    UIButton *bt = [self viewWithTag:2000];
    
    bt.hidden = isHiddenButton;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)createNilView{
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 64) * 0.5, 40, 64, 64)];
    self.imageView.image = [UIImage imageNamed:@"不开心"];
    self.imageView.tag = 2005;
    
    [self addSubview:self.imageView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 18, SCREEN_WIDTH, 14)];
    label.text = self.labelStr;
    label.tag = 1000;
    label.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
   
    
    UIButton *refreshBt = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBt.frame = self.imageView.frame;
    
    refreshBt.backgroundColor = [UIColor clearColor];
    
    [refreshBt addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refreshBt];
   UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120) * 0.5, CGRectGetMaxY(label.frame)+18,120, 40)];
        button.tag = 2000;
    [button setTitle:@" " forState:UIControlStateNormal];
    
    [button setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"timeButton"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
    [self addSubview:button];


}

- (void)setImage:(UIImage *)image{

    if (image) {
        _image = image;
        self.imageView.image = image;
    }
    
}
- (void)setButtonTitle:(NSString *)buttonTitle{
    if (buttonTitle) {
       UIButton* btn = [self viewWithTag:2000];
        [btn setTitle:buttonTitle forState:UIControlStateNormal];
    }

}

- (void)refreshAction{

    if (self.block) {
        self.block();
    }

}
@end
