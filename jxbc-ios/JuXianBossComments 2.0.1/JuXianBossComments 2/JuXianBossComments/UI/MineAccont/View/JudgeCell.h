//
//  JudgeCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define JHTextFont [UIFont systemFontOfSize:12]

@class JudgeCell;
@protocol judgeCellDelegate <NSObject>

- (void)judgeCellDelegateWithCheckBtn:(NSIndexPath *)indexPath WithCell:(JudgeCell *)judgeCell;

@end

//我的评价
@interface JudgeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//审核通过 不通过 未通过
@property (weak, nonatomic) IBOutlet UILabel *autionStatusLabel;

//查看btn
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
//退回原因
@property (weak, nonatomic) IBOutlet UILabel *resonLabel;
@property(nonatomic,strong)ArchiveCommentEntity *archiveModel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)CGFloat itemHeight;
@property(nonatomic,weak)id <judgeCellDelegate>delegate;
@property(nonatomic,strong)CompanyMembeEntity *myAccount;

@end
