//
//  BaseModel.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "JSONModel.h"

@interface BaseModel : JSONModel

@property (nonatomic ,assign)int AccountId;
@property (nonatomic ,assign)int IsSignIn;

-(id)initWithDictionary:(NSDictionary *)mydict error:(NSError *__autoreleasing *)myerr;
@end
