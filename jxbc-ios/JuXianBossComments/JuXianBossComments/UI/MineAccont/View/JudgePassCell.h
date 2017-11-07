//
//  JudgePassCell.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveCommentEntity.h"
@interface JudgePassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cheakBtn;
@property(nonatomic,strong)ArchiveCommentEntity *archiveModel;

@end
