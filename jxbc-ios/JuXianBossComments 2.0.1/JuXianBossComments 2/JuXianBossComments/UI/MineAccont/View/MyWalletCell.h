//
//  MyWalletCell.h
//  JuXianTalentBank
//
//  Created by juxian on 16/5/11.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeJournalEntity.h"

@interface MyWalletCell : UITableViewCell

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * dateLabel;
@property (nonatomic,strong) UILabel * moneyLabel;
@property (nonatomic,strong) UILabel * companyLabel;

@property (nonatomic,strong) TradeJournalEntity * model;

+ (id)infoCellWithTableView:(UITableView *)tableView;

@end
