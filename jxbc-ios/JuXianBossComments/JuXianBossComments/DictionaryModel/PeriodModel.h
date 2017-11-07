//
//  PeriodModel.h
//  JuXianBossComments
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 jinghan. All rights reserved.
//
//SC.XJH.1.1
#import <JSONModel/JSONModel.h>

@interface PeriodModel : JSONModel
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, strong) NSNumber *DictionaryId;
@property (nonatomic, strong) NSNumber *IsHotspot;
@property (nonatomic, strong) NSNumber *Level;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, strong) NSNumber *ParentId;
@property (nonatomic, copy) NSString *RelativeKeys;
@end
