//
//  ArchiveCommentEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/9.
//  Copyright © 2016年 jinghan. All rights reserved.

#import <JSONModel/JSONModel.h>
#import "CompanyMembeEntity.h"
#import "EmployeArchiveEntity.h"
typedef NS_ENUM(int, CommentType) {
    CommentType_Comment = 0,//0代表阶段评价
    CommentType_Dismation = 1 //1 代表离任评价
};


//添加评价
@interface ArchiveCommentEntity : JSONModel
//档案ID
@property (nonatomic,assign)long ArchiveId;
@property (nonatomic,assign)long CommentId;
@property (nonatomic,assign)long CompanyId;


@property (nonatomic,assign)long PresenterId;
@property (nonatomic,assign)long ModifiedId;
//操作人的name
@property (nonatomic,copy)NSString<Optional>*  OperateRealName;
//0代表阶段评价 1 代表离任评价
@property (nonatomic,assign)long CommentType;
@property (nonatomic,assign)int AuditStatus;

@property (nonatomic,copy)NSString<Optional>* StageYear;
//阶段年份区间code
@property (nonatomic,copy)NSString<Optional>* StageSection;
//阶段年份区间name
@property (nonatomic,copy)NSString<Optional>* StageSectionText;

@property (nonatomic,assign)int WorkAbility;
@property (nonatomic,assign)int WorkAttitude;
@property (nonatomic,assign)int WorkPerformance;

@property (nonatomic,copy)NSString<Optional>* WorkComment;
@property (nonatomic,strong)NSArray<Optional>* WorkCommentImages;
@property (nonatomic,copy)NSString<Optional>* WorkCommentVoice;
@property (nonatomic,strong)NSDate<Optional> * DimissionTime;

// 离任原因Code
@property (nonatomic,copy)NSString<Optional>* DimissionReason;
//离任原因Name
@property (nonatomic,copy)NSString<Optional>* DimissionReasonText;


@property (nonatomic,copy)NSString<Optional>* DimissionSupply;

@property (nonatomic,assign)int HandoverTimely;
@property (nonatomic,assign)int HandoverOverall;
@property (nonatomic,assign)int HandoverSupport;
//返聘意愿Code
@property (nonatomic,copy)NSString<Optional>* WantRecall;
//返聘意愿Name
@property (nonatomic,copy)NSString<Optional>* WantRecallText;

@property (nonatomic,copy)NSString<Optional>* RejectReason;
//离任薪水
@property (nonatomic,copy)NSString<Optional>* DimissionSalary;

@property (nonatomic,strong)NSDate<Optional> * CreatedTime;
@property (nonatomic,strong)NSDate<Optional> * ModifiedTime;
@property (nonatomic,strong)NSArray<Optional> * AuditPersons;
@property (nonatomic,strong)EmployeArchiveEntity<Optional> *EmployeArchive;

//评价详情加一个审核人列表
@property (nonatomic,strong)NSArray<Optional> * AuditPersonList;

//录制多少秒
@property (nonatomic,assign)int WorkCommentVoiceSecond;
//是否发送短信
@property (nonatomic, assign) BOOL IsSendSms;


@end
/*
 
 ArchiveId (integer): 档案ID ,
 CommentId (integer, optional): ,
 PresenterId (integer, optional): 提交人 ,
 ModifiedId (integer, optional): 修改人 ,
 IsDimission (integer, optional): 是否离任报告，0否，1是 ,
 AuditStatus (integer, optional): 审核状态，0未审核，1审核中，2已审核，9被退回 ,
 StageYear (string, optional): 评价年份 ,
 StageSection (string, optional): 年份区间 ,
 WorkAbility (integer, optional): 工作能力 ,
 WorkAttitude (integer, optional): 工作态度 ,
 WorkPerformance (integer, optional): 工作业绩 ,
 
 WorkComment (string, optional): 评价文字 ,
 WorkCommentImages (string, optional): 评价图片 ,
 WorkCommentIVoice (string, optional): 评价录音 ,
 
 DimissionTime (string, optional): 离任时间 ,
 DimissionReason (string, optional): 离任原因 ,
 DimissionSupply (string, optional): 离任原因补充 ,
 
 HandoverTimely (integer, optional): 交接及时性 ,
 HandoverOverall (integer, optional): 交接全面性 ,
 HandoverSupport (integer, optional): 交接后续支持 ,
 
 WantRecall (string, optional): 返聘意愿 ,
 AuditPersons (CompanyMember, optional),
 RejectReason (string, optional): 驳回原因 ,
 ModifiedTime (string, optional): ,
 CreatedTime (string, optional):
 
 */
