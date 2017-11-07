//
//  FeedbackEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FeedbackEntity : JSONModel

@property (nonatomic, assign) long FeedbackId;
@property (nonatomic, assign) long CompanyId;
@property (nonatomic, assign) long PassportId;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, strong) NSDate *CreatedTime;
@property (nonatomic, strong) NSDate *ModifiedTime;

@end

/*
 Feedback {
 FeedbackId (integer, optional): 自增ID ,
 CompanyId (integer, optional): 企业ID ,
 PassportId (integer): 用户ID ,
 Content (string): 反馈内容 ,
 CreatedTime (string, optional): 发布时间 ,
 ModifiedTime (string, optional): 修改时间
 }
 */
