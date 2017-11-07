//
//  JHMenuView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHMenuView;

@protocol JHMenuViewDelegate <NSObject>

- (void)menuViewDidClickedFixArchive:(JHMenuView *)jxFooterView;
- (void)menuViewDidClickedFixComment:(JHMenuView *)jxFooterView;
@optional
//提现记录
- (void)menuViewDidClickedWithdrawals:(JHMenuView *)jxFooterView;

@end

@interface JHMenuView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *fixStaffImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fixCommentsImage;

@property (weak, nonatomic) IBOutlet UIButton *fixArchiveBtn;
@property (weak, nonatomic) IBOutlet UIButton *fixCommentBtn;
@property (nonatomic,weak) id<JHMenuViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *seconLineView;
@property (weak, nonatomic) IBOutlet UIButton *Withdrawals;

@property (weak, nonatomic) IBOutlet UIView *bgView;
+ (instancetype)menuView;

@end
