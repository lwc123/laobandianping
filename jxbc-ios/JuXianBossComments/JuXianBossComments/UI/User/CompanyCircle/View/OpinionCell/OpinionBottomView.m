//
//  OpinionBottomView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "OpinionBottomView.h"

#define LikedCountLabel_Width 40.0f


#define ListMargin 15

@implementation OpinionBottomView

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setUp];
    }
    return self;
}
- (void)setUp{

    _startDetailLabel = [[UILabel alloc] init];
    _startDetailLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _startDetailLabel.text = @"我是员工详情";
    _startDetailLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:_startDetailLabel];
    
    _LikedCountLabel = [[UILabel alloc] init];
    _LikedCountLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _LikedCountLabel.text = @"2222";
    _LikedCountLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_LikedCountLabel];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_likeBtn setImage:[UIImage imageNamed:@"wuzan"] forState:UIControlStateNormal];
    
    [self addSubview:_likeBtn];
    
    _readCount = [[UILabel alloc] init];
    _readCount.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _readCount.text = @"阅读 2222";
    _readCount.font = [UIFont systemFontOfSize:12];
    
    
    [self addSubview:_readCount];
}

#pragma mark -- 点赞
- (void)likeBtnClick:(UIButton *)button{
    
    
    MJWeakSelf
    [UserOpinionRequest postOpinionPraiseWithOpinionId:self.opinionModel.OpinionId success:^(BOOL result) {
        weakSelf.opinionModel.IsLiked = !weakSelf.opinionModel.IsLiked;
        if (weakSelf.opinionModel.IsLiked == YES) {
            weakSelf.opinionModel.LikedCount++;
        }else{
            weakSelf.opinionModel.LikedCount--;
        }
    } fail:^(NSError *error) {
        
    }];
    button.selected = !button.selected;
    
    int num = [self.LikedCountLabel.text intValue];
    
    if (button.selected) {
        
        self.LikedCountLabel.text = [NSString stringWithFormat:@"%d",num + 1];
        [button setImage:[UIImage imageNamed:@"ic_xjhgood"] forState:UIControlStateNormal];
        
    }else{
        self.LikedCountLabel.text = [NSString stringWithFormat:@"%d",num - 1];
        [button setImage:[UIImage imageNamed:@"wuzan"] forState:UIControlStateNormal];
    }
    
}


- (void)setOpinionModel:(OpinionEntity *)opinionModel{

    _opinionModel = opinionModel;
    _readCount.text = [NSString stringWithFormat:@"阅读 %ld",opinionModel.ReadCount];
    
    //员工
    _startDetailLabel.text = [NSString stringWithFormat:@"员工-%@年-%@",opinionModel.WorkingYears,opinionModel.Region];
    // 点赞按钮
    self.likeBtn.selected = opinionModel.IsLiked ? YES : NO;
    
    if (self.likeBtn.selected == NO) {
        [_likeBtn setImage:[UIImage imageNamed:@"wuzan"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"ic_xjhgood"] forState:UIControlStateNormal];
        
    }
    
    //点赞数
    if (opinionModel.LikedCount >= 1000) {
        _LikedCountLabel.text = @"999+";
    }else{
        _LikedCountLabel.text = [NSString stringWithFormat:@"%ld",opinionModel.LikedCount];
    }
    
    self.startDetailLabel.frame = CGRectMake(9.5, 10, 200, 11);
    
    self.LikedCountLabel.frame = CGRectMake(SCREEN_WIDTH - LikedCountLabel_Width - ListMargin, self.startDetailLabel.origin.y, LikedCountLabel_Width, 12);
    
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - self.LikedCountLabel.size.width - ListMargin - ListMargin - 5, self.startDetailLabel.origin.y - 2, ListMargin, ListMargin);
    
    self.readCount.frame = CGRectMake(self.likeBtn.origin.x - 20 - 80, self.startDetailLabel.origin.y, 80, 12);

    
    
    
}



@end
