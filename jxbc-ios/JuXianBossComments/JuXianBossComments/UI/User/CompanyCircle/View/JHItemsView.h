//
//  JHItemsView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageButton.h"

@class JHItemsView;
@protocol JHItemsViewDelegate <NSObject>
@optional
- (void)jhItemsViewDelegateWithButton:(messageButton *)button ItemsView:(JHItemsView *)itemsView;

@end

@interface JHItemsView : UIView

@property (nonatomic, weak) id<JHItemsViewDelegate> delegate;

@end
