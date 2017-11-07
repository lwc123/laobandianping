//
//  ServiceContractEntity.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/25.
//  Copyright © 2016年 Max. All rights reserved.
//


#import "ServiceContractEntity.h"

@implementation ServiceContractEntity

- (NSInteger) getServiceMonths {
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //NSDayCalendarUnit
    unsigned int unitFlags = NSCalendarUnitDay;
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self.ServiceBeginTime  toDate:self.ServiceEndTime  options:0];
    
    NSInteger days = [comps day];
    NSInteger month = days / 30;
    
//    return self.ServiceEndTime.month - self.ServiceBeginTime.month;
    
    return month;
}





@end
