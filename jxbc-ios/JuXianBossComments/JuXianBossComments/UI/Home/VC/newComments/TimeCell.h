//
//  TimeCell.h
//  JuXianBossComments
//
//  Created by juxian on 2017/2/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TimeCell;
@protocol TimeCellDelegate <NSObject>
@optional
- (void)timeCellClickTimeBtnWith:(NSInteger)index  WithCode:(NSString *)codeStr WithIndexPath:(NSIndexPath *)indexPath andView:(TimeCell *)resonCell;

- (void)timeCellClickTchoiceYearBtnView:(TimeCell *)resonCell;

@end

//阶段时间的cell
@interface TimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seachLabel;

@property (weak, nonatomic) IBOutlet UILabel *fuHaoLabel;
@property (weak, nonatomic) IBOutlet UIButton *choiceYearBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong) NSMutableArray * dataArray;//SC.XJH.1.1
@property (nonatomic,strong) NSMutableArray * codeArray;

@property (nonatomic,assign)CGFloat cellHeight;

@property (nonatomic,strong)UIButton * selectedBtn;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak) id<TimeCellDelegate> delegate;

@property (nonatomic,strong)ArchiveCommentEntity * detailComment;
- (void)initSubviewsWithID:(NSString *)ID with:(NSMutableArray *)array;

@end
