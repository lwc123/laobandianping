//
//  JudgeBackCell.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JudgeBackCell.h"
@interface JudgeBackCell()
@property (weak, nonatomic) IBOutlet UILabel *CreatedTimeLabel;


@property (weak, nonatomic) IBOutlet UILabel *WorkCommentLabel;

@property (weak, nonatomic) IBOutlet UILabel *RejectReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation JudgeBackCell


-(void)setArchiveModel:(ArchiveCommentEntity *)archiveModel
{
    _archiveModel = archiveModel;
    self.nameLabel.text = archiveModel.EmployeArchive.RealName;

    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:archiveModel.CreatedTime];
    //输出currentDateString
    self.CreatedTimeLabel.text = currentDateString;
    
    
    //  IsDimission  0 在职  1 离任
    //  CommentType  0 不是离任报告  1 离任报告
    if ( (archiveModel.EmployeArchive.IsDimission == 0) && (archiveModel.CommentType == 1) )
    {
        self.WorkCommentLabel.text = @"在职 离任报告";
    }else if ((archiveModel.EmployeArchive.IsDimission == 0) && (archiveModel.CommentType == 0)){
        NSString *comment = [NSString stringWithFormat:@"在职 %@%@工作评价",archiveModel.StageYear,archiveModel.StageSection];
        self.WorkCommentLabel.text = comment;
    }else if ((archiveModel.EmployeArchive.IsDimission == 1) && (archiveModel.CommentType == 1)){
        self.WorkCommentLabel.text = @"离任 离任报告";
    }else{
        NSString *comment = [NSString stringWithFormat:@"离任 %@%@工作评价",archiveModel.StageYear,archiveModel.StageSection];
        self.WorkCommentLabel.text = comment;
    }
    
    
    //拖回原因
    NSString *reason = [NSString stringWithFormat:@"退回原因：%@()",archiveModel.RejectReason];
    self.RejectReasonLabel.text = reason;
//    self.RejectReasonLabel.backgroundColor = [UIColor yellowColor];
    CGSize contenLabelSize = CGSizeMake(SCREEN_WIDTH - 15 - 130,MAXFLOAT);
    CGSize textSize = [self sizeWithText:self.RejectReasonLabel.text font:JHTextFont maxSize:contenLabelSize];
//    self.RejectReasonLabel.frame = CGRectMake(23, CGRectGetMaxY(self.CreatedTimeLabel.frame) + 12, SCREEN_WIDTH - 23* 2, textSize.height);
    
    _itemHeight = CGRectGetMaxY(self.RejectReasonLabel.frame) + textSize.height + 10;
    
}

//计算高度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
