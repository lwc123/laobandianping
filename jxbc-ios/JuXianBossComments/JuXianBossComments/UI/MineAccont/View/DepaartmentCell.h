//
//  DepaartmentCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DepaartmentCell;
@protocol DepaartmentCelllDelegate <NSObject>

- (void)DepaartmentCellClickedfixBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(DepaartmentCell *)authorizationCell;
- (void)DepaartmentCelldDelegateBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(DepaartmentCell *)authorizationCell;

@end

//部门管理
@interface DepaartmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dapartMentsLabel;
@property (nonatomic,weak) id<DepaartmentCelllDelegate> delegate;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)DepartmentsEntity *departmentEntity;
@end
