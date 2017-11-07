//
//  CompanyDetailHeaderView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpinionCompanyEntity.h"
#import "JCTagListView.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "WQLStarView.h"
#import "ProgressView.h"

@class CompanyDetailHeaderView;
@protocol companyDetailHeaderViewDelegate <NSObject>
@optional
- (void)companyDetailHeaderViewBack:(CompanyDetailHeaderView *)headerView button:(UIButton *)button;
- (void)companyDetailHeaderViewShare:(CompanyDetailHeaderView *)headerView button:(UIButton *)button;

@end

@interface CompanyDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *bigBgView;

//半个星星的背景
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (nonatomic, strong) WQLStarView *starView;

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
//认领
@property (weak, nonatomic) IBOutlet UIButton *claimButton;

@property (weak, nonatomic) IBOutlet UILabel *companyInformation;

@property (weak, nonatomic) IBOutlet JCTagListView *tagsView;
@property (nonatomic, assign) CGFloat cellHeight;
//关注
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

//推荐率
@property (weak, nonatomic) IBOutlet ProgressView *recommendView;
//前景好
@property (weak, nonatomic) IBOutlet ProgressView *vistaGoodVIew;
//支持率
@property (weak, nonatomic) IBOutlet ProgressView *supportView;

@property (nonatomic, assign) id<companyDetailHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@property (nonatomic, strong) OpinionCompanyEntity *companyEntity;
+ (instancetype)companyDetailHeaderView;
@end
