//
//  JudgePassCell.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JudgePassCell.h"
@interface JudgePassCell()


@property (weak, nonatomic) IBOutlet UILabel *CreatedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *WorkCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation JudgePassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setArchiveModel:(ArchiveCommentEntity *)archiveModel
{
    
    _archiveModel = archiveModel;
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
    self.nameLabel.text = archiveModel.EmployeArchive.RealName;
    
}

//+(instancetype)JudgePassCell
//{
//    return [NSBundle mainBundle] ;
//}

@end
