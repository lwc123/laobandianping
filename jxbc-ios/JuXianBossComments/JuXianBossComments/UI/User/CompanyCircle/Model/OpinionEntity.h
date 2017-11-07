//
//  OpinionEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "OpinionCompanyEntity.h"

@interface OpinionEntity : JSONModel
@property (nonatomic,assign)long OpinionId;
//公司ID ,
@property (nonatomic,assign)long CompanyId;
//提交人
@property (nonatomic,assign)long PassportId;
//修改人
@property (nonatomic,assign)long ModifiedId;
@property (nonatomic,copy)NSString<Optional>*NickName;
@property (nonatomic,copy)NSString<Optional>*Avatar;
@property (nonatomic,assign)long AuditStatus;//显示状态，默认1显示，2不显示
//入职日期，如：2015-01-01
@property (nonatomic,strong)NSDate<Optional> *EntryTime;
//离职日期，如：2017-01-01或者至今3000-01-01
@property (nonatomic,strong)NSDate<Optional> *DimissionTime;

//工作年龄 ,
@property (nonatomic,copy)NSString<Optional>*WorkingYears;
//城市 ,
@property (nonatomic,copy)NSString<Optional>*Region;
//点评标签（数组） ,
@property (nonatomic,strong)NSArray<Optional>*Labels;
//点评标题 ,
@property (nonatomic,copy)NSString<Optional>*Title;
//点评内容 ,
@property (nonatomic,copy)NSString<Optional>*Content;
//点评打分数
@property (nonatomic,assign)double Scoring;

//推荐给朋友分数，推荐：100分 不推荐：50分 ,
@property (nonatomic,assign)long Recommend;
//公司前景分数，看好：100分 一般：80分 不看好：50分 ,
@property (nonatomic,assign)long Optimistic;
//支持CEO分数，支持：100分 不支持：50分
@property (nonatomic,assign)long SupportCEO;
//点赞数
@property (nonatomic,assign)long LikedCount;
//阅读数
@property (nonatomic,assign)long ReadCount;
//回复数
@property (nonatomic,assign)long ReplyCount;
//最后回复时间
@property (nonatomic,strong)NSDate<Optional> *LastReplyTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
@property (nonatomic, strong)OpinionCompanyEntity *Company;

//是否点赞
@property (nonatomic,assign)BOOL IsLiked;


@end
/*

 OpinionId (integer, optional): ,
 CompanyId (integer): 公司ID ,
 PassportId (integer): 提交人 ,
 ModifiedId (integer, optional): 修改人 ,
 
 
 NickName (string, optional): 昵称 ,
 Avatar (string, optional): 头像 ,
 
 
 AuditStatus (integer, optional): 显示状态，默认1显示，2隐藏 ,
 EntryTime (string, optional): 入职日期，如：2015-01-01 ,
 DimissionTime (string, optional): 离职日期，如：2017-01-01或者至今3000-01-01 ,

 WorkingYears (string, optional): 工作年龄 ,
 Region (string, optional): 城市 ,
 Labels (string, optional): 点评标签（数组） ,
 Title (string, optional): 点评标题 ,
 Content (string): 点评内容 ,
 
 
 Scoring (integer, optional): 点评打分数 ,
 Recommend (integer, optional): 推荐给朋友分数，推荐：100分 不推荐：50分 ,
 Optimistic (integer, optional): 公司前景分数，看好：100分 一般：80分 不看好：50分 ,
 SupportCEO (integer, optional): 支持CEO分数，支持：100分 不支持：50分 ,
 LikedCount (integer, optional): 点赞数 ,
 ReadCount (integer, optional): 阅读数 ,
 ReplyCount (integer, optional): 回复数 ,
 
 
 
 LastReplyTime (string, optional): 最后回复时间 ,
 ModifiedTime (string, optional): ,
 CreatedTime (string, optional):
 
 */


