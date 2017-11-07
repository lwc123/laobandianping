//
//  JudgeBackCell.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArchiveCommentEntity.h"

#define JHTextFont [UIFont systemFontOfSize:12]

@interface JudgeBackCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *subAgain;
@property(nonatomic,strong)ArchiveCommentEntity *archiveModel;
@property (nonatomic,assign)CGFloat itemHeight;

//审核人姓名
@property (weak, nonatomic) IBOutlet UILabel *shenheLabel;

@end
