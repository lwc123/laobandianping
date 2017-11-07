//
//  TopicEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OpinionCompanyEntity.h"

@interface TopicEntity : JSONModel


@property (nonatomic,assign)long TopicId;
@property (nonatomic, copy) NSString<Optional> *TopicName;
@property (nonatomic, copy) NSString<Optional> *HeadFigure;
@property (nonatomic, copy) NSString<Optional> *BannerPicture;
@property (nonatomic, assign) long IsOpen;
@property (nonatomic,assign)long TopicOrder;
@property (nonatomic, strong) NSDate<Optional> *CreatedTime;
@property (nonatomic, strong) NSDate<Optional> *ModifiedTime;
@property (nonatomic, strong) NSArray<Optional> *Companys;

@end
/*
 Topic {
 TopicId (integer, optional): 专题ID ,
 TopicName (string, optional): 专题名字 ,
 HeadFigure (string, optional): 专题头图 ,
 BannerPicture (string, optional): Banner图 ,
 
 IsOpen (boolean, optional): 是否开启专题 
 ,
 TopicOrder (integer, optional): 专题排序号 ,
 CreatedTime (string, optional): 创建时间 ,
 ModifiedTime (string, optional): 修改时间
 }
 */
