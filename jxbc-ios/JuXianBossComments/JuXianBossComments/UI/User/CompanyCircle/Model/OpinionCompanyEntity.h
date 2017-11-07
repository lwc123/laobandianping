//
//  OpinionCompanyEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OpinionCompanyEntity : JSONModel

@property (nonatomic,assign)long CompanyId;
//是否被认领，1未认领，2已认领 
@property (nonatomic,assign)BOOL IsClaim;
//认领公司ID 
@property (nonatomic,assign)long ClaimCompanyId;
//采集原ID
@property (nonatomic,assign)long CollectionCompanyId;
@property (nonatomic,copy)NSString<Optional>*CompanyName;
@property (nonatomic,copy)NSString<Optional>*CompanyAbbr;
@property (nonatomic,copy)NSString<Optional>*CompanyCEO;
@property (nonatomic,copy)NSString<Optional>*CompanyLogo;
//是否可以评论，默认1开启，2关闭
@property (nonatomic,assign)BOOL IsCloseComment;
//公司总得分
@property (nonatomic,assign)double Score;
//推荐给朋友平均分 ,
@property (nonatomic,assign)long Recommend;
//公司前景平均分 ,
@property (nonatomic,assign)long Optimistic;
//支持CEO分数平均分 ,
@property (nonatomic,assign)long SupportCEO;

//城市 ,
@property (nonatomic,copy)NSString<Optional>*Region;
//规模 ,
@property (nonatomic,copy)NSString<Optional>*CompanySize;
//行业 ,
@property (nonatomic,copy)NSString<Optional>*Industry;
//标签 ,
@property (nonatomic,strong)NSArray<Optional>*Labels;
// 产品 ,
@property (nonatomic,copy)NSString<Optional>*Products;
//图片 ,
@property (nonatomic,copy)NSString<Optional>*Photos;
//一句话介绍 ,
@property (nonatomic,copy)NSString<Optional>*BriefIntroduction;
//公司介绍 ,
@property (nonatomic,copy)NSString<Optional>*Introduction;
// 公司地址 ,
@property (nonatomic,copy)NSString<Optional>*Address;

// 关注数 ,
@property (nonatomic,assign)long LikedCount;
//阅读数 ,
@property (nonatomic,assign)long ReadCount;
//点评数 ,
@property (nonatomic,assign)long CommentCount;
// 员工数 ,
@property (nonatomic,assign)long StaffCount;
//成立时间
@property (nonatomic,strong)NSDate<Optional> *EstablishedTime;
@property (nonatomic,strong)NSDate<Optional> *ModifiedTime;
@property (nonatomic,strong)NSDate<Optional> *CreatedTime;
//是否老东家
@property (nonatomic,assign)BOOL IsFormerClub;
//是否关注
@property (nonatomic,assign)BOOL IsConcerned;
//点评多少
@property (nonatomic, strong) NSArray<Optional> *Opinions;

//是否显示红点 ,
@property (nonatomic,assign)BOOL IsRedDot;
// 分享链接（企业详情） ,
@property (nonatomic,copy)NSString<Optional>*ShareLink;

@end
/*
 CompanyId (integer): 公司ID ,
 IsClaim (integer, optional): 是否被认领，1未认领，2已认领 ,
 ClaimCompanyId (integer, optional): 认领公司ID ,
 CollectionCompanyId (integer, optional): 采集原ID ,
 CompanyName (string, optional): 公司名称 ,
 CompanyAbbr (string, optional): 公司简称 ,
 CompanyCEO (string, optional): 公司CEO ,
 CompanyLogo (string, optional): 公司LOGO ,
 IsCloseComment (integer, optional): 是否可以评论，默认1开启，2关闭 ,
 Score (string, optional): 公司总得分 ,
 
 Recommend (integer, optional): 推荐给朋友平均分 ,
 Optimistic (integer, optional): 公司前景平均分 ,
 SupportCEO (integer, optional): 支持CEO分数平均分 ,
 
 Region (string, optional): 城市 ,
 CompanySize (string, optional): 规模 ,
 Industry (string, optional): 行业 ,
 Labels (string, optional): 标签 ,
 Products (string, optional): 产品 ,
 Photos (string, optional): 图片 ,
 BriefIntroduction (string, optional): 一句话介绍 ,
 Introduction (string, optional): 公司介绍 ,
 Address (string, optional): 公司地址 ,
 
 LikedCount (integer, optional): 关注数 ,
 ReadCount (integer, optional): 阅读数 ,
 CommentCount (integer, optional): 点评数 ,
 StaffCount (integer, optional): 员工数 ,
 
 
 EstablishedTime (string, optional): 成立时间 ,
 ModifiedTime (string, optional): ,
 CreatedTime (string, optional):
 */
