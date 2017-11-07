//
//  ShareView.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/4.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-209)];
        _maskView.backgroundColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapAction:)]];
        [self addSubview:_maskView];
        //
        _sendFriendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _maskView.bottom, SCREEN_WIDTH/2, 154)];
        [_sendFriendBtn setImage:[UIImage imageNamed:@"weixin"] forState:UIControlStateNormal];
        [_sendFriendBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendFriendBtn setTitle:@"发给微信好友" forState:UIControlStateNormal];
        _sendFriendBtn .titleEdgeInsets = UIEdgeInsetsMake(79, -9, 6, 35);
        [_sendFriendBtn setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        _sendFriendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendFriendBtn.tag = 100;
        _sendFriendBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_sendFriendBtn];
        _sendTimeLineBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, _maskView.bottom, SCREEN_WIDTH/2, 154)];
        [_sendTimeLineBtn setImage:[UIImage imageNamed:@"pengyouquan"] forState:UIControlStateNormal];
        [_sendTimeLineBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sendTimeLineBtn setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
        _sendTimeLineBtn .titleEdgeInsets = UIEdgeInsetsMake(79, -9, 6, 35);
        [_sendTimeLineBtn setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        _sendTimeLineBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _sendTimeLineBtn.tag = 101;
        _sendTimeLineBtn.backgroundColor = [UIColor whiteColor];
        [self addSubview:_sendTimeLineBtn];
        //分割线
        UIView *spaceline = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5,_sendTimeLineBtn.top+28.5, 1, 97)];
        spaceline.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        [self addSubview:spaceline];
        
        //bejing间隔
        UIView *bgGrap = [[UIView alloc]initWithFrame:CGRectMake(0, _sendTimeLineBtn.bottom, SCREEN_WIDTH, 10)];
        bgGrap.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        [self addSubview:bgGrap];
        //
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, _sendTimeLineBtn.bottom+10, SCREEN_WIDTH, 45)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_cancelBtn];
        if (SCREEN_WIDTH==320) {
            _sendFriendBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, 0);
            _sendTimeLineBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, 0);
        }
        else
        {
            _sendFriendBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 72, 0, 0);
            _sendTimeLineBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 72, 0, 0);
        }
        
    }
    return self;
}
//发给微信好友
- (void)shareBtnAction:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(shareButtonIndex:)]) {
        [self.delegate shareButtonIndex:button.tag];
    }
}

- (void)cancelBtnAction:(UIButton*)button
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}
- (void)TapAction:(UITapGestureRecognizer*)tap
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}
@end
