//
//  TopAlertView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/5.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopAlertView;

@protocol TopAlertViewDelegate <NSObject>

@optional
- (void)topAlertViewDidClickedOffBtn:(TopAlertView *)alertView;
@optional
- (void)topAlertViewAddRecodeOnPc:(TopAlertView *)alertView;

@end

@interface TopAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (nonatomic,weak) id<TopAlertViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *addOnPcBtn;

@property (weak, nonatomic) IBOutlet UIButton *delagateBtn;
+ (instancetype)topAlertView;

@end
