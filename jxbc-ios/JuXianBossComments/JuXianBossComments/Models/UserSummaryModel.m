//
//  UserSummaryModel.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/22.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "UserSummaryModel.h"

@implementation UserSummaryModel


- (JXUserProfile*)getProfile
{
//    if (self.ConsultantProfile!=nil) {
//        return self.ConsultantProfile;
//    } else {
//        return self.UserProfile;
//    }
    return self.UserProfile;
}


@end
