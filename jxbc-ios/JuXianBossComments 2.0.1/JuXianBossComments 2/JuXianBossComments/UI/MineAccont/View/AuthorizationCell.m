//
//  AuthorizationCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AuthorizationCell.h"

@implementation AuthorizationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

//授权管理
- (void)setMembeEntity:(CompanyMembeEntity *)membeEntity{
    _membeEntity = membeEntity;
    self.nameLabel.text = membeEntity.RealName;
    
    if (membeEntity.Role == Role_manager) {
        self.roleLabel.text = @"管理员";

    }else if (membeEntity.Role == Role_Boss){
    
        self.roleLabel.text = @"公司法人";
        self.fixBtn.hidden = YES;
        self.delegateBtn.hidden = YES;

    }else if (membeEntity.Role == Role_HightManager){
        self.roleLabel.text = @"高管";
    }else{
        self.roleLabel.text = @"建档员";
    }
}


- (IBAction)fixClick:(id)sender {

    if ([self.delegate respondsToSelector:@selector(authorizationCellClickedfixBtnWithIndexPath:WithCell:)]) {
        [self.delegate authorizationCellClickedfixBtnWithIndexPath:self.indexPath WithCell:self];
    }
}

- (IBAction)delegateClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(authorizationCellClickedDelegateBtnWithIndexPath:WithCell:)]) {
        [self.delegate authorizationCellClickedDelegateBtnWithIndexPath:self.indexPath WithCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
