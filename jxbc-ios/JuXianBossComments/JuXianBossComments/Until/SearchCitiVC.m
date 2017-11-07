//
//  SearchCitiVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SearchCitiVC.h"
#import "JXButton.h"
#import "SearchViewController.h"
#import "SeachView.h"
//城市model
#import "CityModel.h"


@interface SearchCitiVC ()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)SeachView * searchView;
@property (nonatomic,strong)NSArray * cityArray;
@property (nonatomic,strong)NSMutableArray * cityTemArray;

@property (nonatomic,strong)NSMutableArray * hotCityArray;
@property (nonatomic,strong)NSMutableArray * hotCityCodeArray;

@property (nonatomic,strong)NSMutableArray * noHotCityArray;


@end

@implementation SearchCitiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"保存"];
    [self initData];
    [self initRequestCity];
    
    
    
}

#pragma mark -- 获取城市业务字典
- (void)initRequestCity{
    
    [WebAPIClient getJSONWithUrl:API_Dictionary_City parameters:nil success:^(id result) {
        
        NSLog(@"%@",result);
        
        for (NSDictionary * modelDict in result[@"city"]) {
            
            CityModel *model = [[CityModel alloc]initWithDictionary:modelDict error:nil];
            if ([model.IsHotspot integerValue]) {
                [_hotCityArray addObject:model];
                [_hotCityCodeArray addObject:model.Code];
            }else{
                [_noHotCityArray addObject:model];
            }
        }
        [self initUI];
        //        _cityArray = _noHotCityArray;
        NSLog(@"_city Array===%@",_cityArray);
    } fail:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
    
    
}


- (void)initData{
    
    _cityArray = [NSArray  array];
    _cityTemArray = [NSMutableArray array];
    _hotCityArray = [NSMutableArray array];
    _noHotCityArray = [NSMutableArray array];
    _hotCityCodeArray = [NSMutableArray array];
}

- (void)initUI{
    
    _searchView = [SeachView seachView];
    _searchView.width = ScreenWidth;
    _searchView.placehoderText.placeholder = @" 请输入城市名称";
    _searchView.placehoderText.enabled = NO;
    _searchView.searchBtn.hidden = NO;
    _searchView.searchBtn.enabled = YES;
    [_searchView.searchBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchView];
    
    UILabel * cityLabel = [UILabel labelWithFrame:CGRectMake(7, CGRectGetMaxY(_searchView.frame) + 10, SCREEN_WIDTH, 15) title:@"热门城市" titleColor:[UIColor blackColor] fontSize:15.0 numberOfLines:1];
    [self.view addSubview:cityLabel];
    //      总列数
    int totalColumns = 3;
    //       每一格的尺寸
    CGFloat cellW = (SCREEN_WIDTH - 40) /3;
    CGFloat cellH = 35;
    //    间隙
    CGFloat margin = 10;
    //    根据格子个数创建对应的框框
    for(int index = 0; index< self.hotCityArray.count; index++) {
        
        UIButton *cellView = [[UIButton alloc ]init ];
        
        // 计算行号  和   列号
        int row = index / totalColumns;
        int col = index % totalColumns;
        //根据行号和列号来确定 子控件的坐标
        CGFloat cellX = margin + col * (cellW + margin);
        CGFloat cellY = row * (cellH + margin) + (CGRectGetMaxY(cityLabel.frame) + 8);
        cellView.frame = CGRectMake(cellX, cellY, cellW, cellH);
        cellView.layer.masksToBounds = YES;
        cellView.layer.cornerRadius = 4;
        cellView.layer.borderWidth = .5;
        cellView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        cellView.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
        [cellView setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        cellView.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        cellView.tag = 1000 + index;
        
        CityModel * model = self.hotCityArray[index];
        
        [cellView setTitle:model.Name forState:UIControlStateNormal];
        [cellView addTarget:self action:@selector(cellView:) forControlEvents:UIControlEventTouchUpInside];
        // 添加到view 中
        [self.view addSubview:cellView];
    }
    
}

- (void)cellView:(UIButton *)batn{
    
    NSString * str = batn.titleLabel.text;
    NSString * cityCode = _hotCityCodeArray[batn.tag - 1000];
    if (self.block) {
        self.block(str,cityCode);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    UIView *view = [self.view viewWithTag:2000];
    CGPoint xy = [gestureRecognizer locationInView:view];
    
    NSLog(@"x :%f",xy.y);
    if (xy.y>57) {
        return NO;
    }
    return YES;
}


#pragma  mark - 搜索按钮的点击事件
- (void)buttonAction:(UIButton*)button
{
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    searchVC.noHotCityArray = _noHotCityArray;
    searchVC.block = _cityBlock;
    searchVC.sencondVC = self.sencondVC;
    searchVC.hidesBottomBarWhenPushed = YES;
    [UIView animateWithDuration:.35 animations:^{
        [self.navigationController pushViewController:searchVC animated:YES];
    }];
}

- (void)rightButtonAction:(UIButton *)button{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
