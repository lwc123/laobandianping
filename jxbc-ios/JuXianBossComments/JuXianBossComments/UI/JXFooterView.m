//
//  JXFooterView.m
//  JuXianTalentBank
//
//  Created by juxian on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXFooterView.h"
//#import "ApplyHunterVC.h"
//#import "ApplyTwoStepVC.h"

@implementation JXFooterView


- (void)awakeFromNib{
    [super awakeFromNib];
    _nextLabel.layer.masksToBounds = YES;
    _nextLabel.layer.cornerRadius = 5;
    _nextBtn.frame = _nextLabel.frame;

    
//    NSMutableArray *colorArray2 = [@[[PublicUseMethod setColor:@"DCC37F "],[PublicUseMethod setColor:@"F7E6B9"],[PublicUseMethod setColor:@"AF8F4D "]] mutableCopy];
//    
//    UIImage * bgImage = [_nextBtn buttonImageFromColors:colorArray2 ByGradientType:leftToRight];
//    [_nextBtn setBackgroundImage:bgImage forState:UIControlStateNormal];loginbutton.png

//    loginbutton.png
    self.nextBtn.layer.cornerRadius = 4.0;
    self.nextBtn.layer.masksToBounds = YES;
    self.nextBtn.layer.borderWidth = 2;
    self.nextBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
}



+ (instancetype)footerView{

    return [[NSBundle mainBundle] loadNibNamed:@"JXFooterView" owner:nil options:nil].lastObject;
}
- (IBAction)nextBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(jxFooterViewDidClickedNextBtn:)]) {
        [self.delegate jxFooterViewDidClickedNextBtn:self];
    }
    
}



@end
