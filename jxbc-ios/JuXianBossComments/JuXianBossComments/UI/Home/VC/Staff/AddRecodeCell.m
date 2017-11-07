//
//  AddRecodeCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/4.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AddRecodeCell.h"
#import "JXAddAuthorizeVC.h"

@implementation AddRecodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)allBtnclick:(UIButton *)button {
    
    self.selectedBtn = button;
    
    if (self.selectedBtn.tag == 12) {//添加授权人那 管理员
        
        [self.managerBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
        [self.inJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
        [self.onJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
        
    }
    if (self.selectedBtn.tag == 13) {
        //seril@2x myok@2x.png
        
        [self.inJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
        [self.onJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
        [self.managerBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
    }
    if (self.selectedBtn.tag == 14) {
        
        [self.onJobBtn setImage:[UIImage imageNamed:@"myok"] forState:UIControlStateNormal];
        [self.inJobBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];
        [self.managerBtn setImage:[UIImage imageNamed:@"seril"] forState:UIControlStateNormal];

    }
            _index = (int)(self.selectedBtn.tag - 10);
    if ([self.delegate respondsToSelector:@selector(addRecodeCellClickTimeBtnWith:andView:)]) {
        [self.delegate addRecodeCellClickTimeBtnWith:_index andView:self];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
