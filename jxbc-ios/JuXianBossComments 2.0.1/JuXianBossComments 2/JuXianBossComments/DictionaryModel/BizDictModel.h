//
//  BizDictModel.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BizDictModel : JSONModel

@property (nonatomic,strong)NSNumber<Optional> *DictionaryId;
@property (nonatomic,copy)NSString<Optional> *Code;
@property (nonatomic,copy)NSString<Optional> *Name;

@property (nonatomic,strong)NSNumber<Optional> *Level;
@property (nonatomic,strong)NSNumber<Optional> *ParentId;
@property (nonatomic,strong)NSString<Optional> *CategoryCode;

@property (nonatomic,copy)NSString<Optional> *RelativeKeys;
@property (nonatomic,copy)NSString<Optional> *IsHotspot;


@end
/*
 
 BizDict {
 DictionaryId (integer, optional): 字典id ,
 Code (string, optional): Code代码 ,
 CategoryCode (DictCategoryCode, optional): 分类code ,
 Name (string, optional): 名称 ,
 Level (integer, optional): 层级 ,
 ParentId (integer, optional): 父id ,
 RelativeKeys (string, optional): 别名，索引名？ ,
 IsHotspot (integer, optional): 是否热门
 }
 */
