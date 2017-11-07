//
//  CareerAdviceEntity.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/3.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "JXUserProfile.h"
//#import "JXConsultantProfile.h"
@interface CareerAdviceEntity : JSONModel

@property (nonatomic,assign)long AdviceId;
@property (nonatomic,assign)long PassportId;
@property (nonatomic,copy)NSString<Optional> *Subject;
@property (nonatomic,copy)NSString<Optional> *Picture;
@property (nonatomic,copy)NSString<Optional> *PictureData;//发布使用
@property (nonatomic,copy)NSString<Optional> *Content;
@property (nonatomic,assign)int ReadCount;
@property (nonatomic,assign)int SharedCount;
@property (nonatomic,assign)int FavoriteCount;
@property (nonatomic,assign)int GratuityCount;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;

@property (nonatomic,assign)bool IsFavorite;
//@property (nonatomic,strong)JXConsultantProfile<Optional> *Profile;

@end
