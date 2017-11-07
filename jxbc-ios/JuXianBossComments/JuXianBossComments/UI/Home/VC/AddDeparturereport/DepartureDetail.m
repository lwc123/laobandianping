//
//  DepartureDetail.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "DepartureDetail.h"
#import "AddDepartureReportVC.h"
#import "AddStaffRecordVC.h"

@interface DepartureDetail ()<JHMenuViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)ArchiveCommentEntity * commentEntity;
@property (nonatomic,strong)UIView * maskView;
@property (nonatomic ,assign)BOOL isClicked;//
@property (nonatomic,strong)JHMenuView * menuView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)EmployeArchiveEntity * employeEntity;

@end

@implementation DepartureDetail



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_webView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"detail"]];
    [self initData];
    [self initRequest];
    [self initUI];
    [self initRecondDetailRequest];
}

- (void)initData{

    _commentEntity = [[ArchiveCommentEntity alloc] init];
    _bossEntity = [UserAuthentication GetBossInformation];
    _employeEntity = [[EmployeArchiveEntity alloc] init];

}

- (void)initRequest{
    [self showLoadingIndicator];
    MJWeakSelf
    [WorkbenchRequest getCommentDetailWithCompanyId:_bossEntity.CompanyId CommentId:self.commentId success:^(ArchiveCommentEntity *commentEntity) {
        [weakSelf dismissLoadingIndicator];
        _commentEntity = commentEntity;
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"离任报告详情 %@",error.localizedDescription]];
    }];
}


#pragma mark -- 右上方的按钮
- (void)ImgButtonAction:(UIButton *)btn{
    
    if (self.isClicked == NO) {
        self.isClicked = YES;
        [UIView animateWithDuration:35 animations:^{
            [self.view addSubview:_maskView];
            [self.view addSubview:_menuView];
        }];
    }else{
        self.isClicked = NO;
        [_menuView removeFromSuperview];
        [_maskView removeFromSuperview];
    }
}


- (void)initUI{
    
    
    NSString * urlStr = [NSString stringWithFormat:@"%@",API_Web_ReportDetail(_bossEntity.CompanyId,self.commentId)];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
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
    _menuView.y = 0;
    _menuView.height = 55;
    _menuView.x = SCREEN_WIDTH - _menuView.width;
    [_menuView.fixArchiveBtn setTitle:@"修改离任报告" forState:UIControlStateNormal];
//    [_menuView.fixCommentBtn setTitle:@"修改评价/离任报告" forState:UIControlStateNormal];
    _menuView.delegate = self;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    [self showLoadingIndicator];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self dismissLoadingIndicator];
    [JsBridge initForWebView : webView with:self];

}


- (void)tapAvatarAction:(UITapGestureRecognizer*)myTap{
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
    self.isClicked = NO;
}

#pragma mark -- 修改评价 离任
//- (void)menuViewDidClickedFixComment:(JHMenuView *)jxFooterView{
//    AddDepartureReportVC * commentsVC = [[AddDepartureReportVC alloc] init];
//    commentsVC.title = @"修改离任报告";
//    commentsVC.detaiComment  = _commentEntity;
//    [self.navigationController pushViewController:commentsVC animated:YES];
//}

#pragma mark -- 修改离任报告 
// 1.25 更新
- (void)menuViewDidClickedFixArchive:(JHMenuView *)jxFooterView{
    AddDepartureReportVC * commentsVC = [[AddDepartureReportVC alloc] init];
    commentsVC.title = @"修改离任报告";
    commentsVC.detaiComment  = _commentEntity;
    [self.navigationController pushViewController:commentsVC animated:YES];
}


//档案详情 为了把职务列表传过去
- (void)initRecondDetailRequest{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
