//
//  IWComposePhotoView.m
//  WeiBo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

#import "IWComposePhotoView.h"


@interface IWComposePhotoView()

/**
 *  删除按钮
 */
@property (nonatomic, weak) UIButton *deleteBtn;

@end
@implementation IWComposePhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //开启点击交互。如果不开启，他自己包括其子控件，都不能点击
        self.userInteractionEnabled = YES;
        
        //添加删除按钮
        UIButton *deleteBtn = [[UIButton alloc] init];
        [deleteBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        //利用btn当前的image去设置button的大小
        deleteBtn.size = deleteBtn.currentImage.size;
        //添加点击事件
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //调整删除按钮的位置
    //贴右
    self.deleteBtn.x = self.width - self.deleteBtn.width;
    
    //贴上
    self.deleteBtn.y = 0;
    
}

- (void)deleteBtnClick:(UIButton *)btn{
    NSLog(@"删除");
    NSLog(@"删除%@",self);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        //在动画执行完成之后去移除
        [self removeFromSuperview];
        
        //SC.XJH.12.4监听代理
        if ([_delegate respondsToSelector:@selector(deleteImage)]) {
            [_delegate deleteImage];
        }
    }];
}

@end

