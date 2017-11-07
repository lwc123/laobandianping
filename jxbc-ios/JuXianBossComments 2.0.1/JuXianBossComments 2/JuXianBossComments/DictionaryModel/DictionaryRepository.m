//
//  DictionaryEntity.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DictionaryRepository.h"
#import "PeriodModel.h"//SC.XJH.1.1
//学历
NSString * const Comment_Academic = @"academic";
//行业
NSString * const Comment_Industry = @"industry";
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

//SC.XJH.1.1
#define modelfilepath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Comments_AllDictionaryModel.data"]

@implementation DictionaryRepository

/************************************************/
//SC.XJH.1.1
//学历
+ (NSArray *)getComment_AcademicModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.academic;
}
//行业
+ (NSArray *)getComment_IndustryModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.industry;
}
//薪水
+ (NSArray *)getComment_SalaryModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.salary;
}
//城市
+ (NSArray *)getComment_CityModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.city;
}
//返聘意愿
+ (NSArray *)getComment_PanickedModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.panicked;
}
//离任原因
+ (NSArray *)getComment_LeavingModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.leaving;
}
//时间段
+ (NSArray *)getComment_PeriodModelArray
{
    AllDictionaryModel *allModelA = [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
    return  allModelA.period;
}

+ (void)saveAllDictionaryModelWith:(AllDictionaryModel *)allDictM
{
    [NSKeyedArchiver archiveRootObject:allDictM toFile:modelfilepath];
}
//SC.XJH.1.1
+ (NSArray*)getAllDictModelArray
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:modelfilepath];
}








@end
