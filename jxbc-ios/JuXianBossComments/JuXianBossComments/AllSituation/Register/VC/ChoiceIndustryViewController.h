//
//  ChoiceIndustryViewController.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/22.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
#import "JCTagListView.h"
typedef void(^saveBlock)(NSString * informationStr,NSString * cityCode);

//选择行业
@interface ChoiceIndustryViewController : JXBasedViewController
@property (nonatomic,strong)NSMutableArray *mutableArray;
@property (nonatomic, strong)JCTagListView *signView;
@property (nonatomic,copy)saveBlock block;
@property (nonatomic,copy)NSString * str;

@end
