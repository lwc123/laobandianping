//
//  DepartureResonCell.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"

@class DepartureResonCell;
@protocol DepartureResonCellDelegate <NSObject>
@optional
- (void)departureResonCellClickTimeBtnWith:(NSInteger)index  WithCode:(NSString *)codeStr WithIndexPath:(NSIndexPath *)indexPath andView:(DepartureResonCell *)resonCell;
//选择年
- (void)departureResonCellClickTchoiceYearBtnView:(DepartureResonCell *)resonCell;


@end
//原因补充下面包括上边距是169高  这个部分可以是死的
//离任原因
@interface DepartureResonCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (nonatomic,strong)UIButton * selectedBtn;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,weak) id<DepartureResonCellDelegate> delegate;
@property (nonatomic,strong) NSMutableArray * dataArray;//SC.XJH.1.1
@property (nonatomic,strong) NSMutableArray * codeArray;
@property (nonatomic,assign)CGFloat cellHeight;

//返聘意愿数组
@property (nonatomic,strong)NSArray * fanpinArray;

@property (weak, nonatomic) IBOutlet UILabel *resonLabel;
@property (weak, nonatomic) IBOutlet UILabel *seachLabel;
@property (weak, nonatomic) IBOutlet UIButton *choiceYearBtn;
@property (weak, nonatomic) IBOutlet UILabel *fuHaoLabel;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)ArchiveCommentEntity * detailComment;
//离任原因
@property (nonatomic,strong)ArchiveCommentEntity * lirenComment;

//返聘
@property (nonatomic,strong)ArchiveCommentEntity * pinComment;
- (void)initSubviewsWithID:(NSString *)ID with:(NSMutableArray *)array;
@end
