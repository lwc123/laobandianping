//
//  SearchViewController.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/15.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "SearchViewController.h"
#import "HotSearchViewCell.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "UIButton+Extension.h"
#import "JXTableView.h"
#import "NDSearchTool.h"
#import "CityModel.h"
#import "ProveOneViewController.h"
#import "FixCompanyVC.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)JXTableView * myTableView;
@property (nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic, strong) NSMutableArray *searchDataSource;
@property (nonatomic, strong) UISearchBar *searchBar;

// 1.3.2
@property (nonatomic,strong)NSMutableArray * hotCityArray;
@property (nonatomic,strong)NSMutableArray * hotCityCodeArray;

@property (nonatomic,strong)NSArray * cityArray;
@property (nonatomic,strong)NSMutableArray * cityTemArray;

@property (nonatomic, strong) NSMutableDictionary *citys;
@property (nonatomic, strong) NSMutableArray *letterArray;
@property (nonatomic, strong) UIView *hotCityView;

@property (nonatomic, strong) UILabel *letterView;

@end

@implementation SearchViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        //        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCellHeight:) name:@"HOTCELL1" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"城市搜索";
    [self isShowLeftButton:YES];
    
    [self initUI];
    [self initData];
    [self initRequestCity];
}

- (void)initUI{
    
    [self.view addSubview:_searchBar];
    _myTableView = [[JXTableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    
    //    _myTableView.tableHeaderView = _searchBar;
    
}

- (void)initData{
    
    _cityArray = [NSArray  array];
    _cityTemArray = [NSMutableArray array];
    _hotCityArray = [NSMutableArray array];
    _noHotCityArray = [NSMutableArray array];
    _hotCityCodeArray = [NSMutableArray array];
    _citys = @{}.mutableCopy;
    _letterArray = @[].mutableCopy;
}

#pragma mark -- 获取城市业务字典
- (void)initRequestCity{
    [self showLoadingIndicator];
    MJWeakSelf
    [WebAPIClient getJSONWithUrl:API_Dictionary_City parameters:nil success:^(id result) {
        [self dismissLoadingIndicator];
        Log(@"%@",result);
        for (NSDictionary * modelDict in result[@"city"]) {
            
            CityModel *model = [[CityModel alloc]initWithDictionary:modelDict error:nil];
            if ([model.IsHotspot integerValue]) {
                [_hotCityArray addObject:model];
                [_hotCityCodeArray addObject:model.Code];
            }
            NSString* letter = [weakSelf transformMandarinToLatin:model.Name];
            
            if ([weakSelf.letterArray containsObject:letter]) {
                NSMutableArray* arr = weakSelf.citys[letter];
                [arr addObject:model];
                
            }else{
                NSMutableArray* arr = @[].mutableCopy;
                [arr addObject:model];
                [weakSelf.citys setObject:arr forKey:letter];
                [weakSelf.letterArray addObject:letter];
            }
            NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];//yes升序排列，no,降序排列
            weakSelf.letterArray = [weakSelf.letterArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]].mutableCopy;
            [_noHotCityArray addObject:model];
            
        }
        weakSelf.myTableView.tableHeaderView = weakSelf.hotCityView;
        weakSelf.myTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        
        [weakSelf.myTableView reloadData];
        //        _cityArray = _noHotCityArray;
        Log(@"_city Array===%@",_cityArray);
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        Log(@"%@",error);
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.myTableView == tableView) {
        return self.letterArray.count;
    }else{
    
        return 1;
    }
//    return self.letterArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString* letter = self.letterArray[section];
    NSMutableArray* arr = self.citys[letter];
    if (self.myTableView == tableView) {
//        return self.noHotCityArray.count;
        return arr.count;
    }
    return self.searchDataSource.count;
    
//    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cityCellID = @"cityId";
    UITableViewCell * cityCell = [tableView dequeueReusableCellWithIdentifier:cityCellID];
    if (!cityCell) {
        cityCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCellID];
        cityCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
        cityCell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    CityModel * model;
 
    
        if (self.myTableView == tableView) {
            NSString * letter = self.letterArray[indexPath.section];
            NSMutableArray* arr = self.citys[letter];
            model = arr[indexPath.row];
//            model = self.noHotCityArray[indexPath.row];
        } else {
            model = self.searchDataSource[indexPath.row];
        }
    
    cityCell.textLabel.text = [NSString stringWithFormat:@"%@",model.Name];
    cityCell.detailTextLabel.text = [NSString stringWithFormat:@"%@",model.Code];
    
    return cityCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CityModel * model;

    if (self.myTableView == tableView) {
        NSString* letter = self.letterArray[indexPath.section];
        NSMutableArray* arr = self.citys[letter];
        model = arr[indexPath.row];
//            model = self.noHotCityArray[indexPath.row];
    } else {

        model = self.searchDataSource[indexPath.row];
    }
    
    if (self.block) {
        self.block(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 索引栏
//显示每组标题索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.letterArray;
}

//返回每个索引的内容

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.letterArray[section];
}

//响应点击索引时的委托方法

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    [self.letterView removeFromSuperview];
    self.letterView = nil;;
    self.letterView.text = title;
    [self showLetterView];
    // 显示预览View
    return [self.letterArray indexOfObject:title];
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    self.searchDataSource = (NSMutableArray *)[[NDSearchTool tool] searchWithFieldArray:@[@"Name",@"Code"]
                                                                            inputString:searchText
                                                                                inArray:self.noHotCityArray];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (UISearchDisplayController *)searchDisplayController
{
    if (_searchDisplayController) {
        return _searchDisplayController;
    }
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    _searchDisplayController.searchResultsTableView.dataSource = self;
    _searchDisplayController.searchResultsTableView.delegate = self;
    _searchDisplayController.searchBar.tintColor = [PublicUseMethod setColor:KColor_RedColor];
    return _searchDisplayController;
}

- (UISearchBar *)searchBar
{
    if (_searchBar) {
        return _searchBar;
    }
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    _searchBar.placeholder = @"请输入城市名称";
    _searchBar.delegate = self;
    
    return _searchBar;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
        }
    }
}

- (UIView *)hotCityView{
    
    if (_hotCityView == nil) {
        _hotCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,(self.hotCityArray.count/3 + 1) *  (35 + 10)  + 30)];
        
        //        _hotCityView.backgroundColor = [UIColor cyanColor];
        UILabel * cityLabel = [UILabel labelWithFrame:CGRectMake(7, 10, SCREEN_WIDTH, 15) title:@"热门城市" titleColor:[UIColor blackColor] fontSize:15.0 numberOfLines:1];
        [_hotCityView addSubview:cityLabel];
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
            [cellView addTarget:self action:@selector(hotCityCilck:) forControlEvents:UIControlEventTouchUpInside];
            // 添加到view 中
            [_hotCityView addSubview:cellView];
        }
        
    }
    return _hotCityView;
}

#pragma mark - 热门城市按钮点击
- (void)hotCityCilck:(UIButton *)batn{
    if (self.block) {
        self.block(self.hotCityArray[batn.tag - 1000]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 汉子转拼音
- (NSString *)transformMandarinToLatin:(NSString *)string
{
    /*复制出一个可变的对象*/
    NSMutableString *preString = [string mutableCopy];
    /*转换成成带音 调的拼音*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformMandarinLatin, NO);
    /*去掉音调*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformStripDiacritics, NO);
    preString = [preString capitalizedString].mutableCopy;
    /*多音字处理*/
    if ([[(NSString *)string substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"Chang"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"Shen"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"厦"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"Xia"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"地"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"Di"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"重"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"Chong"];
    }
    // 返回首字母
    return [preString substringToIndex:1];
}

- (UILabel *)letterView{
    
    if (_letterView == nil) {
        _letterView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _letterView.center = CGPointMake(ScreenWidth/2, (ScreenHeight - 64) /2);
        _letterView.layer.cornerRadius = 5;
        _letterView.clipsToBounds = YES;
        _letterView.font = [UIFont systemFontOfSize:30];
        _letterView.textAlignment = NSTextAlignmentCenter;
        _letterView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.8];
        //        _letterView.hidden = YES;
        [self.view addSubview:_letterView];
        [self.view bringSubviewToFront:_letterView];
    }
    return _letterView;
}


- (void)showLetterView{
    
    self.letterView.hidden = NO;
    
    MJWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.letterView.hidden = YES;
    });
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
