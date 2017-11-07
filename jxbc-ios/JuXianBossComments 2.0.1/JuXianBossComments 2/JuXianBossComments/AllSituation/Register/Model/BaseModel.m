//
//  BaseModel.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
-(id)initWithDictionary:(NSDictionary *)mydict error:(NSError *__autoreleasing *)myerr
{
    self =[super initWithDictionary:mydict error:myerr];
    return self;
}
@end
