//
//  HotTopicCell.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTagListView.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "OpinionCompanyEntity.h"
#import "WQLStarView.h"

@interface HotTopicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
//半颗星星
@property (nonatomic, strong) WQLStarView *starView;
@property (weak, nonatomic) IBOutlet UIView *starBgView;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *industLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
//各种数量
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet JCTagListView *tagListView;

@property (nonatomic, strong) OpinionCompanyEntity *companyEntity;
@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;
@property (nonatomic, assign) NSInteger tagCellHeight;

@property (nonatomic, assign) CGFloat cellHeight;

@end
