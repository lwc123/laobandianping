//
//  BuyView.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/19.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuyView;
@protocol BuyViewDelegate <NSObject>
- (void)buyViewwDidClickTimeBtnWith:(NSInteger)index andView:(BuyView *)buyView;
@end

@interface BuyView : UIView

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,weak) id<BuyViewDelegate> delegate;


+ (instancetype)buyView;

@end
