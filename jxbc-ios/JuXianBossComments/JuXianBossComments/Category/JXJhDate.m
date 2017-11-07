//
//  JXJhDate.m
//  JuXianTalentBank
//
//  Created by juxian on 16/7/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXJhDate.h"

@implementation JXJhDate

+ (NSString *)JHFormatDateWith:(NSDate *)date{

        NSDateFormatter *formater = [[NSDateFormatter alloc]init];
        formater.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN.utf8"];
        //    formater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];//格林 GTM
        formater.timeZone = [NSTimeZone localTimeZone];
        
        formater.dateFormat = @"yyyy年MM月dd日";
        NSString *string = [formater stringFromDate:date];
        return string;

}

+ (NSString *)DateFormatDateMinis:(NSDate*)date{


    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN.utf8"];
    //    formater.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];//格林 GTM
    formater.timeZone = [NSTimeZone localTimeZone];
    
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *string = [formater stringFromDate:date];
    return string;


}


+ (NSString *)weekdaysStringFromDate:(NSDate *)inputDate{
    NSArray * weekdays = [NSArray arrayWithObjects:[NSNull null], @"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];

}

+ (NSString*)getMessageDateString:(NSDate*)messageDate andNeedTime:(BOOL)needTime{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:messageDate];
    NSDate *msgDate = [cal dateFromComponents:components];
    
    //    NSString*weekday =[NSString stringWithFormat:@"%@",[self getWeekdayWithNumber:components.weekday]];
    
    components = [cal components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    
    
   
    
    
    if([today isEqualToDate:msgDate]){
        if (needTime) {
            [formatter setDateFormat:@"今天 HH:mm"];
        }
        else{
            [formatter setDateFormat:@"今天"];
        }
        return [formatter stringFromDate:messageDate];
    }
    
    components.day -= 1;
    NSDate *yestoday = [cal dateFromComponents:components];
    if([yestoday isEqualToDate:msgDate]){
        if (needTime) {
            [formatter setDateFormat:@"昨天 HH:mm"];
        }
        else{
            [formatter setDateFormat:@"昨天"];
        }
        return [formatter stringFromDate:messageDate];
    }
    
    //    for (int i = 1; i <= 6; i++) {
    //        components.day -= 1;
    //        NSDate *nowdate = [cal dateFromComponents:components];
    //
    //        if([nowdate isEqualToDate:msgDate]){
    //            if (needTime) {
    //                [formatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm",weekday]];
    //            }
    //            else{
    //                [formatter setDateFormat:[NSString stringWithFormat:@"%@",weekday]];
    //            }
    //            return [formatter stringFromDate:messageDate];
    //        }
    //    }
    
    while (1) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if ([nowdate isEqualToDate:msgDate]) {
            if (!needTime) {
                [formatter setDateFormat:@"yyyy年MM月dd日"];
            }
            return [formatter stringFromDate:messageDate];
            break;
        }
    }


}

+ (NSString *)jhDateChangeWith:(NSDate *)date{

    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN.utf8"];
    formater.timeZone = [NSTimeZone localTimeZone];
    formater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *createdTimeStr = [formater stringFromDate:date];

    //时间
//    NSString *createdTimeStr = @"2017-01-01 21:05:10";
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:createdTimeStr];
    
    
    
    //得到与当前时间差
    NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }else if((temp = timeInterval/60) < 60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }else if((temp = timeInterval/3600) > 1 && (temp = timeInterval/3600) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }else if ((temp = timeInterval/3600) > 24 && (temp = timeInterval/3600) < 48){
        result = [NSString stringWithFormat:@"昨天"];
    }else if ((temp = timeInterval/3600) > 48 && (temp = timeInterval/3600) < 72){
        result = [NSString stringWithFormat:@"前天"];
    }else{
        result = createdTimeStr;
    }
    return result;
}


//将string格式的时间转换成date格式
+ (NSDate *)dateFromString:(NSString *)string
{
    NSString *dateString= string;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[dateFormatter dateFromString:dateString];
    return date;
}

//最小时间
+ (NSDate *)toSmallDate:(NSString *)dateStr{

    NSString *dateString= dateStr;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[dateFormatter dateFromString:dateString];
    return date;

}
//最大时间
+ (NSDate *)toBigDate:(NSString *)dateStr{
    NSString *dateString= dateStr;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    //    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss zzz"];
//    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];

    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString *)stringFromYearAndMonthDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}


+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate{

    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;     //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSDate *)toLocalDate:(NSDate *)anyDate{
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    NSTimeZone* targetTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger targetGMTOffset = [targetTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = targetGMTOffset - sourceGMTOffset;
    //转为本地时间
    NSDate* targetDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return targetDate;
}

+ (NSDate *)toUtcDate:(NSDate *)anyDate{
    NSTimeZone* sourceTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone* targetTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger targetGMTOffset = [targetTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = targetGMTOffset - sourceGMTOffset;     //转为本地时间
    NSDate* targetDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return targetDate;
}

@end
