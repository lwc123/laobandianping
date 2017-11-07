//
//  BossCircleInputView.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircleInputView.h"

@interface BossCircleInputView ()<UITextFieldDelegate>

// 背景
@property (nonatomic, strong) UIView *bgView;

// 回调
@property (nonatomic, copy) SendButtonClickBlock sendButtonClickBlock;


@end

@implementation BossCircleInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorWithHex(@"C7C7C7");
        
        [self addSubview:self.bgView];
        [self addSubview:self.inputView];
        [self addSubview:self.sendButton];
        
        
    }
    return self;
}

+ (instancetype)inputView{
    
    BossCircleInputView *view = [[BossCircleInputView alloc]initWithFrame:CGRectZero];;
    
    return view;
}

- (void)sendButtonClick{

    self.sendButton.enabled = NO;
    Log(@"发送按钮点击");
    if (self.sendButtonClickBlock) {
        self.sendButtonClickBlock();
    }
}

// 回调
- (void)SendButtonClickComplete:(SendButtonClickBlock)sendButtonClickBlock{

    self.sendButtonClickBlock = sendButtonClickBlock;
    
}

#pragma mark - textfield delegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if ([string isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        if (textField.text.length - range.length + string.length > 140) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超出最大可输入长度140字" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            
            [alert show];
            return NO;
        }
        else {
            return YES;
        }
    }

    
}

#pragma mark - 布局
- (void)layoutSubviews{

    [super layoutSubviews];
    
    // 背景
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(0.5);
        make.right.bottom.equalTo(self).offset(-0.5);
    }];
    
    // 发送按钮
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-5);
        make.bottom.equalTo(self).offset(-8);
        make.width.mas_equalTo(46);
    }];
    
    // 输入框
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.right.equalTo(self.sendButton.mas_left).offset(-12);
        make.height.mas_equalTo(28);
        make.centerY.equalTo(self);
        
    }];
    
    
    
}

#pragma mark - lazy load

- (UIView *)inputView{

    if (_inputView == nil) {
        _inputView = [[UITextField alloc] init];
        _inputView.placeholder = @"说点什么";
        _inputView.font = [UIFont systemFontOfSize:15];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _inputView.borderStyle = UITextBorderStyleRoundedRect;
        _inputView.delegate = self;
    }
    return _inputView;
    
}

- (UIButton *)sendButton{

    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateHighlighted];
        [_sendButton setBackgroundColor:ColorWithHex(@"D4BA77")];
        _sendButton.layer.cornerRadius = 5;
        _sendButton.clipsToBounds = YES;
        
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendButton;
    
}

- (UIView *)bgView{

    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = ColorWithHex(@"FAFAFA");
    }
    return _bgView;
    
}


@end


