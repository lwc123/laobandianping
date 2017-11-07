//
//  JudgeCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JudgeCell.h"

@implementation JudgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setArchiveModel:(ArchiveCommentEntity *)archiveModel{
    _archiveModel = archiveModel;

    _myAccount = [UserAuthentication GetMyInformation];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",archiveModel.EmployeArchive.RealName];
    if ( (archiveModel.EmployeArchive.IsDimission == 0) && (archiveModel.CommentType == 1) )
    {
        self.commentTypeLabel.text = @"离任 离任报告";
    }else if ((archiveModel.EmployeArchive.IsDimission == 0) && (archiveModel.CommentType == 0)){
        NSString *comment = [NSString stringWithFormat:@"在职 %@%@工作评价",archiveModel.StageYear,archiveModel.StageSection];
        self.commentTypeLabel.text = comment;
    }else if ((archiveModel.EmployeArchive.IsDimission == 1) && (archiveModel.CommentType == 1)){
        self.commentTypeLabel.text = @"离任 离任报告";
    }else{
        NSString *comment = [NSString stringWithFormat:@"离任 %@%@工作评价",archiveModel.StageYear,archiveModel.StageSection];
        self.commentTypeLabel.text = comment;
    }
    self.dateLabel.text = [JXJhDate DateFormatDateMinis:archiveModel.CreatedTime] ;

    if (archiveModel.AuditStatus == 1) {
        
        if (archiveModel.PresenterId == _myAccount.PassportId) {
            self.autionStatusLabel.text = @"审核中";
            [self.checkBtn setTitle:@"查看" forState:UIControlStateNormal];

        }else if (archiveModel.PresenterId != _myAccount.PassportId){
            self.autionStatusLabel.text = @"待我审核";
            [self.checkBtn setTitle:@"去审核" forState:UIControlStateNormal];
        }
        
        self.autionStatusLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        self.lineView.hidden = YES;
        self.resonLabel.hidden = YES;

        
    }else if (archiveModel.AuditStatus == 2){
        self.autionStatusLabel.text = @"审核通过";
        [self.checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        self.autionStatusLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        self.lineView.hidden = YES;
        self.resonLabel.hidden = YES;
        
    }else if (archiveModel.AuditStatus == 9){
        self.autionStatusLabel.text = @"审核未通过";
        self.autionStatusLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
        
        if (archiveModel.RejectReason) {
            self.resonLabel.text = [NSString stringWithFormat:@"退回原因:%@(%@)",archiveModel.RejectReason,archiveModel.OperateRealName];
            self.lineView.hidden = NO;
            self.resonLabel.hidden = NO;
        }else{
            self.lineView.hidden = YES;
            self.resonLabel.hidden = YES;
        }
        
        if (archiveModel.PresenterId == _myAccount.PassportId) {
            [self.checkBtn setTitle:@"重新提交" forState:UIControlStateNormal];
        }else if (archiveModel.PresenterId != _myAccount.PassportId){
            [self.checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        }
        CGSize contenLabelSize = CGSizeMake(SCREEN_WIDTH - 15,MAXFLOAT);
        CGSize textSize = [self sizeWithText:self.resonLabel.text font:JHTextFont maxSize:contenLabelSize];
        _itemHeight = CGRectGetMaxY(self.lineView.frame) + textSize.height + 10;
    }    
}


- (IBAction)checkBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(judgeCellDelegateWithCheckBtn:WithCell:)]) {
        [self.delegate judgeCellDelegateWithCheckBtn:self.indexPath WithCell:self];
    }
    
}

//计算高度
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
