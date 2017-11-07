//
//  JXOrganizationProfile.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXUserProfile.h"

@interface JXOrganizationProfile : JXUserProfile

//@property (nonatomic,assign)CurrentProfileType CurrentProfileType;
@property (nonatomic,copy)NSDate <Optional>*AttestationTime;
@property (nonatomic,copy)NSString <Optional>*Identity;
@property (nonatomic,strong)NSArray<Optional>*AuthenticationImages;
@property (nonatomic,copy)NSString <Optional>*AttestationRejectedReason;
@property (nonatomic,strong)NSDate<Optional> *LastSignedInTime;
@property (nonatomic,strong)NSDate<Optional> *LastActivityTime;


@end
/*
 OrganizationProfile {
 CurrentOrganizationId (integer, optional),
 PassportId (integer, optional),
 CurrentProfileType (integer, optional),
 RealName (string),
 CurrentCompany (string),
 CurrentJobTitle (string),
 LastSignedInTime (string, optional),
 LastActivityTime (string, optional)
 }
 */
