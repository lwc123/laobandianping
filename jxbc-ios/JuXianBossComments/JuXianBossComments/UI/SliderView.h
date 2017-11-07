//
//  SliderView.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderView : UIView
/**能力*/
@property (weak, nonatomic) IBOutlet UISlider *abilitySlider;
@property (weak, nonatomic) IBOutlet UILabel *abilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *abilityScore;


/**态度*/
@property (weak, nonatomic) IBOutlet UISlider *attitudeSlider;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeScore;



/**业绩*/
@property (weak, nonatomic) IBOutlet UISlider *achievementSlider;
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievementScore;


@property (weak, nonatomic) IBOutlet UILabel *temLabel;

@property (nonatomic,strong)NSTimer * timer;

+ (instancetype)sliderView;

@end
