//
//  SectionView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/9.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *StaffNumberLabel;

+(instancetype)sectionView;

@end
