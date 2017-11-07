//
//  SearchDepartureVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/1.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SearchDepartureVC.h"
#import "SeachDepartureResultVC.h"
@interface SearchDepartureVC ()<UISearchBarDelegate,UITextFieldDelegate>{

    UISearchBar *_searchBar;
    UITextField * _searchTf;

}
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)SeachView * searchView;

@end

@implementation SearchDepartureVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"查询离任报告";
    [self isShowLeftButton:YES];
    [self initUI];
    
}

- (void)initUI{
    
    _searchView = [SeachView seachView];
    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    _searchView.searchBtn.hidden = YES;
    _searchView.placehoderText.placeholder = @"请输入员工姓名";
    _searchView.placehoderText.delegate = self;
    _searchView.placehoderText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_searchView.placehoderText becomeFirstResponder];
    _searchView.placehoderText.returnKeyType = UIReturnKeySearch;

    [self.view addSubview:_searchView];
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:_searchView.placehoderText];
    _imageView = [[UIImageView alloc] initWithFrame:_searchView.searchImage.frame];
    _imageView.image = [UIImage imageNamed:@"shanchu"];
    _imageView.hidden = YES;
    [_searchView addSubview:_imageView];
    
    UIButton * bb = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 40)];
    
    [bb setTitle:@"搜索" forState:UIControlStateNormal];
    bb.backgroundColor = [UIColor purpleColor];
    [bb addTarget:self action:@selector(bbClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:bb];
 
}
- (void)bbClick{

    SeachDepartureResultVC * seach = [[SeachDepartureResultVC alloc] init];
    seach.realName = _searchView.placehoderText.text;
    [self.navigationController pushViewController:seach animated:YES];
}


- (void)changeText{

    if (_searchView.placehoderText.text.length > 0) {
        
        _imageView.hidden = NO;
        _searchView.searchImage.hidden = YES;
    }
    if (_searchView.placehoderText.text.length == 0) {
        _imageView.hidden = YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    
    if (_searchView.placehoderText.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }
    
    SeachDepartureResultVC * seach = [[SeachDepartureResultVC alloc] init];
    seach.realName = _searchView.placehoderText.text;
    [self.navigationController pushViewController:seach animated:YES];
    return YES;
}

- (void)resignTextResponder
{
    if ([_searchView.placehoderText isFirstResponder])
    {
        [_searchView.placehoderText  resignFirstResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
