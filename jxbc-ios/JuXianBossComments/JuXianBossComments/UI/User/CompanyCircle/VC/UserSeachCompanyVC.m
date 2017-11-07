//
//  UserSeachCompanyVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserSeachCompanyVC.h"
#import "OpinionCompanyEntity.h"
#import "SeachCancelView.h"
#import "OpenCommentVC.h"
#import "CompanyListVC.h"
@interface UserSeachCompanyVC ()<SeachCancelViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *formerClubArray;
@property (nonatomic, strong) NSMutableArray *seachArray;
@property (nonatomic, copy) NSString *keywordStr;
@property (nonatomic, strong) NilView * nilview;
@property (nonatomic, strong) SeachCancelView * searchView;
@property (nonatomic,strong)UIImageView * imageView;

@end

@implementation UserSeachCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"搜索公司";
    [self isShowLeftButton:YES];
    [self initUI];
    [self initData];
    [self initCompanyRequestWith:@" "];
}
- (void)initData{

}

- (void)initCompanyRequestWith:(NSString *)seachText{

    MJWeakSelf
    [self showLoadingIndicator];
    [UserOpinionRequest getCompanySearchWithKeyword:@" " success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        
        if (array.count == 0) {
            
            [self.jxTableView addSubview:self.nilview];

            if ([seachText isEqualToString:@" "]) {
                self.nilview.labelStr = @"搜索您的老东家，看看对他的评价";
            }else{
                self.nilview.isHiddenButton = NO;
                self.nilview.labelStr = @"暂无收录此公司，您可以创建此公司";
                UIButton * btn = [[UIButton alloc] init];
                btn = [self.nilview viewWithTag:2000];
                [btn setTitle:@"创建此公司" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(createCompany:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }else{
            [self.nilview removeFromSuperview];
        }
        
        if (array.count != 0) {
            for (OpinionCompanyEntity * model in array) {
                if ([model isKindOfClass:[OpinionCompanyEntity class]]) {
                    [weakSelf.formerClubArray addObject:model];
                }
            }
            [weakSelf.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];

}

#pragma mark -- 创建此公司 -- 开户
- (void)createCompany:(UIButton *)button{
    OpenCommentVC * openVC = [[OpenCommentVC alloc] init];
    openVC.isChangeCompany = YES;
    openVC.secondVC = self;
    [self.navigationController pushViewController:openVC animated:YES];
}

- (void)initUI{

    [self.view addSubview:self.searchView];
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 64);
    //监听文本框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeText) name:UITextFieldTextDidChangeNotification object:_searchView.textField];
    
    _imageView = [[UIImageView alloc] initWithFrame:_searchView.searchImage.frame];
    _imageView.image = [UIImage imageNamed:@"shanchu"];
    _imageView.hidden = YES;
    [_searchView addSubview:_imageView];
}

- (void)changeText{
    
    if (_searchView.textField.text.length > 0) {
        _imageView.hidden = NO;
        self.searchView.searchImage.hidden = YES;
        
        if (self.searchView.textField.text.length > 1) {
            [self initCompanyRequestWith:self.searchView.textField.text];
        }
    }
    if (self.searchView.textField.text.length == 0) {
        _imageView.hidden = YES;
    }
    
}

#pragma mark -- 点击搜索
- (void)seachDidClickedSeachBtn:(SeachCancelView *)seachView{


}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    
    if (_searchView.textField.text.length == 0) {
        [PublicUseMethod showAlertView:@"搜索内容不能为空"];
        return NO;
    }

    if (self.searchView.textField.text.length > 1) {
        
        [self initCompanyRequestWith:self.searchView.textField.text];
    }
    
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.formerClubArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellId = @"companyCell";
    UITableViewCell * companyCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!companyCell) {
        companyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    companyCell.textLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    companyCell.textLabel.font = [UIFont systemFontOfSize:15.0];
    OpinionCompanyEntity * companyEntity =self.formerClubArray[indexPath.row];
    companyCell.textLabel.text =companyEntity.CompanyName;
    return companyCell;
}

- (NSMutableArray *)formerClubArray{

    if (_formerClubArray == nil) {
        _formerClubArray = @[].mutableCopy;
    }
    return _formerClubArray;
}

- (NSMutableArray *)seachArray{
    
    if (_seachArray == nil) {
        _seachArray = @[].mutableCopy;
    }
    return _seachArray;
}

- (SeachCancelView *)searchView{

    if (_searchView == nil) {
        _searchView = [SeachCancelView seachCancelView];
        _searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _searchView.delegate = self;
        _searchView.textField.placeholder = @"搜索您感兴趣的公司";
        _searchView.searchBtn.hidden = YES;
        _searchView.textField.delegate = self;
        _searchView.textField.clearsOnInsertion = YES;
        _searchView.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchView.textField becomeFirstResponder];
        _searchView.textField.returnKeyType = UIReturnKeySearch;        
    }
    return _searchView;
}


- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, 300)];
    }
    return _nilview;
}

- (void)leftButtonAction:(UIButton *)button{

    if ([self.secondVC isKindOfClass:[CompanyListVC class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
