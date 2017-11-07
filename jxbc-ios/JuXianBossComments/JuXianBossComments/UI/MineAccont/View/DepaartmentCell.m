//
//  DepaartmentCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "DepaartmentCell.h"

@implementation DepaartmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDepartmentEntity:(DepartmentsEntity *)departmentEntity{

    _departmentEntity = departmentEntity;
    self.dapartMentsLabel.text = departmentEntity.DeptName;
}

//修改
- (IBAction)upDateBnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(DepaartmentCellClickedfixBtnWithIndexPath:WithCell:)]) {
        
        [self.delegate DepaartmentCellClickedfixBtnWithIndexPath:self.indexPath WithCell:self];
    }
}

//删除
- (IBAction)delagateBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(DepaartmentCelldDelegateBtnWithIndexPath:WithCell:)]) {
        
        [self.delegate DepaartmentCelldDelegateBtnWithIndexPath:self.indexPath WithCell:self];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
