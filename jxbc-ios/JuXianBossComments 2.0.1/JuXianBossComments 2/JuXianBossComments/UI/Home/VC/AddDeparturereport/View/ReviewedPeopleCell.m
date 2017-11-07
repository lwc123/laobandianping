
//
//  ReviewedPeopleCell.m
//  JuXianBossComments
//
//  Created by easemob on 2016/12/25.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ReviewedPeopleCell.h"

@implementation ReviewedPeopleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIButton * deletePeopleBtn = [[UIButton alloc]initWithFrame:CGRectMake(150, 0, 44, 44)];
        _deletePeopleBtn = deletePeopleBtn;
        [deletePeopleBtn setImage:[UIImage imageNamed:@"offjh"] forState:UIControlStateNormal];
        [deletePeopleBtn addTarget:self action:@selector(deletePeopleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deletePeopleBtn];
    }
    return self;
}

- (void)deletePeopleBtnClick:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(reviewedPeopleCell:deletePeopleBtnClick:)]) {
        [_delegate reviewedPeopleCell:self deletePeopleBtnClick:button];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
