//
//  BossDynamicPublicImgCellCollectionViewCell.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossDynamicPublicImgCell.h"

const static CGFloat kDeleteButtondiameter = 22.5;

@interface BossDynamicPublicImgCell ()

// 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) DeleteButtonClickBlock deleteButtonClickBlock;

@end

@implementation BossDynamicPublicImgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self.contentMode = UIViewContentModeBottomLeft;
        // self.contentView.contentMode = UIViewContentModeBottomLeft;
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    
    self.photoView.image = image;
    
    self.deleteButton.hidden = image ? NO : YES;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 用约束点击查看大图时会有问题
//    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.bottom.equalTo(self.contentView);
//        make.right.equalTo(self.contentView).offset(-10);
//        make.top.equalTo(self.contentView).offset(10);
//    }];
//    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.top.equalTo(self.contentView);
//        make.height.width.mas_equalTo(22.5);
//    }];
    self.photoView.frame = CGRectMake(0, kDeleteButtondiameter*0.5, self.width - kDeleteButtondiameter*0.5, self.height - kDeleteButtondiameter*0.5);
    
    self.deleteButton.frame = CGRectMake(self.width - kDeleteButtondiameter, 0, kDeleteButtondiameter, kDeleteButtondiameter);

}

// 删除按钮点击
- (void)deleteButtonClick{

    Log(@"点击了删除按钮");
    self.deleteButton.hidden = YES;
    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock();
    }
}

-(void)deleteButtonClickCompletion:(DeleteButtonClickBlock)deleteButtonClickBlock{
    _deleteButtonClickBlock = deleteButtonClickBlock;
}


#pragma mark - 控件
- (UIImageView *)photoView{
    
    if (_photoView == nil) {
        _photoView = [[UIImageView alloc] init];
        _photoView.autoresizesSubviews = YES;
        _photoView.userInteractionEnabled = NO;
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;

    }
    return _photoView;
    
}

- (UIButton *)deleteButton{

    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] init];
        _deleteButton.layer.cornerRadius = 10;
        _deleteButton.clipsToBounds = YES;
        [_deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
    
}


@end
