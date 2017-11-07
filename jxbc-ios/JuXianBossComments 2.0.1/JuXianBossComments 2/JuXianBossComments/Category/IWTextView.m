//
//  IWTextView.m
//  WeiBo
//
//  Created by apple on 15/7/19.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

#import "IWTextView.h"

//默认的占位文字颜色
#define PLACEHOLDER_DEFAULT_COLOR [UIColor grayColor]

#define PLACEHOLDER_DEFAULT_FONT SYS_FONT(12)

@interface IWTextView()<UITextViewDelegate>

//占位文字显示的label
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation IWTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置一个默认的字体
        self.font = [UIFont systemFontOfSize:13.0];
        
        //添加placeholderLabel ;
        UILabel *placeholderLabel = [[UILabel alloc] init];
        //设置默认颜色
        placeholderLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        //设置默认文字大小
        placeholderLabel.font = [UIFont systemFontOfSize:15.0];
        
        //设置多行
        placeholderLabel.numberOfLines = 0;
        
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
        
//        self.delegate = selfb;
        [IWNotificationCenter addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)textDidChange:(NSNotification *)noti{
    self.placeholderLabel.hidden = self.text.length;
}

//这是代理里面的方法，最好不要用。自已最好不要成为自己的代理
- (void)textViewDidChange:(UITextView *)textView{
//    if (textView.text.length>0) {
//        self.placeholderLabel.hidden = YES;
//    }else{
//        self.placeholderLabel.hidden = NO;
//    }
    
    self.placeholderLabel.hidden = textView.text.length;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.placeholderLabel.x = 5;
    self.placeholderLabel.y = 8;
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    //调用占位label的文字大小
    self.placeholderLabel.font = font;
    
    [self adjustPlaceholderLabelSize];
}

/**
 *  复写placeholder的set方法，在里面设置placeholderLabel的文字
 *
 *  @param placeholder <#placeholder description#>
 */
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    
    [self adjustPlaceholderLabelSize];

}


- (void)setText:(NSString *)text{
    [super setText:text];
    self.placeholderLabel.hidden = self.text.length;
}

- (void)adjustPlaceholderLabelSize{
    
    
    CGSize size = [self.placeholder sizeWithFont:self.placeholderLabel.font constrainedToSize:CGSizeMake(self.width-10, MAXFLOAT)];
    self.placeholderLabel.size = size;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)dealloc{
    [IWNotificationCenter removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


@end
