//
//  PayMethodCell.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/8.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMethodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *companyKuLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneylabel;
//金库支付的余额显示
@property (weak, nonatomic) IBOutlet UILabel *valutExplan;

@end
