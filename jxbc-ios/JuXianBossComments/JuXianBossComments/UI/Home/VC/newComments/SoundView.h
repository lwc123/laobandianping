//
//  SoundView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/12.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SoundView;

@protocol SoundViewDelegate <NSObject>
@optional
- (void)soundViewDidClickedCacelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView;
@optional
- (void)soundViewDidClickedSurelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView;
@optional
- (void)soundViewDidClickedRecodelWithbutton:(UIButton *)btn WithView:(SoundView *)jxFooterView;

@end

@interface SoundView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *soundImagBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) id<SoundViewDelegate> delegate;

+ (instancetype)soundView;

@end
