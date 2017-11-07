//
//  IWTextView.h
//  WeiBo
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWTextView : UITextView

//提供使用的人设置里面占位文字的内容
@property(nonatomic,copy) NSString *placeholder;
//提供给外界，设置占位label的文字颜色
@property (nonatomic, strong) UIColor *placeholderColor;

@end
