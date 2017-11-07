//
//  DepartureResonCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "DepartureResonCell.h"
#import "DictionaryRepository.h"

@implementation DepartureResonCell
//SC.XJH.1.1
- (void)awakeFromNib {
    [super awakeFromNib];
    
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
    if ([ID isEqualToString:@"timeSelectID"]) {
        //取出阶段时间字典
        NSArray *PeriodModelA = [DictionaryRepository getComment_PeriodModelArray];
        
        for (PeriodModel *periodModel in PeriodModelA) {
            [self.dataArray addObject:periodModel.Name];
            [self.codeArray addObject:periodModel.Code];
        }
    }else if ([ID isEqualToString:@"departureResonCell"]){
        //取出离任原因字典
        NSArray *leavingModelA = [DictionaryRepository getComment_LeavingModelArray];
        
        for (AcademicModel *leavingModel in leavingModelA) {
            [self.dataArray addObject:leavingModel.Name];
            [self.codeArray addObject:leavingModel.Code];
        }
    }else if ([ID isEqualToString:@"departureResonCellLiZhi"]){
        //取出返聘意愿字典
        NSArray *panickedModelA = [DictionaryRepository getComment_PanickedModelArray];        
        for (AcademicModel *panickedModel in panickedModelA) {
            [self.dataArray addObject:panickedModel.Name];
            [self.codeArray addObject:panickedModel.Code];

        }
    }
    int totalColumns =  3;
    CGFloat cellW = 80;
    CGFloat cellH = 30;

    CGFloat margin =(self.frame.size.width - totalColumns * cellW) / (totalColumns + 1);
    for(int index = 0; index< self.dataArray.count; index++) {
        
        UIButton *cellView = [[UIButton alloc ]init ];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat cellX = 15 + col * (cellW + margin);
        CGFloat cellY = row * (cellH + 10) + 10;
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        cellView.layer.masksToBounds = YES;
        cellView.layer.cornerRadius = 4;
        cellView.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
        [cellView setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        cellView.titleLabel.font = [UIFont systemFontOfSize:13.0];
        cellView.tag = 100 + index;
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
    
    NSLog(@"我点击%ld",(long)_index);
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
        
        if ([self.delegate respondsToSelector:@selector(departureResonCellClickTimeBtnWith:WithCode:WithIndexPath:andView:)]) {
            [self.delegate departureResonCellClickTimeBtnWith:_index WithCode:_codeArray[_index] WithIndexPath:self.indexPath andView:self];
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


- (void)setLirenComment:(ArchiveCommentEntity *)lirenComment{
    
    _lirenComment = lirenComment;    
    for (int i = 0; i < self.dataArray.count; ++i) {
        
        if ([self.dataArray[i] isEqualToString:lirenComment.DimissionReasonText]) {
            for (UIView *view in self.bgView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)view;
                    if (btn.tag == 100+i) {
                        self.selectedBtn.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
                        [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        self.selectedBtn.selected = NO;
                        [self.selectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
                        
                        btn.selected = YES;
                        btn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"timeButton"] forState:UIControlStateNormal];
                        //        btn.layer.borderColor = [PublicUseMethod setColor:KColor_MainColor].CGColor;
                        _index = (btn.tag - 100);
                        NSLog(@"我点击%ld",(long)_index);
                        self.selectedBtn = btn;
                    }else{
                        
                    }
                }
            }
        }
    }
    
}

//返聘
- (void)setPinComment:(ArchiveCommentEntity *)pinComment{
    
    _pinComment = pinComment;

    for (int i = 0; i < self.dataArray.count; ++i) {
        
        if ([self.dataArray[i] isEqualToString:pinComment.WantRecallText]) {
            for (UIView *view in self.bgView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)view;
                    if (btn.tag == 100+i) {
                        self.selectedBtn.backgroundColor = [PublicUseMethod setColor:@"F6F3EB"];
                        [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        self.selectedBtn.selected = NO;
                        [self.selectedBtn setBackgroundImage:nil forState:UIControlStateNormal];
                        
                        btn.selected = YES;
                        btn.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"timeButton"] forState:UIControlStateNormal];
                        _index = (btn.tag - 100);
                        NSLog(@"我点击%ld",(long)_index);
                        
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
    
    if ([self.delegate respondsToSelector:@selector(departureResonCellClickTchoiceYearBtnView:)]) {
        
        [self.delegate departureResonCellClickTchoiceYearBtnView:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
