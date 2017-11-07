//
//  AskforJobCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AskforJobCell.h"

@implementation AskforJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setJobModel:(JobEntity *)jobModel{

    _jobModel = jobModel;
    self.jobName.text = jobModel.JobName;
    self.companyName.text = jobModel.Company.CompanyAbbr;
    self.createdTime.text = [self distanceTimeWithBeforeTime:jobModel.CreatedTime];
    self.experienceRequireText.text = jobModel.ExperienceRequireText;
    self.educationRequire.text = jobModel.EducationRequireText;
    self.jobLocation.text = jobModel.JobLocation;
    
    double min = [jobModel.SalaryRangeMin doubleValue] * 0.001;
    double max = [jobModel.SalaryRangeMax doubleValue] * 0.001;
    self.SalaryRange.text = [NSString stringWithFormat:@"%1.fK-%1.fK",min,max];
}

#pragma mark -  时间格式化
- (NSString *)distanceTimeWithBeforeTime:(NSDate *)date

{
    NSTimeInterval beTime = [date timeIntervalSince1970];
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    double distanceTime = now - beTime;
    NSString * distanceStr;
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    NSDateFormatter * df = self.dateFormatter;
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    else if(distanceTime < 60*60*24){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"%ld小时前",(long)distanceTime/3600];
        
    }else{
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    
    return distanceStr;
    
}

- (NSDateFormatter *)dateFormatter{
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
