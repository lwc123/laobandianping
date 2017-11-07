//
//  DictionaryEntity.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryRepository : NSObject

//学历
+ (NSDictionary*)getComment_Academic;
//行业
+ (NSDictionary*)getComment_Industry;
//薪水
+ (NSDictionary*)getComment_Salary;
//城市
+ (NSDictionary*)getComment_City;
//返聘意愿
+ (NSDictionary*)getComment_Panicked;
//时间段
+ (NSDictionary*)getComment_Period;
//离任原因
+ (NSDictionary*)getComment_Leaving;

+ (NSDictionary*)getAllDictionary;
+ (void)saveAllDictionaryWith:(NSDictionary*)dic;

@end
