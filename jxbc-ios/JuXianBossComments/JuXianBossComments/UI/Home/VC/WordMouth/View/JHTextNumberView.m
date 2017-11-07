//
//  JHTextNumberView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHTextNumberView.h"


@interface JHTextNumberView ()<UITextViewDelegate>

@property (nonatomic, strong) UILabel *changeLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, copy) NSString *numberText;
@property (nonatomic, copy) NSString *placehoder;
@property (nonatomic, assign) CGFloat textViewHeight;
@end

@implementation JHTextNumberView

- (instancetype)initWithplacehoder:(NSString *)placehoder
                        numbertaxt:(NSString *)numberText
                    textViewHeight:(CGFloat)textViewHeight{

    if (self = [super initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 100)]) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.numberText = numberText;
        self.placehoder = placehoder;
        self.textViewHeight = textViewHeight;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.myTextView];
    [self addSubview:self.changeLabel];
    [self addSubview:self.numberLabel];
}

- (IWTextView *)myTextView{
    
    if (_myTextView == nil) {
        _myTextView =[[IWTextView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.textViewHeight)];
        _myTextView.placeholder = self.placehoder;
        _myTextView.placeholderColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        _myTextView.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        _myTextView.delegate = self;
    }
    return _myTextView;
}

- (UILabel *)changeLabel{
    
    if (_changeLabel == nil) {
        
        _changeLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTextView.frame), self.size.width - 40, 20) title:@"0" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
        _changeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _changeLabel;
}

- (UILabel *)numberLabel{
    if (_numberLabel == nil) {
        
        _numberLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.changeLabel.frame), CGRectGetMaxY(self.myTextView.frame), 40, 20) title:[NSString stringWithFormat:@"/%@",self.numberText] titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:11.0 numberOfLines:1];
    }
    return _numberLabel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.myTextView isExclusiveTouch]) {
        
        [self.myTextView resignFirstResponder];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > [self.numberText integerValue]) {
        
        self.changeLabel.textColor = [UIColor redColor];
    }else{
        self.changeLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
}

@end
