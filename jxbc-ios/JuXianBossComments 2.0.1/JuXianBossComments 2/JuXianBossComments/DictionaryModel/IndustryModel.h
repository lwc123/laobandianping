//
//  IndustryModel.h
//  JuXianBossComments
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface IndustryModel : JSONModel
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, strong) NSNumber *DictionaryId;
@property (nonatomic, strong) NSNumber *IsHotspot;
@property (nonatomic, strong) NSNumber *Level;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, strong) NSNumber *ParentId;
@property (nonatomic, copy) NSString *RelativeKeys;
@end


//industry =     (
//                {
//                    Code = 201;
//                    DictionaryId = 13;
//                    IsHotspot = 0;
//                    Level = 0;
//                    Name = "IT\U4e92\U8054\U7f51";
//                    ParentId = 0;
//                    RelativeKeys = "201,IT\U4e92\U8054\U7f51";
//                }
