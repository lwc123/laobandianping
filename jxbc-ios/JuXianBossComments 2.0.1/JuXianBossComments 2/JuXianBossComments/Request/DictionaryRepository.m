//
//  DictionaryEntity.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DictionaryRepository.h"
//学历
NSString * const Comment_Academic = @"academic";
//行业
NSString * const Comment_Industry    = @"industry";
//薪水
NSString * const Comment_Salary = @"salary";
//城市
NSString * const Comment_City = @"city";
//返聘意愿
NSString * const Comment_Panicked = @"panicked";
//时间段
NSString * const Comment_Period = @"period";
//离任原因
NSString * const Comment_Leaving = @"leaving";






#define filepath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Comments_AllDictionary.data"]

@implementation DictionaryRepository
//学历
+ (NSDictionary*)getComment_Academic;
{
    
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_Academic];
}
//行业
+ (NSDictionary*)getComment_Industry;
{
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_Industry];

}
//薪水
+ (NSDictionary*)getComment_Salary;
{
    
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_Salary];
}

//城市
+ (NSDictionary*)getComment_City;
{
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_City];
}
//返聘意愿
+ (NSDictionary*)getComment_Panicked;
{
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_Panicked];
}


//时间段
+ (NSDictionary*)getComment_Period;
{
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_Period];
}

//离任原因
+ (NSDictionary*)getComment_Leaving;
{
    NSDictionary *alldic = [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
    return  alldic[Comment_Leaving];
}






+ (NSDictionary*)getAllDictionary;
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filepath];
}
+ (void)saveAllDictionaryWith:(NSDictionary*)dic;
{
    
    [NSKeyedArchiver archiveRootObject:dic toFile:filepath];
}




@end
