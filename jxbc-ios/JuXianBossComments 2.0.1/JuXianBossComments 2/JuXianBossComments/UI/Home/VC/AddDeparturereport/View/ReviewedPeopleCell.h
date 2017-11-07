//
//  ReviewedPeopleCell.h
//  JuXianBossComments
//
//  Created by easemob on 2016/12/25.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReviewedPeopleCellDelegate;

@interface ReviewedPeopleCell : UITableViewCell
@property (nonatomic, weak) id<ReviewedPeopleCellDelegate> delegate;

@property (nonatomic, strong) UIButton *deletePeopleBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@protocol ReviewedPeopleCellDelegate <NSObject>

@optional

- (void)reviewedPeopleCell:(ReviewedPeopleCell *)cell deletePeopleBtnClick:(UIButton *)button;

@end
