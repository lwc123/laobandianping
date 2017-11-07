//
//  BossCircleDynamicCellTableViewCell.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BossDynamicEntity;
@class BossDynamicCommentEntity;
// 删除
typedef void(^DeleteButtonClickBlock)(BossDynamicEntity *);
// 评论
typedef void(^CommentButtonClickBlock)(BossDynamicCommentEntity *);


@interface BossCircleDynamicCell : UITableViewCell

// 老版圈状态模型
@property (nonatomic, strong) BossDynamicEntity *dynamic;
// indexpath
@property (nonatomic, strong) NSIndexPath *indexPath;
// 是否显示boosName
@property (nonatomic, assign) BOOL bossNameHidden;

// 行高
+ (CGFloat)calculateCellHeightWithDynamic:(BossDynamicEntity *)dynamic;

// 删除按钮点击block
- (void)deleteButtonClickCompletion:(DeleteButtonClickBlock) deleteButtonClickBlock;

// 评论按钮点击block
- (void)commentButtonClickCompletion:(CommentButtonClickBlock) CommentButtonClickBlock;

@end
