//
//  RecodeCheckVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "RecodeCheckVC.h"
#import "SeachRecodeListVC.h"

@interface RecodeCheckVC ()<UISearchBarDelegate,UITextFieldDelegate>{

    NSArray *hotSearch_array;
    UITextField * _searchTf;
    UISearchBar *_searchBar;
    NSMutableArray *_hisTmpArray;

}
@property (nonatomic,strong)SeachView * searchView;
@property (nonatomic,strong)UIButton * delegateBtn;


@end


static NSString *myKeyCell = @"keyCellID";

@implementation RecodeCheckVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询员工";
    [self isShowLeftButton:YES];
    [self initUI];
}

- (void)initUI{
        
    _searchView = [SeachView seachView];
    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    _searchView.searchBtn.hidden = YES;
    _searchView.placehoderText.placeholder = @"请输入员工姓名";
    _searchView.placehoderText.delegate = self;
    _searchView.placehoderText.clearsOnInsertion = YES;
    _searchView.placehoderText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchView.placehoderText becomeFirstResponder];
    _searchView.placehoderText.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_searchView];
  
    
    
//    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 10 - 25 - 10) style:UITableViewStylePlain];
//    _tableview.scrollEnabled = YES;
//    _tableview.delegate = self;
//    _tableview.dataSource = self;
//    self.tableview.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
//    
//    [_tableview registerClass:[HotSearchViewCell class] forCellReuseIdentifier:myKeyCell];
//    [self.view addSubview:_tableview];
//    
//    
//    
//    if([_tableview respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)])
//    {
//        _tableview.cellLayoutMarginsFollowReadableWidth = NO;
//    }
//    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
//        [_tableview setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
//        [_tableview setSeparatorInset:UIEdgeInsetsZero];
//    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (_searchView.placehoderText.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }
    
    SeachRecodeListVC * resultVC = [[SeachRecodeListVC alloc] init];
    resultVC.secondVC = _secondVC;
    resultVC.realName = _searchView.placehoderText.text;
    [self.navigationController pushViewController:resultVC animated:YES];
    return YES;
}
//
//#pragma mark - UITableViewDatasource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section==0)
//    {
//        return 1;
//    }else if (section==1)
//    {
//        return _hisData.count+2;//.row取数据要减一 OK
//    }
//    //    return 1;XJH 8.19
//    return 0;
//    
//    
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        
//        HotSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myKeyCell];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        //        if (!cell)
//        //        {
//        
//        //            cell = [[HotSearchViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        
//        //           NSArray *array = @[@"职业规划",@"产品经理",@"UI设计",@"阿里妈妈",@"产品经理",@"设计",@"产品经理经理",@"陈国家",@"职业规划",@"产品经理",@"UI设计",@"阿里妈妈",@"产品经理",@"设计",@"产品经理经理",@"陈国家"];
//        //            [cell.hotSearchView setCompletionBlockWithSelected:^(NSInteger index) {
//        //                if (hotSearch_array.count!=0) {
//        //
//        //                    _searchBar.text = hotSearch_array[index];
//        //
//        //                    [searchField resignFirstResponder];
//        //
//        //                    _resultVC.keyWord = _searchBar.text;
//        //                    [self addHistoryRecordWith:_searchBar];
//        //
//        //                    _tableview.hidden = YES;
//        //                    [_resultVC.collectionView.mj_header beginRefreshing];
//        //
//        //                }
//        //
//        //            }];
//        
//        //        }
//        cell.block = ^(NSInteger index){
//            if (hotSearch_array.count!=0) {
//                
//                _searchBar.text = hotSearch_array[index];
//                
//                [_searchTf resignFirstResponder];
//                
//#warning 暂时没有这个控制器
////                _resultVC.keyWord = _searchBar.text;
//                [self addHistoryRecordWith:_searchBar];
//                
//                _tableview.hidden = YES;
////                [_resultVC.collectionView.mj_header beginRefreshing];
//                
//            }
//            
//            
//        };
//        cell.array = hotSearch_array;
//        
//        return cell;
//    }
//    else if(indexPath.section==1)
//    {
//        //最前面一个
//        if (indexPath.row == 0) {
//            static NSString *identifier = @"lineID";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            return cell;
//        }
//        //最后面一个
//        if (indexPath.row ==_hisData.count+1) {
//            static NSString *identifier = @"lineid";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            
//            return cell;
//        }
//        else
//        {
//            static NSString *identifier = @"cellid";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40, 0, 41, 41)];
//                [button addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//                [button setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
//                button.tag = indexPath.row;
//                
//                //8.24 2.0版  隐藏
//                //            [cell.contentView addSubview:button];
//                cell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
//                
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
//            }
//            
//            cell.textLabel.text = _hisData[indexPath.row-1];
//            
//            
//            return cell;
//        }
//    }
//    else//第三组
//    {
//        static NSString *identifier = @"lineID1";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        
//        if (!cell) {
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        return cell;
//        //return nil;
//    }
//    
//    
//}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0)
//    {
//        
//        HotSearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myKeyCell];
//        cell.array = hotSearch_array;
//        return cell.height;
//    }
//    else if (indexPath.section==1)
//    {
//        if (indexPath.row==0||indexPath.row==_hisData.count+1)
//        {
//            return .3;
//        }
//        else
//        {
//            return 41;
//        }
//    }
//    else
//    {
//        return 0;
//    }
//    
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return 30;
//    }
//    return 0;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return 30;
//    }
//    return 0;
//}
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    HeardFooterView *heardFooterView = [[HeardFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//    heardFooterView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
//    heardFooterView.titleLabel.textColor = [UIColor grayColor];
//    
//    if (section==0) {
//
//        return nil;
//        
//    }else if (section==1)
//    {
//        heardFooterView.titleLabel.text = @"搜索历史";
//        return heardFooterView;
//    }
//    else
//    {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//        view.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
//        return view;
//    }
//    
//}
//- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section==1) {
//        
//        if (_hisData.count == 0) {
//            self.tableview.hidden = YES;
//            return [[UIView alloc] init];
//        }
//        
//        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        bgView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
//        bgView.userInteractionEnabled = YES;
//        
//        UIButton * removeAllBtn = [UIButton buttonWithFrame:CGRectMake((SCREEN_WIDTH/2-53), 11, 106, 30) title:@"清除搜索记录" fontSize:14 titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] imageName:nil bgImageName:nil];
//        removeAllBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        removeAllBtn.layer.cornerRadius = 15;
//        removeAllBtn.layer.masksToBounds = YES;
//        removeAllBtn.layer.borderWidth = 1.0;
//        removeAllBtn.layer.borderColor = [PublicUseMethod setColor:KColor_SubColor].CGColor;
//        [bgView addSubview:removeAllBtn];
//        [removeAllBtn addTarget:self action:@selector(removeAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        //        [_tableview reloadData];
//        
//        return bgView;
//        
//    }
//    else if(section==2)//XJH 8.19
//    {
//        return nil;
//    }
//    else
//    {
//        return nil;
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [_searchBar resignFirstResponder];
}

//#pragma mark- UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_searchBar resignFirstResponder];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    
//    if (indexPath.section == 1) {
//        
//        _searchBar.text = _hisData[indexPath.row-1];
//        [self addHistoryRecordWith:_searchBar];
//#warning 暂时没有这个控制器
////        _resultVC.keyWord = _searchBar.text;
//        _tableview.hidden = YES;
////        [_resultVC.collectionView.mj_header beginRefreshing];
//    }
//}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    if (searchText.length ==0) {
        _tableview.hidden = NO;
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    searchBar.barTintColor = [UIColor purpleColor];
    [_searchTf resignFirstResponder];
    //插入数据
    [self addHistoryRecordWith:searchBar];
    //执行跳转
//    _resultVC.keyWord = searchBar.text;
    searchBar.text = [searchBar.text stringByTrimmingCharactersInSet:    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (searchBar.text.length > 0&& searchBar.text.length<=30) {
        _tableview.hidden = YES;
//        [_resultVC.collectionView.mj_header beginRefreshing];
    }
    if (searchBar.text.length ==0) {
        [PublicUseMethod showAlertView:@"搜索不能为空"];
    }
    if (searchBar.text.length > 30) {
        [PublicUseMethod showAlertView:@"搜索字符不能超过30"];
    }
}

//历史数据添加
- (void)addHistoryRecordWith:(UISearchBar*)searchBar
{
    
    //1.添加进来
    if (searchBar.text.length > 0&&searchBar.text.length<=30)
    {
        if (self.hisData.count<=10&&self.hisData>=0)
        {
            if (self.hisData.count == 10)
            {
                //历史数据不得大于10
                //有相等的
                if ([self.hisData containsObject:searchBar.text])
                {
                    [_hisTmpArray removeObject:searchBar.text];
                    [self insertHistoryRecordWith:searchBar];
                }else
                {
                    [_hisTmpArray removeLastObject];
                    [self insertHistoryRecordWith:searchBar];
                }
                
            }else
            {//0~10
                if ([self.hisData containsObject:searchBar.text])
                {
                    [_hisTmpArray removeObject:searchBar.text];
                    [self insertHistoryRecordWith:searchBar];
                }else
                {
                    [self insertHistoryRecordWith:searchBar];
                }
            }
            
        }
    }
    
    else
    {
        //输入的字符不合法
    }
    
}

//历史记录的插入
- (void)insertHistoryRecordWith:(UISearchBar*)searchBar
{
    [_hisTmpArray insertObject:searchBar.text atIndex:0];
    NSLog(@"插入%@",_hisTmpArray);
    self.hisData = _hisTmpArray;
    //保存数据到本地沙盒
    [self saveHisDataToDocuments];
    [self.tableview reloadData];
}
//保存数据到本地沙盒
- (void)saveHisDataToDocuments
{
    //本地路径
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [document stringByAppendingPathComponent:@"hisData.archive"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //多线程 异步保存
        if ([NSKeyedArchiver archiveRootObject:_hisData toFile:filePath]) {
            NSLog(@"数据保存成功");
        }
    });
    
}

- (void)removeAllBtnClick:(UIButton *)btn{
    
    [self deleteAllHistoryRecord];
    NSLog(@"12312312333");
    
}
//历史记录的全部删除
- (void)deleteAllHistoryRecord;
{
    if (!_hisTmpArray) {
        return;
    }
    [_hisTmpArray removeAllObjects];
    _hisData = _hisTmpArray;
    //保存到本地沙盒
    [self saveHisDataToDocuments];
    [self.tableview reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
