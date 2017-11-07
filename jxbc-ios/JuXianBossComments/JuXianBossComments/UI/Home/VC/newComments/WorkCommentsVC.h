//
//  WorkCommentsVC.h
//  JuXianBossComments
//
//  Created by easemob on 2016/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"

@interface WorkCommentsVC : JXTableViewController
//阶段评价列表
@property (nonatomic,assign)long companyId;
@property (nonatomic,strong)ArchiveCommentEntity * detailComment;
@property (nonatomic,strong)EmployeArchiveEntity * employeArchive;
@property (nonatomic,strong)UIViewController * secondVC;

//选择员工档案
@property (nonatomic,assign)long archiveId;
@property (nonatomic,copy)NSString * imageStr;
@property (nonatomic,copy)NSString * nameStr;

- (instancetype)initWithStaff:(EmployeArchiveEntity*)staff;

@end
