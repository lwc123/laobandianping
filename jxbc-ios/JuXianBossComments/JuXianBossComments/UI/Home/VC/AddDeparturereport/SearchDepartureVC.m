//
//  SearchDepartureVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SearchDepartureVC.h"
#import "SeachDepartureResultVC.h"
#import "SeachCancelView.h"
@interface SearchDepartureVC ()<UISearchBarDelegate,UITextFieldDelegate,SeachCancelViewDelegate>{

    UISearchBar *_searchBar;
    UITextField * _searchTf;

}
@property (nonatomic,strong)UIImageView * imageView;
//@property (nonatomic,strong)SeachView * searchView;
@property (nonatomic, strong) SeachCancelView *searchView;

@end

@implementation SearchDepartureVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"查询离任报告";
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
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:_searchView.textField];
    
    _imageView = [[UIImageView alloc] initWithFrame:_searchView.searchImage.frame];
    _imageView.image = [UIImage imageNamed:@"shanchu"];
    _imageView.hidden = YES;
    [_searchView addSubview:_imageView];

 
}

- (void)seachDidClickedSeachBtn:(SeachCancelView *)seachView{
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return;
    }
    SeachDepartureResultVC * seach = [[SeachDepartureResultVC alloc] init];
    seach.realName = _searchView.textField.text;
    [self.navigationController pushViewController:seach animated:YES];

}



- (void)changeText{

    if (_searchView.textField.text.length > 0) {
        _imageView.hidden = NO;
        _searchView.searchImage.hidden = YES;
    }
    if (_searchView.textField.text.length == 0) {
        _imageView.hidden = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }
    SeachDepartureResultVC * seach = [[SeachDepartureResultVC alloc] init];
    seach.realName = _searchView.textField.text;
    [self.navigationController pushViewController:seach animated:YES];
    return YES;
}

- (void)resignTextResponder
{
    if ([_searchView.textField isFirstResponder])
    {
        [_searchView.textField  resignFirstResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
