//
//  BossCircleDynamicCellTableViewCell.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircleDynamicCell.h"
#import "BossCircleDynamicView.h"
#import "BossCircleCommentView.h"

@interface BossCircleDynamicCell ()

// 内容
@property (nonatomic, strong) BossCircleDynamicView *dynamicView;

// 评论
@property (nonatomic, strong) BossCircleCommentView *commentView;

// 删除按钮点击block
@property (nonatomic, copy) DeleteButtonClickBlock deleteButtonClickBlock;


@end


@implementation BossCircleDynamicCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.dynamicView];
    
}


#pragma mark - 布局

-(void)layoutSubviews{
    [super layoutSubviews];
//    self.dynamicView.frame = self.contentView.frame;
    
    [self.dynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

- (void)setBossNameHidden:(BOOL)bossNameHidden{

    _bossNameHidden = bossNameHidden;
    
    self.dynamicView.bossNameHidden = bossNameHidden;
}

#pragma mark - 赋值

- (void)setDynamic:(BossDynamicEntity *)dynamic{

    if (!dynamic) {
        return;
    }
    _dynamic = dynamic;
    self.dynamicView.dynamic = dynamic;
    
}

#pragma mark -  计算行高
+ (CGFloat)calculateCellHeightWithDynamic:(BossDynamicEntity *)dynamic{
    
    return [BossCircleDynamicView calculateCellHeightWithDynamic:dynamic];
}


#pragma mark - block

// 删除动态
- (void)deleteButtonClickCompletion:(DeleteButtonClickBlock)deleteButtonClickBlock{

    self.dynamicView.deleteButtonClickBlock = deleteButtonClickBlock;
    
}
// 评论动态
- (void)commentButtonClickCompletion:(CommentButtonClickBlock)CommentButtonClickBlock{
    self.dynamicView.commentButtonClickBlock = CommentButtonClickBlock;
}

#pragma mark - layz Load

-(BossCircleDynamicView *)dynamicView{
    
    if (!_dynamicView) {
        _dynamicView = [[BossCircleDynamicView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        [self.contentView addSubview:_dynamicView];
    }
    return _dynamicView;
}

@end


