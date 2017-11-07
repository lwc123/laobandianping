//
//  SliderTableViewCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SliderTableViewCellDelegate;

@interface SliderTableViewCell : UITableViewCell

@property (weak, nonatomic) id<SliderTableViewCellDelegate> delegate;
/**能力*/
@property (weak, nonatomic) IBOutlet UISlider *abilitySlider;
@property (weak, nonatomic) IBOutlet UILabel *abilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *abilityScore;
@property (weak, nonatomic) IBOutlet UILabel *abilityGood;
/**态度*/
@property (weak, nonatomic) IBOutlet UISlider *attitudeSlider;
@property (weak, nonatomic) IBOutlet UILabel *attitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *attitudeScore;
@property (weak, nonatomic) IBOutlet UILabel *attitudeGood;

/**业绩*/
@property (weak, nonatomic) IBOutlet UISlider *achievementSlider;
@property (weak, nonatomic) IBOutlet UILabel *achievementLabel;
@property (weak, nonatomic) IBOutlet UILabel *achievementScore;
@property (weak, nonatomic) IBOutlet UILabel *achievementGood;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (nonatomic,strong)NSIndexPath *indexPath;

@end

@protocol SliderTableViewCellDelegate <NSObject>
@optional
- (void)sliderCell:(SliderTableViewCell *)sliderCell WithIndexPath:(NSIndexPath *)indexPath slider:(UISlider *)slider score:(NSString *)score;
@end
