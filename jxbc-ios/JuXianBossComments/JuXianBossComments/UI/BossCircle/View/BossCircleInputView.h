//
//  BossCircleInputView.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SendButtonClickBlock)();

@interface BossCircleInputView : UIView

// 输入框
@property (nonatomic, strong) UITextField *inputView;
// 发送按钮
@property (nonatomic, strong) UIButton *sendButton;

+ (instancetype)inputView;

- (void)SendButtonClickComplete:(SendButtonClickBlock )sendButtonClickBlock;

@end
