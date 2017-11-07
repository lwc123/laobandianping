//
//  OpinionReplyEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

typedef NS_ENUM(NSInteger, ReplyType) {
    ReplyType_User = 0,//个人
    ReplyType_Company = 1//公司
};

//谢谢评论实体
@interface OpinionReplyEntity : JSONModel
@property (nonatomic,assign)long ReplyId;
//点评ID
@property (nonatomic,assign)long OpinionId;
@property (nonatomic,assign)long CompanyId;
//提交人
@property (nonatomic,assign)long PassportId;
//修改人
@property (nonatomic,assign)long ModifiedId;
@property (nonatomic,assign)long TopicId;
//评论类型，0个人回复，1公司回复
@property (nonatomic,assign)ReplyType ReplyType;

@property (nonatomic, copy) NSString<Optional> *NickName;
@property (nonatomic, copy) NSString<Optional> *Avatar;
//显示状态，默认1显示，2隐藏
@property (nonatomic, assign) long AuditStatus;
//点评内容
@property (nonatomic, copy) NSString<Optional> *Content;
//导入时间
@property (nonatomic, strong) NSDate<Optional> *LeadingTime;
@property (nonatomic, strong) NSDate<Optional> *CreatedTime;
@property (nonatomic, strong) NSDate<Optional> *ModifiedTime;

@end
/*
  ReplyId (integer, optional): ,
 OpinionId (integer): 点评ID ,
 CompanyId (integer, optional): 公司ID ,
 PassportId (integer, optional): 提交人 ,
 ModifiedId (integer, optional): 修改人 ,
 ReplyType (integer, optional): 评论类型，0个人回复，1公司回复 ,
 NickName (string, optional): 昵称 ,
 Avatar (string, optional): 头像 ,
 AuditStatus (integer, optional): 显示状态，默认1显示，2隐藏 ,
 Content (string): 点评内容 ,
 LeadingTime (string, optional): 导入时间 ,
 ModifiedTime (string, optional): ,
 CreatedTime (string, optional):
 */
