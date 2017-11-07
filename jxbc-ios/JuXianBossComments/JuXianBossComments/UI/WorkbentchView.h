//
//  workbentchView.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkbentchView : UIView

@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;
@property (weak, nonatomic) IBOutlet UIButton *threeBtn;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
//档案
@property (weak, nonatomic) IBOutlet UIImageView *recodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *youJiangImageView;


@property (weak, nonatomic) IBOutlet UIView *twoLineView;

//评价
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
//离任
@property (weak, nonatomic) IBOutlet UIImageView *liZhiImageView;
@property (weak, nonatomic) IBOutlet UILabel *liZhiLabel;

@property (weak, nonatomic) IBOutlet UIView *oneView;

@property (weak, nonatomic) IBOutlet UIView *twoView;

@property (weak, nonatomic) IBOutlet UIView *threeView;

@property (weak, nonatomic) IBOutlet UIView *lastLowView;

@property (weak, nonatomic) IBOutlet UILabel *unReadMassage;

@property (weak, nonatomic) IBOutlet UILabel *userUnRead;

//中间的View
@property (weak, nonatomic) IBOutlet UIImageView *tempImageView;

//消息的imageView
@property (weak, nonatomic) IBOutlet UIImageView *fixImageVIew;

//消息位置换后的未读消息个数
@property (weak, nonatomic) IBOutlet UILabel *fixUnreadMessage;

+ (instancetype)workbentchView;
@end
