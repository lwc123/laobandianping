//
//  AddDepartureReportVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

//添加离任报告
@interface AddDepartureReportVC : JXTableViewController
@property (nonatomic,strong)ArchiveCommentEntity * detaiComment;

//这5个值是从员工列表传过来的
@property (nonatomic,copy)NSString * nameStr;
@property (nonatomic,copy)NSString * imageStr;
@property (nonatomic,copy)NSString * departmenStr;
@property (nonatomic,copy)NSString * postTitleStr;
@property (nonatomic,assign)long archiveId;
@property (nonatomic,strong)UIViewController * secondVC;

//选择档案传值
@property (nonatomic,strong)EmployeArchiveEntity * recodeEntity;


@end
