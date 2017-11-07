//
//  messageEntity.h
//  JuXianBossComments
//
//  Created by wy on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageEntity : JSONModel

@property(nonatomic,copy)NSString<Optional> *Content;

@property(nonatomic,assign)long IsRead;

@property (nonatomic,strong)NSDate<Optional> * CreatedTime;
//时间
@property (nonatomic,strong)NSDate<Optional> * SendTime;

@property(nonatomic,copy)NSString<Optional> *SendType;
@property(nonatomic,copy)NSString<Optional> *Subject;

@property(nonatomic,assign)long MessageId;

@property(nonatomic,assign)long CompanyId;
@property(nonatomic,assign)long PassportId;
@property(nonatomic,assign)long FromPassportId;
@property(nonatomic,assign)long BizId;
@property(nonatomic,assign)long BizType;

@property(nonatomic,copy)NSString<Optional> *Picture;
@property(nonatomic,copy)NSString<Optional> *EventModel;
@property(nonatomic,copy)NSString<Optional> *BizEvent;

//空就是没有邀请公司，有值就直接显示
@property(nonatomic,copy)NSString <Optional>*ExtendParams;

@end
/*
 
 Message {
 Content (string, optional): 消息内容 ,
 IsRead (integer, optional): 是否已读，默认1未读，0已读 ,
 SentTime (string, optional): 发送时间 ,
 CreatedTime (string, optional): ,
 
 SendType (string, optional): 发送方式（短信/站内消息/推送通知） ,
 Subject (string, optional): 消息标题 ,
 MessageId (integer): 消息id，不需要用传参 ,
 CompanyId (integer, optional): 公司id ,
 PassportId (integer, optional): 接收人id ,
 FromPassportId (integer, optional): 发送人id ,
 EventId (integer, optional): 业务事件id ,
 BizId (integer, optional): 业务ID ,
 Picture (string, optional): 图片url ,
 EventModel (string, optional):
 }
 */
