//
//  XJHAlertView.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJHAlertView;
@protocol XJHAlertViewDelegate <NSObject>

/**
 点击关闭按钮
 */
- (void)xjhAlertViewDidClickOffBtn:(XJHAlertView *)jhAlertView;
/**
 点击充值按钮
 */
- (void)xjhAlertViewDidClicRechargeBtn:(XJHAlertView *)jhAlertView;

@end


@interface XJHAlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *offBtn;
@property (weak, nonatomic) IBOutlet UIButton *bechargeBtn;
@property (nonatomic,weak) id<XJHAlertViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
+ (instancetype)jhAlertView;


@end
