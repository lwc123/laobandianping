
//
//  SliderView.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SliderView.h"

@implementation SliderView


+ (instancetype)sliderView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SliderView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.abilitySlider.minimumTrackTintColor = [PublicUseMethod setColor:KColor_MainColor];
    self.attitudeSlider.minimumTrackTintColor = [PublicUseMethod setColor:KColor_MainColor];
    self.achievementSlider.minimumTrackTintColor = [PublicUseMethod setColor:KColor_MainColor];
//    self.abilitySlider setThumbImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    self.temLabel.backgroundColor = [UIColor yellowColor];
    self.temLabel.textColor = [UIColor blueColor];
}


//工作能力
- (IBAction)abilityClick:(UISlider *)sender {
    int progress = sender.value;
    self.abilityScore.text = [NSString stringWithFormat:@"%d分",progress];
    self.temLabel.text = [NSString stringWithFormat:@"%d分",progress];
    
//    self.temLabel.frame = CGRectMake(10 + (sender.value/100)*sender.width, 20, 40, 13);
    NSLog(@"sender.width==%f",(sender.value/100)*sender.width+10);
    
    //以下两段代码都实现了
    //这是我写的
//    for (UIView *view in sender.subviews) {
//        if ([view isKindOfClass:NSClassFromString(@"UIImageView")]) {
//            if (view.subviews.count>0) {
////                NSLog(@"view.centerX=%f,view.x%f,view.width=%f",view.centerX,view.x,view.width);
//                self.temLabel.centerX = view.centerX+15;
//            }
//        }
//    }
    
    //这是在自定义的slider中提取的，代码在RGSColorSlider.m的第80行和第105行的方法中
    CGRect rect = CGRectOffset(CGRectInset([sender thumbRectForBounds:sender.bounds trackRect:[sender trackRectForBounds:sender.bounds] value:sender.value], -1, -1), 15, 12);
    self.temLabel.frame = rect;
    
//    if (progress > 50 && progress < 60) {
//        
//        self.abilityLabel.text = @"差";
//    }else if (progress > 60 && progress < 70){
//    
//        self.abilityLabel.text = @"良好";
//
//    
//    }else{
//    
//    self.abilityLabel.text = @"优秀";
//    }
    
    
}

//工作态度
- (IBAction)attitudeClick:(UISlider *)sender {
    int progress = sender.value;
    self.attitudeScore.text = [NSString stringWithFormat:@"%d分",progress];
}

//工作业绩
- (IBAction)achievementClick:(UISlider *)sender {
    int progress = sender.value;
    self.achievementScore.text = [NSString stringWithFormat:@"%d分",progress];    
}





@end
