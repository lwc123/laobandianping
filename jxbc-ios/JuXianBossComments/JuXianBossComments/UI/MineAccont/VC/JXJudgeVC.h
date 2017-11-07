//
//  JXJudgeVC.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/14.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTableView.h"
//我的评价
@interface JXJudgeVC : JXBasedViewController

@property (nonatomic,copy)NSString * nameStr;
@property(nonatomic,strong)JXTableView *jxTableView;

@end
