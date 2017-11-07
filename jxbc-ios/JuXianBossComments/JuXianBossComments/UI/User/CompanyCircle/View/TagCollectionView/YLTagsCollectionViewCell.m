//
//  YLTagsCollectionViewCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "YLTagsCollectionViewCell.h"


#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation YLTagsCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //此处可以根据需要自己使用自动布局代码实现
        _btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _btn.backgroundColor = [UIColor whiteColor];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn.layer.borderWidth = 1.f;
//        _btn.layer.cornerRadius = frame.size.height/2.0;
        _btn.layer.cornerRadius = 4;
        _btn.layer.masksToBounds = YES;
        [_btn setTitleColor:[PublicUseMethod setColor:KColor_tags] forState:UIControlStateNormal];
        _btn.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        _btn.userInteractionEnabled = NO;
        [self.contentView addSubview:_btn];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _btn.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    _btn.layer.borderColor = selected?[PublicUseMethod setColor:KColor_Add_BlckBlueColor].CGColor:[PublicUseMethod setColor:KColor_tags].CGColor;
    
    [_btn setTitleColor:selected?[PublicUseMethod setColor:KColor_Add_BlckBlueColor]:[PublicUseMethod setColor:KColor_tags] forState:UIControlStateNormal];
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    _btn.layer.borderColor = highlighted?HEXCOLOR(0xffb400).CGColor:HEXCOLOR(0xdddddd).CGColor;
    
    
    _btn.layer.borderColor = highlighted?[UIColor yellowColor].CGColor:[UIColor cyanColor].CGColor;

    
    [_btn setTitleColor:highlighted?HEXCOLOR(0xffb400):HEXCOLOR(0x666666) forState:UIControlStateNormal];
}

@end
