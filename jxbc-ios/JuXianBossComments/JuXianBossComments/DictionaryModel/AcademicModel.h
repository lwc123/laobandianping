//
//  AcademicModel.h
//  JuXianBossComments
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface AcademicModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *Code;
@property (nonatomic, strong) NSNumber<Optional> *DictionaryId;
@property (nonatomic, strong) NSNumber<Optional> *IsHotspot;
@property (nonatomic, strong) NSNumber<Optional> *Level;
@property (nonatomic, copy) NSString<Optional> *Name;
@property (nonatomic, strong) NSNumber<Optional> *ParentId;
@property (nonatomic, copy) NSString<Optional> *RelativeKeys;
@end

//academic =     (
//                {
//                    Code = 0;
//                    DictionaryId = 3;
//                    IsHotspot = 0;
//                    Level = 0;
//                    Name = "\U4e0d\U9650";
//                    ParentId = 0;
//                    RelativeKeys = "0,\U4e0d\U9650";
//                }
