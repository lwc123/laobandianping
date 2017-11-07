//
//  ContactEntity.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/9.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JXUserProfile.h"
//#import "JXConsultantProfile.h"

@interface ContactEntity : JSONModel

@property (nonatomic,assign)long PassportId;
@property (nonatomic,assign)long FriendPassportId;

@property (nonatomic,assign)CurrentProfileType FriendProfileType;

@property (nonatomic,copy)NSString<Optional> *LastContactSource;
@property (nonatomic,copy)NSString<Optional> *LastContactMessage;
@property (nonatomic,strong)NSDate<Optional> * ModifiedTime;

@property (nonatomic ,strong)JXUserProfile<Ignore> *FriendProfile;
@property (nonatomic ,strong)JXUserProfile<Optional> *UserProfile;
//@property (nonatomic ,strong)JXConsultantProfile<Optional> *ConsultantProfile;

@end
