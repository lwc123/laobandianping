//
//  AccountEntity.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/18.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "AnonymousAccountToken.h"
#import "JXUserProfile.h"


@interface AccountEntity : JSONModel
@property (nonatomic, strong)NSNumber<Optional> * AccountId;
@property (nonatomic, strong)NSString<Optional> * Avatar;
@property (nonatomic, strong)NSString <Optional> * CreatedTime;
@property (nonatomic, strong)NSNumber <Optional> * DeviceId;
@property (nonatomic, strong)NSNumber <Optional> * Id;
@property (nonatomic, strong)NSString <Optional> * MobilePhone;
@property (nonatomic, strong)NSString <Optional> * ModifiedTime;
@property (nonatomic, strong)NSString <Optional> * Nickname;
@property (nonatomic, strong)NSNumber <Optional> * PassportId;
@property (nonatomic, strong)NSNumber <Optional> * PersistentState;
@property (nonatomic, strong)AnonymousAccountToken <Optional> * Token;
@property (nonatomic, strong)JXUserProfile <Optional> * UserProfile;

@end
