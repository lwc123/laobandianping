//
//  JXJhDate.h
//  JuXianTalentBank
//
//  Created by juxian on 16/7/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXJhDate : NSObject

//年月日
+ (NSString *)JHFormatDateWith:(NSDate*)date;

//年月日 分秒
+ (NSString *)DateFormatDateMinis:(NSDate*)date;

+ (NSString *)weekdaysStringFromDate:(NSDate *)inputDate;


+ (NSString*)getMessageDateString:(NSDate*)messageDate andNeedTime:(BOOL)needTime;
//刚刚 几分钟前
+ (NSString *)jhDateChangeWith:(NSDate *)date;

+ (NSString *)stringFromDate:(NSDate *)date;

//将string格式的时间转换成date格式
+ (NSDate *)dateFromString:(NSString *)string;

//添加工作经历时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;


//只有年月
+ (NSString *)stringFromYearAndMonthDate:(NSDate *)date;
+ (NSDate *)toLocalDate:(NSDate *)anyDate;
+ (NSDate *)toUtcDate:(NSDate *)anyDate;

//转最小 最大时间
+ (NSDate *)toSmallDate:(NSString *)dateStr;
+ (NSDate *)toBigDate:(NSString *)dateStr;



@end
