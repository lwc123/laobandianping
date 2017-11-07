//
//  CommentsDetail.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "CommentsDetail.h"
#import "AddStaffRecordVC.h"
#import "WorkCommentsVC.h"


@interface CommentsDetail ()<UIWebViewDelegate,JHMenuViewDelegate>
@property (nonatomic,strong)ArchiveCommentEntity * commentEntity;
@property (nonatomic,strong)UIView * maskView;
@property (nonatomic ,assign)BOOL isClicked;//
@property (nonatomic,strong)JHMenuView * menuView;
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)EmployeArchiveEntity * employeEntity;


@end

@implementation CommentsDetail

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isClicked = NO;
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_webView reload];
    [self initRequest];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"阶段评价详情";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"detail"]];
    [self initData];
    [self initUI];
    [self initRecondDetailRequest];
}

- (void)initData{
    _commentEntity = [[ArchiveCommentEntity alloc] init];
    _bossEntity= [UserAuthentication GetBossInformation];
    _employeEntity = [[EmployeArchiveEntity alloc] init];
}

- (void)initRequest{

    [self showLoadingIndicator];
    [WorkbenchRequest getCommentDetailWithCompanyId:_bossEntity.CompanyId CommentId:self.commentId success:^(ArchiveCommentEntity *commentEntity) {
        [self dismissLoadingIndicator];
        NSLog(@"commentEntity===%@",commentEntity);
        _commentEntity = commentEntity;
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络正忙"];
        NSLog(@"error===%@",error);
    }];
}

- (void)initUI{

    NSString * urlStr = [NSString stringWithFormat:@"%@",API_Web_CommentDetail(_bossEntity.CompanyId,self.commentId)];
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
    _menuView.height = 105;
    _menuView.x = SCREEN_WIDTH - _menuView.width;
    _menuView.delegate = self;
    [_menuView.fixArchiveBtn setTitle:@"添加阶段评价" forState:UIControlStateNormal];
    [_menuView.fixCommentBtn setTitle:@"修改阶段评价" forState:UIControlStateNormal];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    [self showLoadingIndicator];
    [JsBridge initForWebView : webView with:self];

    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self dismissLoadingIndicator];
    [JsBridge initForWebView : webView with:self];
}

//档案详情 为了把职务列表传过去
- (void)initRecondDetailRequest{
    [self showLoadingIndicator];
    [WorkbenchRequest getArchiveDetailWithCompanyId:_bossEntity.CompanyId ArchiveID:self.archiveId success:^(EmployeArchiveEntity *archiveEntity) {
        [self dismissLoadingIndicator];
        if (archiveEntity) {
            _employeEntity =archiveEntity;
        }
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"error===%@",error);
    }];
}


- (void)tapAvatarAction:(UITapGestureRecognizer*)myTap{
    [_maskView removeFromSuperview];
    [_menuView removeFromSuperview];
    self.isClicked = NO;
}

#pragma mark -- 修改阶段评价
- (void)menuViewDidClickedFixComment:(JHMenuView *)jxFooterView{
    
    WorkCommentsVC * commentsVC = [[WorkCommentsVC alloc] init];
    commentsVC.title = @"修改阶段评价";
    commentsVC.detailComment = _commentEntity;
    [self.navigationController pushViewController:commentsVC animated:YES];
}
#pragma mark -- 添加阶段评价
- (void)menuViewDidClickedFixArchive:(JHMenuView *)jxFooterView{
    
//    AddStaffRecordVC * addStaffVC = [[AddStaffRecordVC alloc] init];
//    addStaffVC.title = @"修改员工档案";
//    addStaffVC.employeEntity = _employeEntity;
//    [self.navigationController pushViewController:addStaffVC animated:YES];
    
    // 1/25更新
    WorkCommentsVC * commentsVC = [[WorkCommentsVC alloc] init];
    commentsVC.title = @"添加阶段评价";
//    commentsVC.detailComment = _commentEntity;
//    commentsVC.employeArchive = _commentEntity.EmployeArchive;
    commentsVC.employeArchive = _employeEntity;
    commentsVC.archiveId = _employeEntity.ArchiveId;
    [self.navigationController pushViewController:commentsVC animated:YES];

}
#pragma mark -- 右上方的按钮
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
