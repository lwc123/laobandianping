//
//  StaffListCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkItemEntity.h"

//员工列表cell
@interface StaffListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**评价个数*/
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
/**职位名称*/
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
/**加入公司时间*/
@property (weak, nonatomic) IBOutlet UILabel *joinDateLabel;
@property (nonatomic,strong)EmployeArchiveEntity * employeModel;
@property (nonatomic,strong)WorkItemEntity * workItemMolde;

@end
