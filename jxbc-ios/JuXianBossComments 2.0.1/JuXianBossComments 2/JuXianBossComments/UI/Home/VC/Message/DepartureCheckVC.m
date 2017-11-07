//
//  DepartureCheckVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "DepartureCheckVC.h"
#import "JXNoPassVC.h"
#import "JXMessageVC.h"//消息列表
#import "WorkCommentsVC.h"
#import "AddDepartureReportVC.h"

#import "JXMessageAlertView.h"

@interface DepartureCheckVC ()<UIWebViewDelegate,JXMessageAlertViewDelagate>
@property (nonatomic,strong)UIWebView * webView;
@property (nonatomic,strong)ArchiveCommentEntity * commentEntity;
@property (nonatomic,strong)CompanyMembeEntity * bossEntity;
@property (nonatomic,strong)CompanyMembeEntity * myEntity;
@property (nonatomic, assign) BOOL isSendMes;
@property (nonatomic, strong) JXMessageAlertView * messageView;
@property (nonatomic, strong) UIView *bgView;

@end

@implementation DepartureCheckVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self initData];
    [self initRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    _isSendMes = YES;
//    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"detail"]];
    [self initWebView];
    [self initMessageAlert];
}

- (void)initWebView{
    NSString * str;
    if (self.BizType == 2) {//离任
        str = [NSString stringWithFormat:@"%@",API_Web_ReportDetail(self.companyId,self.commentId)];
    }
    if (self.BizType == 3) {
        str = [NSString stringWithFormat:@"%@",API_Web_CommentDetail(self.companyId,self.commentId)];
    }
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _webView.delegate = self;
    [_webView loadRequest:[_webView urlRequestWith:str]];
    [self.view addSubview:_webView];
}

- (void)initMessageAlert{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.5;
    _messageView = [JXMessageAlertView messageAlertView];
    _messageView.userInteractionEnabled = YES;
    _messageView.frame = CGRectMake((SCREEN_WIDTH - 300) * 0.5, (SCREEN_HEIGHT - 150 - 64) * 0.5, 300, 150);
    _messageView.delegate = self;
}

- (void)initData{
    _commentEntity = [[ArchiveCommentEntity alloc] init];
    _bossEntity= [UserAuthentication GetBossInformation];
    _myEntity = [UserAuthentication GetMyInformation];
}

- (void)initRequest{
    
    [self showLoadingIndicator];
    [MineRequest getArchiveCommentSummaryCompanyId:_bossEntity.CompanyId CommentId:self.commentId success:^(ArchiveCommentEntity *commentEntity) {
        [self dismissLoadingIndicator];
        _commentEntity = commentEntity;
        if (commentEntity.AuditStatus == 1 && (_myEntity.Role == Role_Boss || _myEntity.Role == Role_HightManager)) {
            [self initUI];
            _webView.height = SCREEN_HEIGHT - 64 - 49;
        }else if (commentEntity.AuditStatus == 9 && (_myEntity.PassportId == commentEntity.PresenterId)){//被拒绝 并且提交人就是当前用户
            _webView.height = SCREEN_HEIGHT - 64 - 49;
            [self sumitAgain];
        }else if (commentEntity.AuditStatus == 1 && (_myEntity.Role == Role_manager || _myEntity.Role == Role_BuildMembers)){
            [self initWebView];
        }
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络正忙"];
        NSLog(@"error===%@",error);
    }];
}

- (void)initUI{

    //添加底部的两个btn
    UIButton * okBtn = [UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT -64-48, SCREEN_WIDTH *0.5, 48) title:@"审核不通过" fontSize:15.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
    okBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:okBtn];
    [okBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * cancelBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH *0.5,SCREEN_HEIGHT -64-48, SCREEN_WIDTH *0.5, 48) title:@"审核通过" fontSize:15.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
    cancelBtn.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
    [self.view addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sumitAgain{

    UIButton * submitBtn = [UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT -64-48, SCREEN_WIDTH, 48) title:@"重新提交" fontSize:15.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
    submitBtn.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submitBtn) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -- 重新提交
- (void)submitBtn{

    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getCommentDetailWithCompanyId:_bossEntity.CompanyId CommentId:self.commentId success:^(ArchiveCommentEntity *commentEntity) {
        
        [weakSelf dismissLoadingIndicator];
        _commentEntity = commentEntity;
        [self jumbWith:_commentEntity];
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:@"网络正忙"];
    }];

    /*
    if (_commentEntity.CommentType == 0){
        WorkCommentsVC *commentsVC = [[WorkCommentsVC alloc]init];
        //取到对应位置的模型
        commentsVC.detailComment = _commentEntity;
        commentsVC.title = @"修改阶段评价";
        commentsVC.secondVC = self;
        //        commentsVC.archiveId = archiveModel.ArchiveId;
        [self.navigationController pushViewController:commentsVC animated:YES];
    }else if (_commentEntity.CommentType == 1){//离任评价
        
        AddDepartureReportVC * addVC = [[AddDepartureReportVC alloc] init];
        addVC.title = @"修改离任报告";
        addVC.detaiComment = _commentEntity;
        [self.navigationController pushViewController:addVC animated:YES];
    }
*/
}

#pragma mark -- 重新提交 判断跳阶段评价还是离任
- (void)jumbWith:(ArchiveCommentEntity *)archiveModel{
    
    if (archiveModel.CommentType == 0){
        WorkCommentsVC *commentsVC = [[WorkCommentsVC alloc]init];
        //取到对应位置的模型
        commentsVC.detailComment = archiveModel;
        commentsVC.title = @"修改阶段评价";
        commentsVC.secondVC = self;
        //        commentsVC.archiveId = archiveModel.ArchiveId;
        [self.navigationController pushViewController:commentsVC animated:YES];
    }else if (archiveModel.CommentType == 1){//离任评价
        
        AddDepartureReportVC * addVC = [[AddDepartureReportVC alloc] init];
        addVC.title = @"修改离任报告";
        addVC.detaiComment = archiveModel;
        [self.navigationController pushViewController:addVC animated:YES];
    }
}


//审核通过
-(void)okBtnClick
{
    [self.view addSubview:_bgView];
    [self.view addSubview:_messageView];
}

#pragma mark -- messageAlertViewdelegate
//发送短信
- (void)messageAlertViewDidClickedWithAlertView:(JXMessageAlertView *)areltView{
    if (areltView.clickBtn.selected == YES) {
        _isSendMes = NO;
    }else{
        _isSendMes = YES;
    }
}
#pragma mark -- 确定
- (void)messageAlertViewSurelClickWithAlertView:(JXMessageAlertView *)areltView{
    [_messageView removeFromSuperview];
    [_bgView removeFromSuperview];
    [self showLoadingIndicator];
    MJWeakSelf
    
    [MineRequest PostArchiveCommentAuditPassWithCompanyId:self.companyId CommentId:self.commentId IsSendSms:_isSendMes success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        [SVProgressHUD showSuccessWithStatus:@"审核通过"];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        if ([self.navigationController.viewControllers[1] isKindOfClass:[JXMessageVC class]]) {
            JXMessageVC * messageVC = self.navigationController.viewControllers[1];
            [messageVC.jxTableView.mj_header beginRefreshing];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [SVProgressHUD showErrorWithStatus:@"审核失败"];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
    }];

}
#pragma mark -- 取消
- (void)messageAlertViewCacenlClickWithAlertView:(JXMessageAlertView *)areltView{
    [_bgView removeFromSuperview];
    [_messageView removeFromSuperview];
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

//审核不通过
-(void)cancelBtnClick
{
    JXNoPassVC *noPassvc = [[JXNoPassVC alloc]init];
    noPassvc.ArchiveModel = _commentEntity;
    noPassvc.secondVC = self;
    [self.navigationController pushViewController:noPassvc animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    
    [_bgView removeFromSuperview];
    [_messageView removeFromSuperview];
    
    if ([self.navigationController.viewControllers[1] isKindOfClass:[JXMessageVC class]]) {
        JXMessageVC * messageVC = self.navigationController.viewControllers[1];
        [messageVC.jxTableView.mj_header beginRefreshing];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
