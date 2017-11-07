//
//  JobPublicJobcell.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobPublicJobcell.h"
#import "JobEntity.h"

@interface JobPublicJobcell ()

// 职位名
@property (nonatomic, strong) IBOutlet UILabel *jobNameLabel;
// 发布人名
@property (nonatomic, strong) IBOutlet UILabel *memberNameLabel;
// 时间
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
// 薪资
@property (nonatomic, strong) IBOutlet UILabel *salaryLabel;
// 已关闭
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;


@end

@implementation JobPublicJobcell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

- (void)setJobEntity:(JobEntity *)jobEntity{
    _jobEntity = jobEntity;
    
    self.jobNameLabel.text = jobEntity.JobName;
//    jobEntity.CompanyMember.RealName
    self.memberNameLabel.text = [NSString stringWithFormat:@"由%@发布（%@）",jobEntity.CompanyMember.RealName,jobEntity.CompanyMember.JobTitle];
    
    
//    if (jobEntity.SalaryRangeMin.intValue/1000.0 ) {
//        <#statements#>
//    }
//
    CGFloat min = jobEntity.SalaryRangeMin.intValue/1000.0;
    CGFloat max = jobEntity.SalaryRangeMax.intValue/1000.0;

    NSInteger salaryRangeMin = 0;
    NSInteger salaryRangeMax = 0;

    if ((NSInteger)min == min) {
        salaryRangeMin = (NSInteger)min;
    }else{
        
        NSLog(@"带有小数");
    }
    
    if ((NSInteger)max == max) {
        salaryRangeMax = (NSInteger)max;
    }else{
    
    }
    
    if (salaryRangeMin == 0 && salaryRangeMax == 0) {
        
        self.salaryLabel.text = [NSString stringWithFormat:@"%.1fk-%.1fk",min,max];
    }else if ( salaryRangeMin == 0 && salaryRangeMax != 0 ){
    
        self.salaryLabel.text = [NSString stringWithFormat:@"%.1fk-%.1ldk",min,(long)salaryRangeMax];
    }else if (salaryRangeMin != 0 && salaryRangeMax == 0){
        self.salaryLabel.text = [NSString stringWithFormat:@"%.1ldk-%.1fk",(long)salaryRangeMin,max];
    }else if (salaryRangeMin != 0 && salaryRangeMax != 0){
        self.salaryLabel.text = [NSString stringWithFormat:@"%.1ldk-%.1ldk",(long)salaryRangeMin,(long)salaryRangeMax];
    }
//    self.salaryLabel.text = [NSString stringWithFormat:@"%.1fk-%.1fk",jobEntity.SalaryRangeMin.intValue/1000.0,jobEntity.SalaryRangeMax.intValue/1000.0];
    self.statusLabel.hidden = !jobEntity.DisplayState;;
    
    NSString *timeStr;
    timeStr = [self distanceTimeWithBeforeTime:jobEntity.CreatedTime];
    timeStr = [NSString stringWithFormat:@"发布于%@",timeStr];
    /*
    if ([jobEntity.CreatedTime isEqualToDate:jobEntity.ModifiedTime]) {//首次发布
        timeStr = [self distanceTimeWithBeforeTime:jobEntity.CreatedTime];
        timeStr = [NSString stringWithFormat:@"发布于%@",timeStr];
    }else{
        timeStr = [self distanceTimeWithBeforeTime:jobEntity.ModifiedTime];
        timeStr = [NSString stringWithFormat:@"更新于%@",timeStr];
    }
    */
    self.timeLabel.text = timeStr;
    
}

#pragma mark -  时间格式化
- (NSString *)distanceTimeWithBeforeTime:(NSDate *)date

{
    NSTimeInterval beTime = [date timeIntervalSince1970];
    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    
    //    double distanceTime = now - beTime + 60 * 60 *8;
    double distanceTime = now - beTime;
    
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = self.dateFormatter;
    
    //    [df setDateFormat:@"HH:mm"];
    //
    //    NSString * timeStr = [df stringFromDate:beDate];
    //
    //    [df setDateFormat:@"dd"];
    //
    //    NSString * nowDay = [df stringFromDate:[NSDate date]];
    //
    //    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    
    else if(distanceTime < 60*60*24){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"%ld小时前",(long)distanceTime/3600];
        
    }
    
    //    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
    //
    //        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
    //
    //            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
    //
    //        }
    //
    //        else{
    //
    //            [df setDateFormat:@"MM-dd HH:mm"];
    //
    //            distanceStr = [df stringFromDate:beDate];
    //
    //        }
    //
    //    }
    //
    //    else if(distanceTime < 24*60*60*365){
    //
    //        [df setDateFormat:@"MM-dd HH:mm"];
    //
    //        distanceStr = [df stringFromDate:beDate];
    //
    //    }
    
    else{
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    
    return distanceStr;
    
}

- (NSDateFormatter *)dateFormatter{
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        //        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
    }
    return _dateFormatter;
}



@end
