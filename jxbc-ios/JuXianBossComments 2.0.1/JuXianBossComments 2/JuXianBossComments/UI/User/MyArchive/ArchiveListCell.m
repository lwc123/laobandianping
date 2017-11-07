//
//  ArchiveListCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ArchiveListCell.h"

@implementation ArchiveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMyArchives:(EmployeArchiveEntity *)myArchives{

    _myArchives = myArchives;
    self.companyNameLabel.text = myArchives.CompanyName;
    
    if ([myArchives.StageEvaluationNum integerValue] != 0 && [myArchives.DepartureReportNum integerValue] != 0) {
        
        self.messageLabel.text = [NSString stringWithFormat:@"有%ld份工作评价,%ld份离任报告",[myArchives.StageEvaluationNum integerValue],[myArchives.DepartureReportNum integerValue]];
        
    }else if ([myArchives.StageEvaluationNum integerValue] != 0 && [myArchives.DepartureReportNum integerValue] == 0){
        
        self.messageLabel.text = [NSString stringWithFormat:@"有%ld份工作评价",[myArchives.StageEvaluationNum integerValue]];
        
    }else if ([myArchives.StageEvaluationNum integerValue]== 0 && [myArchives.DepartureReportNum integerValue] != 0){
    
        self.messageLabel.text = [NSString stringWithFormat:@"有%ld份离任报告",[myArchives.DepartureReportNum integerValue]];        
    }else {
        self.messageLabel.text = @"暂无工作评价,离任报告";
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
