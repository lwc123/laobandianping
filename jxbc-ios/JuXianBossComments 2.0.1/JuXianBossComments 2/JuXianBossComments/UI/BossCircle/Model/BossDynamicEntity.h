//
//  BossDynamic.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface CompanyEntity : JSONModel

//"CompanyId"
@property (nonatomic,assign) long CompanyId;

//"PassportId"
@property (nonatomic,assign) long PassportId;

//"ModifiedId": null,
//"CompanyName": "举贤网老板点评3",
@property (nonatomic,copy) NSString<Optional> *CompanyName;

//"CompanyAbbr"
@property (nonatomic,copy) NSString<Optional> *CompanyAbbr;

//"LegalName"
@property (nonatomic,copy) NSString<Optional> *LegalName;

//"Region" 地区
@property (nonatomic,copy) NSString<Optional> *Region;

//"CompanySize": 规模
@property (nonatomic,copy) NSString<Optional> *CompanySize;

//"Industry" 行业
@property (nonatomic,copy) NSString<Optional> *Industry;

//"CompanyLogo" logo URL
@property (nonatomic,copy) NSString<Optional> *CompanyLogo;

//"AuditStatus": 2,
@property (nonatomic,assign) long AuditStatus;

//"ContractStatus": 0,
@property (nonatomic,assign) long ContractStatus;

//"CreatedTime": "2016-12-05T08:29:53Z",
@property (nonatomic,strong) NSDate<Optional> *CreatedTime;

//"ModifiedTime": "2016-12-09T04:06:44Z"
@property (nonatomic,strong) NSDate<Optional> * ModifiedTime;

@end


@interface BossDynamicCommentEntity : JSONModel

// 评论id ,
@property (nonatomic,assign) long CommentsId;

// 动弹id ,
@property (nonatomic,assign) long DynamicId;

// 公司id ,
@property (nonatomic,assign) long CompanyId;

// 发表评论的用户id ,
@property (nonatomic,assign) long PassportId;

// 评论时间 ,
@property (nonatomic,assign) long CreatedTime;

// 发表评论的公司简称 ,
@property (nonatomic,assign) NSString* CompanyAbbr;

// 评论内容josn字符串
@property (nonatomic,copy) NSString<Optional>* Content;


@end


@interface BossDynamicEntity : JSONModel

// 动态id ,
@property (nonatomic,assign) long DynamicId;

// 公司id ,
@property (nonatomic,assign) long CompanyId;

// 发布用户id ,
@property (nonatomic,assign) long PassportId;

// 图片地址(json数组) ,
@property (nonatomic,strong) NSArray<Optional> *Img;

// 动态内容json字符串 ,
@property (nonatomic,copy) NSString<Optional> *Content;

// 是否赞过 ,
@property (nonatomic,assign) BOOL IsLiked;

// 发布时间 ,
@property (nonatomic,copy) NSDate<Optional> *CreatedTime;

// 评论数 ,
@property (nonatomic,assign) long CommentCount;

// 评论内容列表 ,
@property (nonatomic,strong) NSArray<BossDynamicCommentEntity *><Optional> *Comment;

// 点赞数
@property (nonatomic,assign) long LikedNum;

// 公司信息
@property (nonatomic,strong) CompanyEntity<Optional> *Company;

@end


