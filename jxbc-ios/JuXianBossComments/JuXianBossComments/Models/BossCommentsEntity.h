//
//  BossCommentsEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/31.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "TargetEmploye.h"

//老板点评的model
@interface BossCommentsEntity : JSONModel

/**
 姓名
 */
@property (nonatomic,copy)NSString<Optional>* TargetName;
/**
 身份证号
 */
@property (nonatomic,copy)NSString<Optional>* TargetIDCard;
/**
 职位名称
 */
@property (nonatomic,copy)NSString<Optional>* TargetJobTitle;
/**
 工作能力
 */
@property (nonatomic,assign)int WorkAbility;
/**
 工作态度
 */
@property (nonatomic,assign)int WorkManner;
/**
 工作业绩
 */
@property (nonatomic,assign)int WorkAchievement;
/**
 评论的文本textView
 */
@property (nonatomic,copy)NSString<Optional>* Text;
/**
  语音评论
 */
@property (nonatomic,copy)NSString<Optional>* Voice;
/**
 上传的照片
 */
@property (nonatomic,strong)NSArray<Optional>* Images;

@property (nonatomic,assign)long EmployeId;

@property (nonatomic,strong)NSDate<Optional>* CreatedTime;
@property (nonatomic,strong)NSDate<Optional>* ModifiedTime;
//录音的时长
@property (nonatomic,copy)NSString<Optional>* VoiceLength;

/**
 评价者的名字
 */
@property (nonatomic,copy)NSString<Optional>* CommentatorName;
/**
 评价者的公司
 */
@property (nonatomic,copy)NSString<Optional>* EntName;


@end
/*
 
 
 {
 "EntName": "sample string 1",
 "Id": 3,
 "PersistentState": 0,
 "CommentId": 3,
 "CommentEntId": 4,
 "CommentatorId": 5,
 "CommentatorName": "sample string 6",
 "CommentatorJobTitle": "sample string 7",
 
 "TargetName": "sample string 8",       姓名
 "TargetIDCard": "sample string 9",     身份证号
 "TargetJobTitle": "sample string 10",  职位名称
 "TargetTags": "sample string 11",
 "WorkAbility": 12,                     工作能力
 "WorkManner": 13,                      工作态度
 "WorkAchievement": 14,                 工作业绩
 "Text": "sample string 15",            评论的文本textView
 "Voice": "sample string 16",           语音评论
 "Images": [                            上传的照片
 "sample string 1",
 "sample string 2",
 "sample string 3"
 ],
 "CreatedTime": "2016-10-31T02:09:40Z",
 "ModifiedTime": "2016-10-31T02:09:40Z"
 }
 
 */