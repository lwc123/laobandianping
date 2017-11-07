//
//  OpenViewCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/4.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceStrategyEntity.h"

@interface OpenViewCell : UITableViewCell

//折扣
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
//春节
@property (weak, nonatomic) IBOutlet UILabel *springLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuanMoney;

@property (nonatomic,strong)PriceStrategyEntity * priceEntity;
@property (weak, nonatomic) IBOutlet UILabel *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *discountImage;
//真正的
@property (weak, nonatomic) IBOutlet UIView *realyLineView;
@property (weak, nonatomic) IBOutlet UILabel *openLabel;
@property (weak, nonatomic) IBOutlet UILabel *openFierLabel;

@end
