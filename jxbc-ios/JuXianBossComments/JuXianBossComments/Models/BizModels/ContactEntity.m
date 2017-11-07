//
//  ContactEntity.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/9.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "ContactEntity.h"
@implementation ContactEntity

-(instancetype)initWithDictionary:(NSDictionary*)dict error:(NSError **)err{
    self=[super initWithDictionary:dict error:err];
    if (self) {
        
//        if (self.ConsultantProfile!=nil) {
//            
//            self.FriendProfile = self.ConsultantProfile;
//        } else {
//            
//            self.FriendProfile = self.UserProfile;
//        }
        
         self.FriendProfile = self.UserProfile;
    }
    
    return self;
}



@end
