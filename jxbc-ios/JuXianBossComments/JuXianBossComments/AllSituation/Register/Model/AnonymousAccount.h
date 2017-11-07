//
//  Account.h
//  JuXianTalentBank
//
//  Created by 马欣欣 on 15/7/31.
//  Copyright (c) 2015年 Max. All rights reserved.
//

#import "JSONModel.h"
#import "AnonymousAccountToken.h"
#import "JXUserProfile.h"
#import "JXOrganizationProfile.h"


@interface AnonymousAccount : JSONModel

//此三个属性显示的是用户第二次请求的信息(可选)
@property (nonatomic ,strong)NSString<Optional> *Avatar;

@property (nonatomic ,assign)long AccountId;
@property (nonatomic ,assign)long DeviceId;
@property (nonatomic ,assign)long PassportId;
@property (nonatomic ,strong)NSString<Optional>*Nickname;
@property (nonatomic ,strong)NSString<Optional> *MobilePhone;
@property (nonatomic ,strong)NSString<Optional> *CreatedTime;
@property (nonatomic ,strong)NSString<Optional> *LastModifiedTime;
@property (nonatomic ,strong)AnonymousAccountToken *Token;

//@property (nonatomic ,strong)JXUserProfile<Ignore> *Profile;
//@property (nonatomic ,strong)JXUserProfile<Optional> *UserProfile;
@property (nonatomic ,strong)JXOrganizationProfile<Optional> *UserProfile;

/**已拥有的身份*/
@property (nonatomic ,assign)NSInteger  MultipleProfiles;


//- (JXOrganizationProfile*)getUserProfile;

@end

@interface ThirdPassport : JSONModel

@property (nonatomic ,strong)NSString<Optional> *ThirdPassportId;
@property (nonatomic ,strong)NSString<Optional> *Platform;
@property (nonatomic ,strong)NSString<Optional> *PlatformPassportId;
@property (nonatomic ,strong)NSString<Optional> *PhotoUrl;
@property (nonatomic ,strong)NSString<Optional> *PassportInfo;

@end
