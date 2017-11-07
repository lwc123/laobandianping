//
//  PublicCommentsCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "PublicCommentsCell.h"

@implementation PublicCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];


    self.myTextView = [[IWTextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topBgView.frame) + 1, SCREEN_WIDTH, 140)];
    self.myTextView.placeholder = @"  输入老板点评或拍摄点评";
    self.myTextView.placeholderColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    self.myTextView.delegate = self;
    NSLog(@"%lu",(unsigned long)self.myTextView.text.length);
    [self.contentView addSubview:self.myTextView];

    
//    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.myTextView.frame), SCREEN_WIDTH, 50)];
//    bgView.backgroundColor = [UIColor lightGrayColor];
//    [self.contentView addSubview:bgView];
//    
//    
//    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40,  self.myTextView.bottom + 20, 40, 12)];
//    label1.textAlignment = NSTextAlignmentLeft;
//    label1.text = @"/500";
//    label1.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
//    label1.font = [UIFont systemFontOfSize:12];
//    
//    self.lenthLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, self.myTextView.bottom + 20, 40, 12)];
//    self.lenthLabel.textAlignment = NSTextAlignmentRight;
//    self.lenthLabel.font = [UIFont systemFontOfSize:12];
//    self.lenthLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
//    self.lenthLabel.text = @"0";
//    [self.contentView addSubview:self.lenthLabel];
//    [self.contentView addSubview:label1];
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![self.myTextView isExclusiveTouch]) {
        
        [self.myTextView resignFirstResponder];
    }
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
