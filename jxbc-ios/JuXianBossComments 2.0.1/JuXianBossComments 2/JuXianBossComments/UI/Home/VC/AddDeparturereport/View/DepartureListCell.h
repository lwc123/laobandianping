//
//  DepartureListCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

//离任列表
@interface DepartureListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;

@property (nonatomic,strong)ArchiveCommentEntity * archiveModel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
