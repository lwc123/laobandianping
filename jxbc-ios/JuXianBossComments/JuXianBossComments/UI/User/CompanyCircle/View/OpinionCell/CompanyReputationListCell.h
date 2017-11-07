//
//  CompanyReputationListCell.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpinionEntity.h"
#import "SETextView.h"

@class CompanyReputationListCell;
@protocol CompanyReputationListCellDelegate <NSObject>
@optional
- (void)ReputationListCellCompanydetail:(CompanyReputationListCell *)listCell indexPath:(NSIndexPath *)indexPath;

@end

//口碑cell
@interface CompanyReputationListCell : UITableViewCell

@property (nonatomic, strong) OpinionEntity * opinionModel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) NSInteger tagCellHeight;

@property (nonatomic, assign) id<CompanyReputationListCellDelegate> delegate;

+ (CGFloat)getTitleTextHeightWithText:(NSString *)text;

@end
