//
//  ArchiveListCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmployeArchiveEntity.h"

@interface ArchiveListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (nonatomic,strong)EmployeArchiveEntity * myArchives;
@end
