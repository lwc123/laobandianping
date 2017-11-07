//
//  JudgeCheckingCell.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveCommentEntity.h"

@protocol JudgeCheckingCellDelegate <NSObject>

-(void)CheckingCellWith:(NSInteger)num;

@end


@interface JudgeCheckingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *cheakingClickBtn;

@property(nonatomic,strong)ArchiveCommentEntity *archiveModel;

@property(nonatomic,weak)id <JudgeCheckingCellDelegate>delegate;
@end
