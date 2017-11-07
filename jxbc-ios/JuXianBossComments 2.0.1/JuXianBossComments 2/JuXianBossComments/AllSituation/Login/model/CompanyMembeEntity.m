//
//  InformationModel.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CompanyMembeEntity.h"

@implementation CompanyMembeEntity
//设置所有的属性为可选，这个写上之后，模型中的所有字段都可以为空或不返回，就不会转模型失败
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
