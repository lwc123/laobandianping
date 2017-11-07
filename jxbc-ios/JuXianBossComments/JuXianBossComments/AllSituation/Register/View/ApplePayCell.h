//
//  ApplePayCell.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ApplePayCell;

@protocol ApplePayCellDelegate <NSObject>

- (void)ApplePayCellDidClickedPayBtn:(ApplePayCell *)applePayCell;

@end

@interface ApplePayCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (nonatomic,weak) id<ApplePayCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *despritonLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoldMoneyLabel;


@end
