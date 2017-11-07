//
//  SeachCommentVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachCommentVC.h"
#import "SeachResultCommentVC.h"
#import "SeachCancelView.h"

@interface SeachCommentVC ()<UITextFieldDelegate,SeachCancelViewDelegate>
@property (nonatomic,strong)UIImageView * imageView;
//@property (nonatomic,strong)SeachView * searchView;
@property (nonatomic, strong) SeachCancelView *searchView;


@end

@implementation SeachCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询阶段评价";
    [self isShowLeftButton:YES];
    [self initUI];}


- (void)initUI{
    
    _searchView = [SeachCancelView seachCancelView];
    _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    _searchView.delegate = self;
    _searchView.textField.placeholder = @"请输入员工姓名";
    _searchView.textField.delegate = self;
    _searchView.textField.clearsOnInsertion = YES;
    [_searchView.textField becomeFirstResponder];
    _searchView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchView.textField.returnKeyType = UIReturnKeySearch;
    [self.view addSubview:_searchView];
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:_searchView.textField];
    
    _imageView = [[UIImageView alloc] initWithFrame:_searchView.searchImage.frame];
    _imageView.image = [UIImage imageNamed:@"shanchu"];
    _imageView.hidden = YES;
    [_searchView addSubview:_imageView];
    
}

- (void)changeText{

    
}

- (void)seachDidClickedSeachBtn:(SeachCancelView *)seachView{
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return;
    }
    
    SeachResultCommentVC * resultVC = [[SeachResultCommentVC alloc] init];
    resultVC.realName = _searchView.textField.text;
    [self.navigationController pushViewController:resultVC animated:YES];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{    
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }
    
    SeachResultCommentVC * resultVC = [[SeachResultCommentVC alloc] init];
    resultVC.realName = _searchView.textField.text;
    [self.navigationController pushViewController:resultVC animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
