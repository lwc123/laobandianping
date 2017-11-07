//
//  CommentsView.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CommentsView.h"
#import "IWTextView.h"

@implementation CommentsView

+ (instancetype)commentsView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"CommentsView" owner:nil options:nil].lastObject;
    
}

- (void)awakeFromNib{

    [super awakeFromNib];
    self.myTextView = [[IWTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), SCREEN_WIDTH, 140)];
//    self.myTextView.backgroundColor = [UIColor yellowColor];
    self.myTextView.placeholder = @"  输入老板点评或拍摄点评";
    self.myTextView.delegate = self;
//    self.myTextView.text = @"你哪里看进来就埃里克借记卡你哪里看进来就埃里克借记卡你哪里看进来就埃里克借记卡你哪里看进来就埃里克借记";
    NSLog(@"%lu",(unsigned long)self.myTextView.text.length);
    [self addSubview:self.myTextView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40,  self.myTextView.bottom + 10, 40, 12)];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"/500";
    label1.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    label1.font = [UIFont systemFontOfSize:12];
    
    
    self.lenthLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, self.myTextView.bottom + 10, 40, 12)];
    self.lenthLabel.textAlignment = NSTextAlignmentRight;
    self.lenthLabel.font = [UIFont systemFontOfSize:12];
    self.lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.lenthLabel.text = @"0";
    [self addSubview:self.lenthLabel];
    [self addSubview:label1];
    
    self.voiceImage = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.myTextView.frame), 146, 36)];
    self.voiceImage.titleLabel.font = [UIFont systemFontOfSize:14.0];
//    self.voiceImage.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.voiceImage setImage:[UIImage imageNamed:@"shuohua"] forState:UIControlStateNormal];
    self.voiceImage.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 10, 0);
    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 11, 17)];
//    imageView.image = [UIImage imageNamed:@"shuohua"];
//    [self.voiceImage addSubview:imageView];
    
    self.voiceImage.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 10, 0);
    [self addSubview:self.voiceImage];
    self.deleteVoiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.voiceImage.frame), CGRectGetMaxY(self.myTextView.frame), 14, 14)];
    [self addSubview:self.deleteVoiceBtn];

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (![self.myTextView isExclusiveTouch]) {
        
        [self.myTextView resignFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 500) {
        
        _lenthLabel.textColor = [UIColor redColor];
    }else{
        
        _lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        
    }
    _lenthLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
}

@end
