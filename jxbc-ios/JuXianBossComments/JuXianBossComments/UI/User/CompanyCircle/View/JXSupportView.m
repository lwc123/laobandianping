//
//  JXSupportView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXSupportView.h"

@implementation JXSupportView

- (void)awakeFromNib{
    
    [super awakeFromNib];

    
}

#pragma mark - 切换   直接在xib中这只tag  在这根据tag来判断是否显示
#pragma mark -- 推荐
- (IBAction)tabBUtton:(UIButton *)button {//20
    
    self.selectedBtn = button;
    if (self.selectedBtn.tag == 20) {
        
        [self.recommend setImage:[UIImage imageNamed:@"tuijisnxuam"] forState:UIControlStateNormal];
        [self.noRecommendBtn setImage:[UIImage imageNamed:@"butuijianno@"] forState:UIControlStateNormal];

        
    }else if (self.selectedBtn.tag == 21){
        
        [self.recommend setImage:[UIImage imageNamed:@"tuijianno"] forState:UIControlStateNormal];
        [self.noRecommendBtn setImage:[UIImage imageNamed:@"butuijianxuan"] forState:UIControlStateNormal];
    }
    
    if ([self.delegate respondsToSelector:@selector(supportViewDelegateRecommend:click:)]) {
        [self.delegate supportViewDelegateRecommend:self click:button];
    }
}

#pragma mark -- 是否支持CEO
- (IBAction)supporClick:(UIButton *)button {//30
    
    self.selectedBtn = button;
    if (self.selectedBtn.tag == 30) {

        [self.supportBtn setImage:[UIImage imageNamed:@"zhichixuan"] forState:UIControlStateNormal];
        [self.noSupportBtn setImage:[UIImage imageNamed:@"buzhichino"] forState:UIControlStateNormal];

    }else if (self.selectedBtn.tag == 31){
        
        [self.supportBtn setImage:[UIImage imageNamed:@"zhichino"] forState:UIControlStateNormal];
        [self.noSupportBtn setImage:[UIImage imageNamed:@"buzhichixuan"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(supportViewDelegateSupport:click:)]) {
        [self.delegate supportViewDelegateSupport:self click:button];
    }
}

#pragma mark -- 是否看好公司
- (IBAction)goodCilck:(UIButton *)button {//40
    
    self.selectedBtn = button;
    if (self.selectedBtn.tag == 40) {
        
        [self.goodBtn setImage:[UIImage imageNamed:@"kanhaoxuan"] forState:UIControlStateNormal];
        [self.sameAsBtn setImage:[UIImage imageNamed:@"yibanno"] forState:UIControlStateNormal];
        [self.badBtn setImage:[UIImage imageNamed:@"bukanhaono"] forState:UIControlStateNormal];

        
    }else if (self.selectedBtn.tag == 41){
        
        [self.goodBtn setImage:[UIImage imageNamed:@"kanhaono"] forState:UIControlStateNormal];
        [self.sameAsBtn setImage:[UIImage imageNamed:@"yibanxuan"] forState:UIControlStateNormal];
        [self.badBtn setImage:[UIImage imageNamed:@"bukanhaono"] forState:UIControlStateNormal];

    }else if (self.selectedBtn.tag == 42){
        
        [self.goodBtn setImage:[UIImage imageNamed:@"kanhaono"] forState:UIControlStateNormal];
        [self.sameAsBtn setImage:[UIImage imageNamed:@"yibanno"] forState:UIControlStateNormal];
        [self.badBtn setImage:[UIImage imageNamed:@"bukanhaoxuan"] forState:UIControlStateNormal];
    }
    if ([self.delegate respondsToSelector:@selector(supportViewDelegateGood:click:)]) {
        [self.delegate supportViewDelegateGood:self click:button];
    }
    
}


+ (instancetype)supportView{

    return [[NSBundle mainBundle] loadNibNamed:@"JXSupportView" owner:nil options:nil].lastObject;
}

@end
