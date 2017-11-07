//
//  JCTagCell.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagCell.h"
@interface JCTagCell()
{
    UIImage *img;
}
@end
@implementation JCTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 1.0f;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,frame.size.width-20, frame.size.height)];
        _titleLabel.textAlignment = 0;
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        
        img = [UIImage imageNamed:@"shanchu"];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20, (frame.size.height-img.size.height)/2, img.size.width, img.size.height)];
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.image = img;
        
        [self.contentView addSubview:_imgView];
        
        [self.contentView addSubview:_titleLabel];
        //[self.contentView setTintColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake(10, 0,self.frame.size.width-20, self.frame.size.height);
    self.imgView.frame = CGRectMake(self.frame.size.width-20, (self.frame.size.height-img.size.height)/2, img.size.width, img.size.height);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}

@end
