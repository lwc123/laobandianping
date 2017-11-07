//
//  SeachCommentVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachCommentVC.h"
#import "SeachResultCommentVC.h"

@interface SeachCommentVC ()<UITextFieldDelegate>
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)SeachView * searchView;

@end

@implementation SeachCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询阶段评价";
    [self isShowLeftButton:YES];
    [self initUI];}


- (void)initUI{
    
    _searchView = [SeachView seachView];
    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    _searchView.searchBtn.hidden = YES;
    _searchView.placehoderText.placeholder = @"请输入员工姓名";
    _searchView.placehoderText.delegate = self;
    [_searchView.placehoderText becomeFirstResponder];
    _searchView.placehoderText.clearButtonMode = UITextFieldViewModeWhileEditing;
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

- (void)changeText{

    
}

- (void)bbClick{

    SeachResultCommentVC * resultVC = [[SeachResultCommentVC alloc] init];
    resultVC.realName = _searchView.placehoderText.text;
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    
    if (_searchView.placehoderText.text.length == 0) {
        
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }
    
    SeachResultCommentVC * resultVC = [[SeachResultCommentVC alloc] init];
    resultVC.realName = _searchView.placehoderText.text;
    [self.navigationController pushViewController:resultVC animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
