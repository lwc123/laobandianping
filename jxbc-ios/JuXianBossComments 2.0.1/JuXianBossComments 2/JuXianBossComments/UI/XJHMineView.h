//
//  XJHMineView.h
//  JuXianTalentBank
//
//  Created by juxian on 16/9/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XJHMineView;

@protocol XJHMineViewDelegate <NSObject>
@optional
- (void)xjhMineViewDidClickUserInfoBtn:(XJHMineView *)jhMineView;

@end

@interface XJHMineView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *myInfoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIButton *systemSetBt;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (nonatomic,weak) id<XJHMineViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

+ (instancetype)jhMineView;

@end
