//
//  CommentsContensCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#define JHTextFont [UIFont systemFontOfSize:12]


#import <UIKit/UIKit.h>
#import "TggStarEvaluationView.h"
//查询结果老板点评的结果
@interface CommentsContensCell : UITableViewCell
/**评价日期*/
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/**评价者*/
@property (weak, nonatomic) IBOutlet UILabel *bossLabel;
/**被评价者 职位*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**公司*/
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
/**工作能力 业绩 态度背景*/
@property (weak, nonatomic) IBOutlet UIView *bgView;

/**评语*/
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImagView;

/**cell的高度*/
@property (nonatomic,assign) CGFloat cellHeight;
@property (strong ,nonatomic) TggStarEvaluationView *tggStarEvaView;
@property (nonatomic,strong)NSArray * starArray;
@property (weak, nonatomic) IBOutlet UIView *allView;
//评价modelCGFloat yuYinH
@property (nonatomic,strong)BossCommentsEntity * bossModel;
@property (nonatomic,assign) CGFloat yuYinH;

+ (CGFloat)cellHeightWithModel:(BossCommentsEntity *)bossModel;


@end
