//
//  JXCheckDetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXCheckDetailVC.h"
#import "JXNoPassVC.h"
#import "JXJudgeListVC.h"
#import "JXMessageAlertView.h"

@interface JXCheckDetailVC ()<UIWebViewDelegate,JXMessageAlertViewDelagate>

@property (nonatomic,strong)UIWebView * webView;
@property(nonatomic,strong)CompanyMembeEntity *myAccount;
@property(nonatomic,strong)CompanyMembeEntity *bossAccount;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) JXMessageAlertView * messageView;
@property (nonatomic, assign) BOOL isSendMes;

@end

@implementation JXCheckDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的评价";
    [self initData];
    [self isShowLeftButton:YES];
    [self initUI];
    [self initMessageAlert];

}

- (void)initData{
    _myAccount = [UserAuthentication GetMyInformation];
    _bossAccount = [UserAuthentication GetBossInformation];
    _isSendMes = YES;
}

- (void)initUI{
    
    NSString * urlStr ;
    if (self.commentEntity.CommentType == 1) {//离任
        
        urlStr = [NSString stringWithFormat:@"%@",API_Web_ReportDetail(_bossAccount.CompanyId,_commentEntity.CommentId)];

    }else if (self.commentEntity.CommentType == 0){//阶段
    
        urlStr = [NSString stringWithFormat:@"%@",API_Web_CommentDetail(_bossAccount.CompanyId,_commentEntity.CommentId)];
    }
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];

    if ((self.commentEntity.PresenterId != _myAccount.PassportId) && (self.commentEntity.AuditStatus == 0 || self.commentEntity.AuditStatus == 1)) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];

        //添加底部的两个btn
        UIButton * okBtn = [UIButton buttonWithFrame:CGRectMake(0, SCREEN_HEIGHT -64-44, SCREEN_WIDTH *0.5, 44) title:@"审核不通过" fontSize:15.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
        okBtn.backgroundColor = [UIColor blackColor];
        [self.view addSubview:okBtn];
        [okBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIButton * cancelBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH *0.5,SCREEN_HEIGHT -64-44, SCREEN_WIDTH *0.5, 44) title:@"审核通过" fontSize:15.0 titleColor:[UIColor whiteColor] imageName:nil bgImageName:nil];
        cancelBtn.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        [self.view addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    [_webView loadRequest:[_webView urlRequestWith:urlStr]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    [self showLoadingIndicator];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissLoadingIndicator];
    [JsBridge initForWebView:webView with:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [JsBridge initForWebView:webView with:self];
}


- (void)initMessageAlert{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.3;
    _messageView = [JXMessageAlertView messageAlertView];
    _messageView.userInteractionEnabled = YES;
    _messageView.frame = CGRectMake((SCREEN_WIDTH - 300) * 0.5, (SCREEN_HEIGHT - 150 - 64) * 0.5, 300, 150);
    _messageView.delegate = self;
}


//审核不通过
-(void)cancelBtnClick
{
    JXNoPassVC *vc = [[JXNoPassVC alloc]init];
    vc.ArchiveModel = _commentEntity;
    [self.navigationController pushViewController:vc animated:YES];
    
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
    [MineRequest PostArchiveCommentAuditPassWithCompanyId:_commentEntity.CompanyId CommentId:_commentEntity.CommentId IsSendSms:_isSendMes success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        [SVProgressHUD showSuccessWithStatus:@"审核通过"];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        
        if ([self.navigationController.viewControllers[1] isKindOfClass:[JXJudgeListVC class]]) {
            JXJudgeListVC * judgeListVC = self.navigationController.viewControllers[1];
            [judgeListVC.jxCollectionView.mj_header beginRefreshing];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        
        [self.navigationController popViewControllerAnimated:YES];
        
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

- (void)leftButtonAction:(UIButton *)button{
    
    [_bgView removeFromSuperview];
    [_messageView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
