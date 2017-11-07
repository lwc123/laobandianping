//
//  AttentionCell.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpinionCompanyEntity.h"

@interface AttentionCell : UITableViewCell

@property (nonatomic, strong) OpinionCompanyEntity *companyEntity;
@property (nonatomic, assign) NSInteger tagCellHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@end
