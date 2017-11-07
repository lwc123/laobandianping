//
//  JXSupportView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXSupportView;
@protocol SupportViewDelegate <NSObject>
@optional

- (void)supportViewDelegateRecommend:(JXSupportView *)supportView click:(UIButton *)button;
- (void)supportViewDelegateSupport:(JXSupportView *)supportView click:(UIButton *)button;
- (void)supportViewDelegateGood:(JXSupportView *)supportView click:(UIButton *)button;

@end

@interface JXSupportView : UIView

@property (nonatomic,strong)UIButton * selectedBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommend;
@property (weak, nonatomic) IBOutlet UIButton *noRecommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIButton *noSupportBtn;

@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
//一般
@property (weak, nonatomic) IBOutlet UIButton *sameAsBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;
@property (nonatomic, weak) id<SupportViewDelegate> delegate;
+ (instancetype)supportView;


@end
