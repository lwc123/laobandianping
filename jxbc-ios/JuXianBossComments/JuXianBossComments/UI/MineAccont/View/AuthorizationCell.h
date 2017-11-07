//
//  AuthorizationCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AuthorizationCell;
@protocol AuthorizationCellDelegate <NSObject>

- (void)authorizationCellClickedfixBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(AuthorizationCell *)authorizationCell;
- (void)authorizationCellClickedDelegateBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(AuthorizationCell *)authorizationCell;

@end

@interface AuthorizationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *fixBtn;
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;
@property (nonatomic,weak) id<AuthorizationCellDelegate> delegate;
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraintofFixBtn;




@end
