//
//  JSONValueTransformer+NSDate.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JSONValueTransformer+NSDate.h"


@implementation JSONValueTransformer (NSDate)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *targetDate = [JXJhDate toLocalDate:[formatter dateFromString:string]];
    return targetDate;
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    
    NSDate *utcDate =  [JXJhDate toUtcDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [formatter stringFromDate:utcDate];
}


@end
