//
//  SliderTableViewCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SliderTableViewCell.h"

@interface SliderTableViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture1;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture2;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture3;

@end

@implementation SliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.abilitySlider.minimumTrackTintColor = [PublicUseMethod setColor:KColor_GoldColor];
    self.attitudeSlider.minimumTrackTintColor = [PublicUseMethod setColor:KColor_GoldColor];
    self.achievementSlider.minimumTrackTintColor = [PublicUseMethod setColor:KColor_GoldColor];
    // 添加点击手势
    self.tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.tapGesture1.delegate = self;
    [self.abilitySlider addGestureRecognizer: self.tapGesture1];
    
    self.tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.tapGesture2.delegate = self;
    [self.attitudeSlider addGestureRecognizer: self.tapGesture2];
    
    self.tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    self.tapGesture3.delegate = self;
    [self.achievementSlider addGestureRecognizer: self.tapGesture3];

}
#pragma mark - 单击手势响应方法:
- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
    UISlider* slider = (UISlider*)sender.view;
    CGPoint touchPoint = [sender locationInView:slider];
    CGFloat value = (slider.maximumValue - slider.minimumValue) * (touchPoint.x / slider.frame.size.width );
    [slider setValue:value animated:YES];
    
    
    if (slider == self.abilitySlider) {
        [self abilitySliderLinkage:slider];
        if ([_delegate respondsToSelector:@selector(sliderCell:WithIndexPath:slider:score:)]) {
            [_delegate sliderCell:self WithIndexPath:self.indexPath slider:self.abilitySlider score:self.abilityScore.text];
        }

    }else if (slider == self.attitudeSlider){
        [self attitudeSliderLinkage:slider];
        if ([_delegate respondsToSelector:@selector(sliderCell:WithIndexPath:slider:score:)]) {
            [_delegate sliderCell:self WithIndexPath:self.indexPath slider:slider score:self.attitudeScore.text];
        }


    }else if (slider == self.achievementSlider){
        [self achievementSliderLinkage:slider];
        if ([_delegate respondsToSelector:@selector(sliderCell:WithIndexPath:slider:score:)]) {
            [_delegate sliderCell:self WithIndexPath:self.indexPath slider:slider score:self.achievementScore.text];
        }

    }else{}
    
}

- (IBAction)sliderTouchDown:(UISlider *)sender {
    if (sender == self.abilitySlider) {
        self.tapGesture1.enabled = NO;

    }else if (sender == self.attitudeSlider){
        self.tapGesture2.enabled = NO;
        
    }else if (sender == self.achievementSlider){
        self.tapGesture3.enabled = NO;

    }else{}

}

- (IBAction)sliderTouchUp:(UISlider *)sender {
    if (sender == self.abilitySlider) {
        self.tapGesture1.enabled = YES;
        
    }else if (sender == self.attitudeSlider){
        self.tapGesture2.enabled = YES;
        
    }else if (sender == self.achievementSlider){
        self.tapGesture3.enabled = YES;
        
    }else{}
}

//SC.XJH.12.7这个cell大改了
- (IBAction)abilityClick:(UISlider *)sender {
    [self abilitySliderLinkage:sender];
    if ([_delegate respondsToSelector:@selector(sliderCell:WithIndexPath:slider:score:)]) {
        [_delegate sliderCell:self WithIndexPath:self.indexPath slider:sender score:self.abilityScore.text];
    }
}

- (IBAction)attitudeClick:(UISlider *)sender {
    
    [self attitudeSliderLinkage:sender];
    if ([_delegate respondsToSelector:@selector(sliderCell:WithIndexPath:slider:score:)]) {
        [_delegate sliderCell:self WithIndexPath:self.indexPath slider:sender score:self.attitudeScore.text];
    }
}

- (IBAction)achievementClick:(UISlider *)sender {
    [self achievementSliderLinkage:sender];
    if ([_delegate respondsToSelector:@selector(sliderCell:WithIndexPath:slider:score:)]) {
        [_delegate sliderCell:self WithIndexPath:self.indexPath slider:sender score:self.achievementScore.text];
    }
}

- (void)drawRect:(CGRect)rect{
    [self abilitySliderLinkage:self.abilitySlider];
    [self attitudeSliderLinkage:self.attitudeSlider];
    [self achievementSliderLinkage:self.achievementSlider];
    //    [self setNeedsDisplay];
}

- (void)abilitySliderLinkage:(UISlider *)sender{
    int progress = sender.value;
    if (progress >= 0 && progress < 29 ) {
        
        self.abilityGood.text = @"极差";
    }
    if (progress >= 30 && progress < 59) {
        self.abilityGood.text = @"差";
        
    }
    if (progress >= 60 && progress < 79) {
        self.abilityGood.text = @"一般";
    }
    
    if (progress >= 80 && progress < 89) {
        self.abilityGood.text = @"良好";
    }
    
    if (progress >= 90 && progress < 100) {
        self.abilityGood.text = @"优秀";
        
    }
    self.abilityScore.text = [NSString stringWithFormat:@"%d",progress];
    
    CGRect rect = CGRectOffset(CGRectInset([sender thumbRectForBounds:sender.bounds trackRect:[sender trackRectForBounds:sender.bounds] value:sender.value],0 , -1), 20, 25);
    
    self.abilityScore.centerX = rect.origin.x + 8;
    self.abilityScore.centerY = rect.origin.y + 15;
}

- (void)attitudeSliderLinkage:(UISlider *)sender{
    int progress = sender.value;
    self.attitudeScore.text = [NSString stringWithFormat:@"%d",progress];
    
    if (progress >= 0 && progress < 29 ) {
        
        self.attitudeGood.text = @"极差";
    }
    if (progress >= 30 && progress < 59) {
        self.attitudeGood.text = @"差";
        
    }
    if (progress >= 60 && progress < 79) {
        self.attitudeGood.text = @"一般";
    }
    
    if (progress >= 80 && progress < 89) {
        self.attitudeGood.text = @"良好";
    }
    
    if (progress >= 90 && progress < 100) {
        self.attitudeGood.text = @"优秀";
        
    }
    
    CGRect rect = CGRectOffset(CGRectInset([sender thumbRectForBounds:sender.bounds trackRect:[sender trackRectForBounds:sender.bounds] value:sender.value], 2, -1), 20, 25);
    self.attitudeScore.centerX = rect.origin.x + 8;
    self.attitudeScore.centerY = rect.origin.y + 15;

}

- (void)achievementSliderLinkage:(UISlider *)sender{
    int progress = sender.value;
    
    if (progress >= 0 && progress < 29 ) {
        
        self.achievementGood.text = @"极差";
    }
    if (progress >= 30 && progress < 59) {
        self.achievementGood.text = @"差";
        
    }
    if (progress >= 60 && progress < 79) {
        self.achievementGood.text = @"一般";
    }
    
    if (progress >= 80 && progress < 89) {
        self.achievementGood.text = @"良好";
    }
    
    if (progress >= 90 && progress < 100) {
        self.achievementGood.text = @"优秀";
    }
    self.achievementScore.text = [NSString stringWithFormat:@"%d",progress];
    
    CGRect rect = CGRectOffset(CGRectInset([sender thumbRectForBounds:sender.bounds trackRect:[sender trackRectForBounds:sender.bounds] value:sender.value], 2, -1), 20, 25);
    self.achievementScore.centerX = rect.origin.x + 8;
    self.achievementScore.centerY = rect.origin.y + 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
