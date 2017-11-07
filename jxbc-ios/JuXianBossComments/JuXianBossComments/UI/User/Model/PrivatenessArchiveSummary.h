//
//  PrivatenessArchiveSummary.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//没有绑定身份证号 通过手机号判断
@interface PrivatenessArchiveSummary : JSONModel

@property (nonatomic,assign)long ArchiveNum;
@property (nonatomic,assign)long StageEvaluationNum;
@property (nonatomic,assign)long DepartureReportNum;


@end
/*
 
 ArchiveNum (integer, optional): 档案个数 ,
 StageEvaluationNum (integer, optional): 阶段评价个数 ,
 DepartureReportNum (integer, optional): 离任报告个数
 */
