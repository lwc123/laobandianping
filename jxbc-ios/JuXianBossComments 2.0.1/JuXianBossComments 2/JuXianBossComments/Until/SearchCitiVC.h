//
//  SearchCitiVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
#import "JCTagListView.h"
//JXCollectionViewController
typedef void(^saveBlock)(NSString * informationStr,NSString * cityCode);
typedef void(^cityBlock)(CityModel * city);

//选择城市
@interface SearchCitiVC : JXBasedViewController

@property (nonatomic, strong)JCTagListView *signView;
@property (nonatomic,copy)saveBlock block;
@property (nonatomic,copy)NSString * str;
@property (nonatomic,copy)cityBlock cityBlock;
@property (nonatomic, strong)UIViewController *sencondVC;



@end
