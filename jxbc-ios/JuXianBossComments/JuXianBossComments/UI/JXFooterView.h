//
//  JXFooterView.h
//  JuXianTalentBank
//
//  Created by juxian on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorButton.h"
@class JXFooterView;

@protocol JXFooterViewDelegate <NSObject>

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView;

@end

@interface JXFooterView : UIView
@property (weak, nonatomic) IBOutlet ColorButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *nextLabel;


@property (nonatomic,weak) id<JXFooterViewDelegate> delegate;

+(instancetype)footerView;


@end
