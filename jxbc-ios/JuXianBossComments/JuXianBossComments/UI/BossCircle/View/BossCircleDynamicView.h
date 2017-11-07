//
//  BossCircleDynamicView.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SETextView.h"

@class BossDynamicEntity;
@class BossDynamicCommentEntity;

typedef void(^DeleteButtonClickBlock)(BossDynamicEntity *);

typedef void(^CommentButtonClickBlock)(BossDynamicCommentEntity *);


@interface BossCircleDynamicView : UIView

@property (nonatomic, strong) BossDynamicEntity *dynamic;

// 富文本属性
@property (nonatomic, strong) NSFont *font;
@property (nonatomic, strong) NSColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, strong) SETextView *richTextView;

@property (nonatomic, assign) BOOL deleteBtnHidden;

// 评论按钮点击
@property (nonatomic, copy) CommentButtonClickBlock commentButtonClickBlock;
// 删除按钮点击
@property (nonatomic, copy) DeleteButtonClickBlock deleteButtonClickBlock;

// 是否显示boosName
@property (nonatomic, assign) BOOL  bossNameHidden;

+ (CGFloat)calculateCellHeightWithDynamic:(BossDynamicEntity *)dynamic;
@end
