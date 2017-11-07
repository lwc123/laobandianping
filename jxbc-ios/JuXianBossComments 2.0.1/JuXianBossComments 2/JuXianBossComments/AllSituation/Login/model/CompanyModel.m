//
//  CompanyModel.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/5.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CompanyModel.h"

@implementation CompanyModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (NSInteger) getServiceDays{
    
    if (!self.ServiceEndTime) {
        return 9999;
    }
    NSDate * date = [NSDate date];
    NSDate * nowDate = [date dateByAddingTimeInterval:8*60*60];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:nowDate  toDate:self.ServiceEndTime  options:0];
    NSInteger days = [comps day];
    return days;
}
@end
