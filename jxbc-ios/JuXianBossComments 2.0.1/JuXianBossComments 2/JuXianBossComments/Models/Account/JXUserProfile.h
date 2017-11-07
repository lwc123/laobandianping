//
//  JXUserProfile.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/19.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSInteger, CurrentProfileType) {
    Unknown = 0,
    UserProfile = 1,
    OrganizationProfile = 2
};

typedef NS_ENUM(NSInteger, AttestationStatus) {
    AttestationStatus_None,//没有认证
    AttestationStatus_Submited,//提交认证
    AttestationStatus_Passed,//通过认证
    AttestationStatus_Rejected//拒绝认证
};
@interface JXUserProfile : JSONModel

@property(nonatomic,strong)NSNumber<Optional>*PassportId;
@property (nonatomic,copy)NSString<Optional>*MobilePhone;
@property (nonatomic,copy)NSString<Optional>*Nickname;
@property (nonatomic,copy)NSString<Optional>*RealName;
@property (nonatomic,copy)NSString<Optional>*Avatar;
@property (nonatomic, assign) long CurrentOrganizationId;
//等级
@property (nonatomic,assign)int Gender;
@property (nonatomic,copy)NSDate *Birthday;
@property (nonatomic,copy)NSString<Optional>*Email;

//人才端的公司XJH
@property (nonatomic,copy)NSString<Optional>*CurrentCompany;//公司信息
@property (nonatomic,copy)NSString<Optional>*CurrentJobTitle;//职位信息
@property (nonatomic,copy)NSString<Optional>*CurrentIndustry;//code
@property (nonatomic,copy)NSString<Optional>*CurrentJobCategory;//code
@property (nonatomic,copy)NSString<Optional>*SelfIntroduction;
@property (nonatomic,copy)NSString<Optional>*CurrentIndustryText;//text
@property (nonatomic,copy)NSString<Optional>*CurrentJobCategoryText;//text

@property (nonatomic,assign)int CurrentProfileType; //当前用户身份
//认证状态
@property (nonatomic,assign)int AttestationStatus;


- (CurrentProfileType) getCurrentProfileType;


@end
