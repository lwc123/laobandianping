//
//  NoStaffView.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoStaffView : UIView

+ (instancetype)noStaffView;

//在职
@property (weak, nonatomic) IBOutlet UIButton *zaiZhiBtn;
//离任
@property (weak, nonatomic) IBOutlet UIButton *liZhiBtn;
@property (weak, nonatomic) IBOutlet UIView *zaiZhiView;
@property (weak, nonatomic) IBOutlet UIView *departureView;

@end
