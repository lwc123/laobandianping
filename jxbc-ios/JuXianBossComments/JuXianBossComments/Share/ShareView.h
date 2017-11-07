//
//  ShareView.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/4.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareView;
@protocol ShareViewDelegate <NSObject>
- (void)shareButtonIndex:(NSInteger)index;

@end

@interface ShareView : UIView<ShareViewDelegate>
@property (nonatomic,strong)UIButton * sendFriendBtn;
@property (nonatomic,strong)UIButton * sendTimeLineBtn;
@property (nonatomic,strong)UIButton * cancelBtn;
@property (nonatomic,strong)UIView   *maskView;
@property (nonatomic,copy)id<ShareViewDelegate> delegate;
@end
