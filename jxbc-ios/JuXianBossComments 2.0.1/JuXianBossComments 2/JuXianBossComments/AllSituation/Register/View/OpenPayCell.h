//
//  OpenPayCell.h
//  JuXianBossComments
//
//  Created by juxian on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenPayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *demoBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactUsButton;
//说明
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;

@end
