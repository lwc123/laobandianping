//
//  DictionaryEntity.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllDictionaryModel.h"

@interface DictionaryRepository : NSObject

//SC.XJH.1.1
//学历
+ (NSArray *)getComment_AcademicModelArray;
//行业
+ (NSArray *)getComment_IndustryModelArray;
//薪水
+ (NSArray *)getComment_SalaryModelArray;
//城市
+ (NSArray *)getComment_CityModelArray;
//返聘意愿
+ (NSArray *)getComment_PanickedModelArray;
//离任原因
+ (NSArray *)getComment_LeavingModelArray;
//时间段
+ (NSArray *)getComment_PeriodModelArray;

+ (void)saveAllDictionaryModelWith:(AllDictionaryModel *)allDictM;
+ (NSArray*)getAllDictModelArray;//SC.XJH.1.1


@end
