//
//  StaffDetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "StaffDetailVC.h"
#import "AddStaffRecordVC.h"
#import "WorkCommentsVC.h"
#import "AllCommentlistVC.h"
#import "SeachRecodeListVC.h"

@interface StaffDetailVC ()<UIWebViewDelegate,JHMenuViewDelegate>

@property (nonatomic,strong)UIView * maskView;
@property (nonatomic ,assign)BOOL isClicked;//
@property (nonatomic,strong)JHMenuView * menuView;
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)EmployeArchiveEntity * employeEntity;
@property (nonatomic,strong)CompanyMembeEntity *bossEntity;

@end

@implementation StaffDetailVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _bossEntity = [UserAuthentication GetBossInformation];
    [self initRequest];
    [_webView reload];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工档案详情";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"detail"]];
    [self initData];
    [self initUI];
}

- (void)initData{

    _employeEntity = [[EmployeArchiveEntity alloc] init];
}

- (void)initRequest{
    [self showLoadingIndicator];
    MJWeakSelf
    [WorkbenchRequest getArchiveDetailWithCompanyId:_bossEntity.CompanyId ArchiveID:self.archiveId success:^(EmployeArchiveEntity *archiveEntity) {
        [weakSelf dismissLoadingIndicator];
        if (archiveEntity) {
            _employeEntity =archiveEntity;
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)initUI{
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",API_Web_ArchiveDetail(self.companyId,self.archiveId)];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [_webView loadRequest:[_webView urlRequestWith:urlStr]];
    _webView.delegate = self;
    [self.view addSubview:_webView];

    
    _isClicked = NO;
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha= .5;
    _maskView.userInteractionEnabled = YES;
    [_maskView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarAction:)]];
    _menuView = [JHMenuView menuView];
    _menuView.height = 105;
    [_menuView.fixArchiveBtn setTitle:@"修改员工档案" forState:UIControlStateNormal];
    [_menuView.fixCommentBtn setTitle:@"修改评价/离任报告" forState:UIControlStateNormal];

    _menuView.y = 0;
    _menuView.x = SCREEN_WIDTH - _menuView.width;
    _menuView.delegate = self;
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    [JsBridge initForWebView:webView with:self];
    [self showLoadingIndicator];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [JsBridge initForWebView:webView with:self];
    [self dismissLoadingIndicator];
}

- (void)tapAvatarAction:(UITapGestureRecognizer*)myTap{
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
    self.isClicked = NO;
}

#pragma mark -- 修改评价 离任
- (void)menuViewDidClickedFixComment:(JHMenuView *)jxFooterView{
    //跳入评价 离任列表
    AllCommentlistVC * allListVC = [[AllCommentlistVC alloc] init];
    allListVC.archiveId = _employeEntity.ArchiveId;
    allListVC.nameStr =_employeEntity.RealName;
    [self.navigationController pushViewController:allListVC animated:YES];
}
#pragma mark -- 修改档案
- (void)menuViewDidClickedFixArchive:(JHMenuView *)jxFooterView{
    AddStaffRecordVC * addStaffVC = [[AddStaffRecordVC alloc] init];
    addStaffVC.title = @"修改员工档案";
    addStaffVC.employeEntity = _employeEntity;
    [self.navigationController pushViewController:addStaffVC animated:YES];
}

- (void)ImgButtonAction:(UIButton *)btn{
    if (self.isClicked == NO) {
        self.isClicked = YES;
        [self.view addSubview:_maskView];
        [self.view addSubview:_menuView];
    }else{
        self.isClicked = NO;
        [_menuView removeFromSuperview];
        [_maskView removeFromSuperview];
    }
}
- (void)leftButtonAction:(UIButton *)button{
    
    if ([self.secondVC isKindOfClass:[SeachRecodeListVC class]]) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
