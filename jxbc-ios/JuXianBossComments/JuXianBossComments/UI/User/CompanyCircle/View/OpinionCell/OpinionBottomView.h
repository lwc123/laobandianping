//
//  OpinionBottomView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpinionBottomView : UIView

//员工详情
@property (nonatomic, strong) UILabel * startDetailLabel;
//点赞数
@property (nonatomic, strong) UILabel * LikedCountLabel;
//点赞按钮
@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UILabel * readCount;

@property (nonatomic, strong) OpinionEntity * opinionModel;

@end
