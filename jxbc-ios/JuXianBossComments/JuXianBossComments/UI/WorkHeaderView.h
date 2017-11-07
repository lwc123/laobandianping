//
//  workHeaderView.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanySummary.h"
#import "MineAccountViewController.h"
@class WorkHeaderView;
@protocol WorkHeaderViewDelegate <NSObject>

/**
 修改企业信息
 */
- (void)workHeaderViewDidClickFixBtn:(WorkHeaderView *)workView;

@end

@interface WorkHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIButton *fixBtnClick;
@property (nonatomic,weak) id<WorkHeaderViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *companyName;

@property (weak, nonatomic) IBOutlet UILabel *LegalName;
//认证状态
@property (weak, nonatomic) IBOutlet UILabel *auditSatus;
//离任人数
@property (weak, nonatomic) IBOutlet UILabel *DimissionNum;
//在职人数
@property (weak, nonatomic) IBOutlet UILabel *EmployedNum;
@property (weak, nonatomic) IBOutlet UIImageView *auditImageView;
+ (instancetype)workHeaderView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *indiorBtn;
//离任报告数
@property (weak, nonatomic) IBOutlet UILabel *reportNum;
//阶段评价数
@property (weak, nonatomic) IBOutlet UILabel *stageEvaluationNum;
@property (nonatomic, strong) CompanySummary *companyModel;
@property (weak, nonatomic) IBOutlet UIView *linethreeView;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end
