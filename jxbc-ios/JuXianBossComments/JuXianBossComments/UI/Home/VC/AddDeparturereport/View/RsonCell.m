//
//  RsonCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/5.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "RsonCell.h"

@implementation RsonCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.explanTextView = [[IWTextView alloc] init];
    self.explanTextView.frame = CGRectMake(15, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH - 20, 100);
    self.explanTextView.font = [UIFont systemFontOfSize:13.0];
    self.explanTextView.placeholder = @"选填，如有特别情况请说明";
    self.explanTextView.delegate = self;
    
    NSLog(@"%lu",(unsigned long)self.explanTextView.text.length);
    [self.bgView addSubview:self.explanTextView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if (![self.explanTextView isExclusiveTouch]) {
        
        [self.explanTextView resignFirstResponder];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 500) {
        
        self.changeLabel.textColor = [UIColor redColor];
    }else{
        
        self.changeLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        
    }
    self.changeLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
    
    NSLog(@"self.explanTextView===%@",self.explanTextView);
    
    if ([self.delegate respondsToSelector:@selector(resonCell:WithIndexPath:textView:changeText:)]) {
        
        [self.delegate resonCell:self WithIndexPath:self.indexPath textView:self.explanTextView.text changeText:self.changeLabel.text];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
