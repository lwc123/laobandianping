//
//  CompanyWallentCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CompanyWallentCell.h"

@implementation CompanyWallentCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setWalletModel:(WalletEntity *)walletModel{

    _walletModel = walletModel;
    if (walletModel.AvailableBalance) {
        
        self.vaultLabel.text = [NSString stringWithFormat:@"%@金币",walletModel.AvailableBalance];
    }else{
        self.vaultLabel.text = @"0金币";
    }
    
    if ([walletModel.CanWithdrawBalance integerValue]) {
        
        self.withdrawalsMoney.text = [NSString stringWithFormat:@"%@金币",walletModel.CanWithdrawBalance];
    }else{
        self.withdrawalsMoney.text = @"0金币";
    }
}
- (IBAction)subMoneyClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(companyWallentCellDidClickedSubmitMoney:)]) {
        
        [self.delegate companyWallentCellDidClickedSubmitMoney:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
