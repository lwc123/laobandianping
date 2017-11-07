//
//  JXMessageEntity.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(int, MessageType) {
    MessageType_Notice = 1,//通知消息
    MessageType_Wait = 2//待处理消息
};

@interface JXMessageEntity : JSONModel
@property(nonatomic,assign)long MessageId;
@property(nonatomic,assign)long ToPassportId;
@property(nonatomic,assign)long ToCompanyId;

@property(nonatomic,assign)long FromPassportId;
@property(nonatomic,assign)long FromCompanyId;
@property(nonatomic,assign)long BizType;
@property(nonatomic,assign)long BizId;
@property(nonatomic,copy)NSString<Optional> *Subject;
//消息图标
@property(nonatomic,copy)NSString<Optional> *Picture;

@property(nonatomic,copy)NSString<Optional> *SendType;
@property(nonatomic,copy)NSString<Optional> *Content;
@property(nonatomic,strong)NSDate<Optional> *ReadTime;
@property(nonatomic,strong)NSDate<Optional> *CreatedTime;
@property(nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property(nonatomic,assign)long IsRead;


@end
/*
 
 Message {
 MessageId (integer, optional): 消息id，不需要用传参 ,
 ToPassportId (integer, optional): 接收人id ,
 ToCompanyId (integer, optional): 接收人公司id ,
 FromPassportId (integer, optional): 发送人id ,
 FromCompanyId (integer, optional): 发送人公司id ,
 BizType (string, optional): 业务类型BizType=0 不可点消息，BizType=2 离任报告 ，BizType=3阶段评价 ,
 
 BizId (string, optional): 业务ID（离任报告id或者阶段评价id） ,
 Subject (string, optional): 消息标题 ,
 Content (string, optional): 消息内容 ,
 
 IsRead (integer, optional): 是否已读，默认0未读，1已读 ,
 ReadTime (string, optional): 已读时间 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }

 */
