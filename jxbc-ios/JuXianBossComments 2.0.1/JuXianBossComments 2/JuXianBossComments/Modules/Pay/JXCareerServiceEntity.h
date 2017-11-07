//
//  JXCareerServiceEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface JXCareerServiceEntity : JSONModel

@property (nonatomic,assign)long ServiceId;
@property (nonatomic,assign)long PassportId;
@property (nonatomic,copy)NSString<Optional> *Subject;
@property (nonatomic,copy)NSString<Optional> *Picture;
@property (nonatomic,copy)NSString<Optional> *PictureData;//发布使用

@property (nonatomic,copy)NSMutableArray<Optional> *Contents;
@property (nonatomic,copy)NSString<Optional> *Content;

@property (nonatomic,copy)NSString<Optional> *shareUrl;
@property (nonatomic,assign)double Price;

@property (nonatomic,assign)int ReadCount;
@property (nonatomic,assign)int SharedCount;
@property (nonatomic,assign)int FavoriteCount;
@property (nonatomic,assign)int BuyerCount;


@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,copy)NSString<Optional> *SelfIntroduction;//发布使用
@property (nonatomic,assign)bool IsFavorite;

//@property (nonatomic,strong)JXConsultantProfile<Optional> *Profile;


/**2.0判断是否可以购买*/
//购买的在服务中不能再次购买
@property (nonatomic,assign) bool CanBuy;

@end
