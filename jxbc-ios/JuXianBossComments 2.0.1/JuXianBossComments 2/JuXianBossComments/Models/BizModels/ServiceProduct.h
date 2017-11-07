//
//  Product.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ServiceProduct : JSONModel
@property (nonatomic, strong) NSString<Optional> * Brief;
@property (nonatomic, strong) NSArray<Optional> * Content;
@property (nonatomic, strong) NSString<Optional> * CreatedTime;
@property (nonatomic, strong) NSString<Optional> * Description;
@property (nonatomic, strong) NSString<Optional> * ExpiredTime;
@property (nonatomic, strong) NSNumber<Optional> * Id;
@property (nonatomic, strong) NSString<Optional> * ImgPath;
@property (nonatomic, strong) NSString<Optional> * ImgStream;
@property (nonatomic, strong) NSString<Optional> * ModifiedTime;
@property (nonatomic, strong) NSString<Optional> * Name;
@property (nonatomic, strong) NSNumber<Optional> * PassportId;
@property (nonatomic, strong) NSNumber<Optional> * PersistentState;
@property (nonatomic, strong) NSNumber<Optional> * Popularity;
@property (nonatomic, strong) NSString<Optional> * Price;
@property (nonatomic, strong) NSNumber<Optional> * ProductId;
@property (nonatomic, strong) NSNumber<Optional> * ProductType;

@end
