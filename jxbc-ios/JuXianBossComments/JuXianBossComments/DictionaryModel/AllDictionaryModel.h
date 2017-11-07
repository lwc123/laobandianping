//
//  AllDictionaryModel.h
//  JuXianBossComments
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 jinghan. All rights reserved.
//
//SC.XJH.1.1
#import <JSONModel/JSONModel.h>
#import "PeriodModel.h"
#import "PanickedModel.h"
#import "CityModel.h"
#import "LeavingModel.h"
#import "SalaryModel.h"
#import "IndustryModel.h"
#import "AcademicModel.h"
@protocol PeriodModel;
@protocol PanickedModel;
@protocol CityModel;
@protocol LeavingModel;
@protocol SalaryModel;
@protocol IndustryModel;
@protocol AcademicModel;

@interface AllDictionaryModel : JSONModel

@property (nonatomic, strong) NSArray <AcademicModel> *academic;
@property (nonatomic, strong) NSArray <IndustryModel> *industry;
@property (nonatomic, strong) NSArray <SalaryModel> *salary;
@property (nonatomic, strong) NSArray <CityModel> *city;
@property (nonatomic, strong) NSArray <PanickedModel> *panicked;
@property (nonatomic, strong) NSArray <PeriodModel> *period;
@property (nonatomic, strong) NSArray <LeavingModel> *leaving;

@end
