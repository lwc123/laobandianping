//
//  JXServiceModel.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/19.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JXUserProfile.h"
@interface JXServiceModel : JSONModel
@property (nonatomic,strong) JXUserProfile<Optional>*profile;
@property (nonatomic,strong) NSNumber<Optional>*ServiceId;
@property (nonatomic,strong) NSNumber<Optional>*PassportId;
@property (nonatomic,strong) NSArray<Optional>*Content;
@property (nonatomic,copy)   NSString<Optional>*Brief;
@property (nonatomic,strong) NSNumber<Optional>*Price;
@property (nonatomic,copy)   NSString<Optional>*CreatedTime;
@property (nonatomic,copy)   NSString<Optional>*ModifiedTime;
@property (nonatomic,copy)   NSString<Optional>*ExpiredTime;
@property (nonatomic,copy)   NSString<Optional>*ImgPath;
@property (nonatomic,strong) NSNumber<Optional>*Popularity;
@property (nonatomic,strong) NSNumber<Optional>*ProductType;
@property (nonatomic, strong) NSString<Optional>*ImgStream;
//IsColl
@property (nonatomic,assign) NSNumber <Optional>*IsColl;
@end
