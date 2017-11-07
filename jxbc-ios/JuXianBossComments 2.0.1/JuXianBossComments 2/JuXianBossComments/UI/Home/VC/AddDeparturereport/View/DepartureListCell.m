//
//  DepartureListCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "DepartureListCell.h"
#import "CommentsListVC.h"
#import "ReportListVC.h"
#import "SeachResultCommentVC.h"
#import "SeachDepartureResultVC.h"
@implementation DepartureListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [PublicUseMethod setColor:KColor_Text_EumeColor].CGColor;
}

- (void)setArchiveModel:(ArchiveCommentEntity *)archiveModel{

    _archiveModel = archiveModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:archiveModel.EmployeArchive.Picture] placeholderImage:Default_Image];
    self.nameLabel.text = archiveModel.EmployeArchive.RealName;
    self.jobLabel.text = archiveModel.EmployeArchive.WorkItem.PostTitle;
    if ([self.viewController isKindOfClass:[SeachResultCommentVC class]]) {
        
        self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ 评价",archiveModel.StageYear,archiveModel.StageSectionText];
    }
    
    if ([self.viewController isKindOfClass:[CommentsListVC class]]) {
        self.dateLabel.text = [NSString stringWithFormat:@"%@ %@ 评价",archiveModel.StageYear,archiveModel.StageSectionText];
    }

    if ([self.viewController isKindOfClass:[ReportListVC class]] || [self.viewController isKindOfClass:[SeachDepartureResultVC class]]) {
        self.dateLabel.text = @"离任报告";
    }
    
}


- (UIViewController*)viewController
{
    UIResponder *next = self;
    do {
        next = next.nextResponder;
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next;
        }
    } while (next!=nil);
    return nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
