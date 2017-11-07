//
//  SearchViewController.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBasedViewController.h"
#import "HotSearchViewCell.h"

typedef void(^cityBlock)(CityModel * city);

@interface SearchViewController : JXBasedViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)  UITableView *tableview;
//@property (nonatomic,strong)SearchResultVC *resultVC;
//用于存放搜索过的数据
@property (nonatomic,strong)NSArray * hisData;
@property (nonatomic,strong)NSMutableArray * noHotCityArray;
@property (nonatomic,copy)cityBlock block;
@property (nonatomic, strong)UIViewController *sencondVC;

@end
