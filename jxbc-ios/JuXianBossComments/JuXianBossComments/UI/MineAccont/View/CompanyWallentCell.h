//
//  CompanyWallentCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletEntity.h"

@class CompanyWallentCell;

@protocol CompanyWallentCellDelegate <NSObject>

- (void)companyWallentCellDidClickedSubmitMoney:(CompanyWallentCell *)companyWallentCell;

@end



@interface CompanyWallentCell : UITableViewCell

@property (nonatomic,strong)WalletEntity * walletModel;
//金库
@property (weak, nonatomic) IBOutlet UILabel *vaultLabel;

//可提现金额
@property (weak, nonatomic) IBOutlet UILabel *withdrawalsMoney;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (nonatomic,weak) id<CompanyWallentCellDelegate> delegate;


@end
