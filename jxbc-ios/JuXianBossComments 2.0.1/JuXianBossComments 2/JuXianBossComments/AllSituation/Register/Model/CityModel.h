//
//  CityModel.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/1.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CityModel : JSONModel

//@property (nonatomic,copy)NSString<Optional>*Code;

@property (nonatomic,copy)NSString<Optional> *Code;
@property (nonatomic,strong)NSNumber<Optional> * IsHotspot;
@property (nonatomic,strong)NSNumber<Optional> * Level;
@property (nonatomic,strong)NSNumber<Optional> * ParentId;
@property (nonatomic,strong)NSNumber<Optional> * DictionaryId;
@property (nonatomic,copy)NSString<Optional>*Name;//code
@property (nonatomic,copy)NSString<Optional>*RelativeKeys;//code


@end
/*
 Code = 105002;
 DictionaryId = 14;
 IsHotspot = 0;
 Level = 1;
 Name = "\U5eca\U574a";
 ParentId = 152;
 RelativeKeys = "105002,\U5eca\U574a";
 },
 */
