//
//  JXMessageAlertView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/3/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXMessageAlertView;
@protocol JXMessageAlertViewDelagate <NSObject>
@optional
- (void)messageAlertViewDidClickedWithAlertView:(JXMessageAlertView *)areltView;
- (void)messageAlertViewCacenlClickWithAlertView:(JXMessageAlertView *)areltView;
- (void)messageAlertViewSurelClickWithAlertView:(JXMessageAlertView *)areltView;

@end

@interface JXMessageAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (nonatomic,weak) id<JXMessageAlertViewDelagate> delegate;
+ (instancetype)messageAlertView;

@end
