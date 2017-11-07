//
//  JXUserProfile.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/19.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXUserProfile.h"

@implementation JXUserProfile

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (CurrentProfileType) getCurrentProfileType
{
    return UserProfile;
}



@end
