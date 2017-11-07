//
//  ArchiveCommentLogEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CompanyMembeEntity.h"

//修改记录
@interface ArchiveCommentLogEntity : JSONModel

@property (nonatomic, assign) long LogId;
@property (nonatomic, assign) long CompanyId;
@property (nonatomic, assign) long PresenterId;
@property (nonatomic, assign) long CommentId;

@property (nonatomic, strong) NSDate *CreatedTime;
@property (nonatomic, strong) NSDate *ModifiedTime;
@property (nonatomic, strong) CompanyMembeEntity *CompanyMember;

@end
/*
 ArchiveCommentLog {
 LogId (integer, optional): ,
 CompanyId (integer, optional): ,
 PresenterId (integer, optional): ,
 CommentId (integer): ,
 
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional): ,
 CompanyMember (CompanyMember, optional): 修改人信息
 }
 */
