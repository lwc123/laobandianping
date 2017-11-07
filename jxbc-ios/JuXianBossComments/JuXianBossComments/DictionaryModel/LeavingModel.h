//
//  LeavingModel.h
//  JuXianBossComments
//
//  Created by easemob on 2017/1/1.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LeavingModel : JSONModel
@property (nonatomic, copy) NSString *Code;
@property (nonatomic, strong) NSNumber *DictionaryId;
@property (nonatomic, strong) NSNumber *IsHotspot;
@property (nonatomic, strong) NSNumber *Level;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, strong) NSNumber *ParentId;
@property (nonatomic, copy) NSString *RelativeKeys;
@end

//leaving =     (
//               {
//                   Code = "\U5176\U4ed6";
//                   DictionaryId = 55;
//                   IsHotspot = 0;
//                   Level = 0;
//                   Name = "\U5176\U4ed6";
//                   ParentId = 0;
//                   RelativeKeys = "\U5176\U4ed6";
//               },
