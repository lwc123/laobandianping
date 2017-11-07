//
//  BossCircelCommentCell.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircelCommentCell.h"
#import "BossDynamicEntity.h"

@interface BossCircelCommentCell ()
// 姓名
//@property (nonatomic, strong) UILabel *nameLable;
// 评论
@property (nonatomic, strong) UILabel *commentLable;

@end

@implementation BossCircelCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;


        
    }
    return self;
}


#pragma mark - 赋值

- (void)setName:(NSString*) name andComment:(NSString*)comment{
    [self.contentView addSubview:self.commentLable];
    
    
    NSString* str = [name stringByAppendingString:@"："];
    str = [str stringByAppendingString:comment];
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [aAttributedString addAttribute:NSForegroundColorAttributeName  //文字颜色
                              value:ColorWithHex(KColor_GoldColor)
                              range:NSMakeRange(0, name.length + 1)];
    
    self.commentLable.attributedText = aAttributedString;
}


#pragma mark - 布局

- (void)layoutSubviews{
    [super layoutSubviews];
    // 名称
//    [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.equalTo(self.contentView);
//        make.height.mas_equalTo(20);
//
//    }];
    
    // 评论
    [self.commentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
//        make.left.equalTo(self.nameLable.mas_right);
    }];
    
}


#pragma mark - lazy load


- (UILabel *)commentLable{
    
    if (_commentLable == nil) {
        _commentLable = [[UILabel alloc] init];
        _commentLable.textColor = [UIColor blackColor];
        _commentLable.font = [UIFont systemFontOfSize:12];
        _commentLable.numberOfLines = 0;

    }
    return _commentLable;

}

@end
