//
//  AskforJobCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskforJobCell : UITableViewCell

@property (nonatomic, strong) JobEntity *jobModel;

@property (weak, nonatomic) IBOutlet UILabel *jobName;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *createdTime;
@property (weak, nonatomic) IBOutlet UILabel *experienceRequireText;

@property (weak, nonatomic) IBOutlet UILabel *educationRequire;

@property (weak, nonatomic) IBOutlet UILabel *jobLocation;
@property (weak, nonatomic) IBOutlet UILabel *SalaryRange;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
