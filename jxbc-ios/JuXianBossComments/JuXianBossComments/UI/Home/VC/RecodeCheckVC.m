//
//  RecodeCheckVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "RecodeCheckVC.h"
#import "SeachRecodeListVC.h"
#import "SeachCancelView.h"

@interface RecodeCheckVC ()<UISearchBarDelegate,UITextFieldDelegate,SeachCancelViewDelegate>{

    NSArray *hotSearch_array;
    UITextField * _searchTf;
    UISearchBar *_searchBar;
    NSMutableArray *_hisTmpArray;

}
//@property (nonatomic,strong)SeachView * searchView;
@property (nonatomic,strong)UIButton * delegateBtn;
@property (nonatomic, strong) SeachCancelView *searchView;


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
    _searchView = [SeachCancelView seachCancelView];
    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    _searchView.delegate = self;
    _searchView.textField.placeholder = @"请输入员工姓名";
    _searchView.textField.delegate = self;
    _searchView.textField.clearsOnInsertion = YES;
    _searchView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchView.textField becomeFirstResponder];
    _searchView.textField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_searchView];
    
}


- (void)seachDidClickedSeachBtn:(SeachCancelView *)seachView{
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return;
    }
    SeachRecodeListVC * resultVC = [[SeachRecodeListVC alloc] init];
    resultVC.secondVC = _secondVC;
    resultVC.realName = _searchView.textField.text;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }
    SeachRecodeListVC * resultVC = [[SeachRecodeListVC alloc] init];
    resultVC.secondVC = _secondVC;
    resultVC.realName = _searchView.textField.text;
    [self.navigationController pushViewController:resultVC animated:YES];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

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
