//
//  JudgeCheckingCell.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JudgeCheckingCell.h"
@interface JudgeCheckingCell()
@property (weak, nonatomic) IBOutlet UILabel *CreatedTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *staseLabel;
@property (weak, nonatomic) IBOutlet UILabel *WorkComment;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
@implementation JudgeCheckingCell
- (IBAction)checkingClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(CheckingCellWith:)]) {
        [self.delegate CheckingCellWith:sender.tag];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setArchiveModel:(ArchiveCommentEntity *)archiveModel
{
    //self.clickBtn.tag =
    _archiveModel = archiveModel;
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:archiveModel.CreatedTime];
    //输出currentDateString
    
    self.CreatedTimeLabel.text = currentDateString;
    
    if ((archiveModel.AuditStatus == 1) && (self.archiveModel.PresenterId != self.archiveModel.PresenterId)) {
        self.staseLabel.text = @"审核中";
    }else
    {
    self.staseLabel.text = @"待审核";
    }
    
    //  IsDimission  0 在职  1 离任
    //  CommentType  0 不是离任报告  1 离任报告
    if ( (archiveModel.EmployeArchive.IsDimission == 0) && (archiveModel.CommentType == 1) )
    {
        self.WorkComment.text = @"在职 离任报告";
    }else if ((archiveModel.EmployeArchive.IsDimission == 0) && (archiveModel.CommentType == 0)){
        NSString *comment = [NSString stringWithFormat:@"在职 %@%@工作评价",archiveModel.StageYear,archiveModel.StageSection];
        self.WorkComment.text = comment;
    }else if ((archiveModel.EmployeArchive.IsDimission == 1) && (archiveModel.CommentType == 1)){
        self.WorkComment.text = @"离任 离任报告";
    }else{
        NSString *comment = [NSString stringWithFormat:@"离任 %@%@工作评价",archiveModel.StageYear,archiveModel.StageSection];
        self.WorkComment.text = comment;
    }
    
    
    self.nameLabel.text = archiveModel.EmployeArchive.RealName;
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
