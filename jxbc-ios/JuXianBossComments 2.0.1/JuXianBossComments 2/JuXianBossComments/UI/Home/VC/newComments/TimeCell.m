//
//  TimeCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/2/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "TimeCell.h"
#import "CellViewButton.h"

@implementation TimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)codeArray{
    
    if (!_codeArray) {
        _codeArray = [NSMutableArray array];
    }
    return _codeArray;
}

//SC.XJH.1.1
- (void)initSubviewsWithID:(NSString *)ID with:(NSMutableArray *)array{
    //取出阶段时间字典
    if ([ID isEqualToString:@"timeSelectID"]) {
        //取出阶段时间字典
        NSArray *PeriodModelA = [DictionaryRepository getComment_PeriodModelArray];
        
        for (PeriodModel *periodModel in PeriodModelA) {
            [self.dataArray addObject:periodModel.Name];
            [self.codeArray addObject:periodModel.Code];
        }
    }
    int totalColumns =  3;
    CGFloat cellW = 80;
    CGFloat cellH = 30;
    
    CGFloat margin =(self.frame.size.width - totalColumns * cellW) / (totalColumns + 1);
    for(int index = 0; index< self.dataArray.count; index++) {
        
        //SC.XJH.2.8
        CellViewButton *cellView = [[CellViewButton alloc ]init];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = 10 + col * (cellW + margin);
        CGFloat cellY = row * (cellH + 10) + 10;
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        cellView.layer.masksToBounds = YES;
        cellView.layer.cornerRadius = 4;
        cellView.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
        [cellView setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        cellView.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        cellView.tag = 100 + index;
        //打算将btn的tag 设置和code 有关的  XJHXX
//        cellView.tag = 100 + [self.codeArray[index] integerValue];
        //SC.XJH.2.8
        cellView.name = self.dataArray[index];
        cellView.code = self.codeArray[index];
        
        [cellView setTitle:self.dataArray[index] forState:UIControlStateNormal];
        [cellView addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        // 添加到view 中
        [self.bgView addSubview:cellView];
    }
    //总行数
    int count = (int)self.dataArray.count;
    int allRow = count / 3 + 1;
    self.cellHeight =allRow * (cellH + 10) + 10;
}

- (void)btnClick:(UIButton *)btn{
    
//    NSLog(@"我点击%ld",(long)_index);
    if (btn!= self.selectedBtn) {
        self.selectedBtn.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
        [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.selectedBtn.selected = NO;
        [self.selectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
        
        btn.selected = YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"timeButton"] forState:UIControlStateNormal];
        _index = (btn.tag - 100);
        NSLog(@"我点击%ld",(long)_index);
        
        if ([self.delegate respondsToSelector:@selector(timeCellClickTimeBtnWith:WithCode:WithIndexPath:andView:)]) {
            
            [self.delegate timeCellClickTimeBtnWith:_index WithCode:_codeArray[_index] WithIndexPath:self.indexPath andView:self];
        }
        self.selectedBtn = btn;
        
    }else{
        self.selectedBtn.selected = YES;
        _index = (self.selectedBtn.tag - 100);
        
    }
    
}

#pragma mark -- 阶段时间
- (void)setDetailComment:(ArchiveCommentEntity *)detailComment{
    _detailComment = detailComment;
    for (int i = 0; i < self.dataArray.count; ++i) {
        
        if ([self.dataArray[i] isEqualToString:detailComment.StageSectionText]) {
            for (UIView *view in self.bgView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)view;
                    if (btn.tag == 100+i) {
                        self.selectedBtn.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
                        [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        self.selectedBtn.selected = NO;
                        [self.selectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
                        
                        btn.selected = YES;
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"timeButton"] forState:UIControlStateNormal];
                        _index = (btn.tag - 100);
                        NSLog(@"我点击%ld",(long)_index);
                        //                        if ([self.delegate respondsToSelector:@selector(departureResonCellClickTimeBtnWith:WithIndexPath:andView:)]) {
                        //                            [self.delegate departureResonCellClickTimeBtnWith:_index WithIndexPath:self.indexPath andView:self];
                        //                        }
                        self.selectedBtn = btn;
                    }else{
                        
                    }
                }
            }
        }
    }
}

#pragma amrk -- 选择年
- (IBAction)choiceYearClcik:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(timeCellClickTchoiceYearBtnView:)]) {
        [self.delegate timeCellClickTchoiceYearBtnView:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
