//
//  AddJobViewController.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/25.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
#import "JobModel.h"
#import "WorkItemEntity.h"
typedef void(^myJobBlock)(WorkItemEntity *workItemEntity,NSString * startDateStr,NSString * endDateStr);

//添加职务
@interface AddJobViewController : JXTableViewController
@property (nonatomic,copy)myJobBlock workItemBlock;
@property (nonatomic,strong)WorkItemEntity *workItemEntity;

@property (nonatomic, strong) NSString *joinCompanyDate;
@property (nonatomic, strong) NSString *leaveCompanyDate;

@end
