//
//  JobEntity.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CompanySummary.h"
#import "CompanyMembeEntity.h"

@protocol CompanyMembeEntity <NSObject>
@end

@interface JobEntity : JSONModel

//JobId (integer, optional): 发布职位ID ,
@property (nonatomic, assign) long JobId;
//CompanyId (integer): 公司ID ,
@property (nonatomic, assign) long CompanyId;
//PassportId (integer, optional): 用户ID ,
@property (nonatomic, assign) long PassportId;
//JobName (string): 职位名称 ,
@property (nonatomic, copy) NSString <Optional>* JobName;
//SalaryRangeMin (string): 期望薪资最小值 ,
@property (nonatomic, copy) NSString <Optional>* SalaryRangeMin;
//SalaryRangeMax (string): 期望薪资最大值 ,
@property (nonatomic, copy) NSString <Optional>* SalaryRangeMax;
//ExperienceRequire (string, optional): 经验要求code ,
@property (nonatomic, copy) NSString <Optional>* ExperienceRequire;
//ExperienceRequireText (string, optional): 经验要求 ,
@property (nonatomic, copy) NSString <Optional>* ExperienceRequireText;
//EducationRequire (string, optional): 教育要求code ,
@property (nonatomic, copy) NSString <Optional>* EducationRequire;
//EducationRequireText (string, optional): 教育要求 ,
@property (nonatomic, copy) NSString <Optional>* EducationRequireText;
//JobCity (string): 工作城市code ,
@property (nonatomic, copy) NSString <Optional>* JobCity;
//JobCityText (string, optional): 工作城市 ,
@property (nonatomic, copy) NSString <Optional>* JobCityText;
//JobLocation (string): 工作地点 ,
@property (nonatomic, copy) NSString <Optional>* JobLocation;
//JobDescription (string): 工作描述 ,
@property (nonatomic, copy) NSString <Optional>* JobDescription;
//ContactEmail (string): 接受简历的邮箱 ,
@property (nonatomic, copy) NSString <Optional>* ContactEmail;
//ContactNumber (string): 联系电话 ,
@property (nonatomic, copy) NSString <Optional>* ContactNumber;
//CreatedTime (string, optional): 发布时间 ,
@property (nonatomic, copy) NSDate <Optional>* CreatedTime;
//ModifiedTime (string, optional): 修改时间 ,
@property (nonatomic, copy) NSDate <Optional>* ModifiedTime;
//CompanyMember (CompanyMember, optional),
@property (nonatomic, strong) CompanyMembeEntity <Optional>* CompanyMember;
//Company (Company, optional)
@property (nonatomic, assign) BOOL DisplayState;
@property (nonatomic, strong) CompanySummary <Optional>*Company;


@end

