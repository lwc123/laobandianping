//
//  StaffListCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "StaffListCell.h"
#import "SeachRecodeListVC.h"

@implementation StaffListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [PublicUseMethod setColor:KColor_Text_EumeColor].CGColor;
    
}

- (void)setEmployeModel:(EmployeArchiveEntity *)employeModel{
     _employeModel = employeModel;
//    if ([self.viewController isKindOfClass:[SeachRecodeListVC class]]) {//d档案搜索结果
//        
//        self.commentCount.hidden = YES;
//    }
//   
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:employeModel.Picture] placeholderImage:Default_Image];
    self.nameLabel.text = employeModel.RealName;
    self.positionLabel.text = _workItemMolde.PostTitle;
    NSString * dateStr = [JXJhDate stringFromYearAndMonthDate:employeModel.EntryTime];
    
    self.joinDateLabel.text = [NSString stringWithFormat:@"%@加入公司",dateStr];
    
    if (employeModel.CommentsNum == 0) {
        self.commentCount.text = @"未评价";
        self.commentCount.textColor = [PublicUseMethod setColor:KColor_RedColor];
    }else{
        self.commentCount.text = [NSString stringWithFormat:@"已评价(%ld条)",employeModel.CommentsNum];
        self.commentCount.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
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

}

@end
