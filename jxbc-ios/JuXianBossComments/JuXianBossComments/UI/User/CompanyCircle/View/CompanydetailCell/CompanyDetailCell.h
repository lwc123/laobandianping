//
//  CompanyDetailCell.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TggStarEvaluationView.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "JCTagListView.h"
#import "OpinionEntity.h"

@interface CompanyDetailCell : UITableViewCell

@property (nonatomic, strong) OpinionEntity *opinionEntity;
@property (nonatomic, assign) NSInteger tagCellHeight;
@property (nonatomic, assign) CGFloat cellHeight;

@end
