//
//  Account.m
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "AnonymousAccount.h"

@implementation AnonymousAccount

//XJh8888
-(instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError **)err{
    self=[super initWithDictionary:dict error:err];
    if (self) {
        
//        if (self.OrganizationProfile!=nil) {
//            
//            self.Profile = self.OrganizationProfile;
//        } else {
//            self.Profile = self.UserProfile;
//        }
//        self.Profile = self.OrganizationProfile;
    }
    return self;
}


//- (JXOrganizationProfile *)getOrganizationProfile{

//    if (self.OrganizationProfile!=nil) {
//        return self.OrganizationProfile;
//    } else {
//        return self.UserProfile;
//    }
//    return self.OrganizationProfile;
//}

@end


@implementation ThirdPassport

@end
