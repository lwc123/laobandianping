//
//  UserCommentDetailVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserCommentDetailVC.h"
#import "CompanyAnswerCommentVC.h"//写写评论
#import "UserCommentCompanyVC.h"//添加评论
#import "JX_ShareManager.h"

//可做公司详情（如果是(h5）
@interface UserCommentDetailVC ()<UIWebViewDelegate>{

    NSString * _urlStr ;
}
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *writeCommentBtn;
//回复评论
@property (nonatomic, strong) UIButton *answerCommentBtn;
@property (nonatomic,strong)UIWebView * webView;


@end

@implementation UserCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES withImg:[UIImage imageNamed:@"newshare"]];

    [self initUI];
    
}

- (void)initUI{

    [self.view addSubview:self.webView];
    _urlStr = [NSString stringWithFormat:[JXApiEnvironment Page_OpinionDetail_Endpoint],self.opinionEntity.OpinionId];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];

    
    if (self.isCompany == YES) {//是企业端
        [self.view addSubview:self.answerCommentBtn];
    }else{
    
        [self.view addSubview:self.commentBtn];
        [self.view addSubview:self.writeCommentBtn];
    }
}

#pragma mark -- 分享
- (void)ImgButtonAction:(UIButton *)btn{
    
    JX_ShareManager *manager = [JX_ShareManager shareManager];
    manager.curentVC = self;
    manager.opinionEntity = self.opinionEntity;
    manager.opinionDetailUrl = _urlStr;
    [manager isShowShareViewWithSuperView:self.view];
    
}

#pragma mark -- 回复评论
- (void)answerBtn{
    
    CompanyAnswerCommentVC * answerVC = [[CompanyAnswerCommentVC alloc] init];
    answerVC.title = @"回复评论";
    answerVC.secondVC = self;
    [self.navigationController pushViewController:answerVC animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [self showLoadingIndicator];
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self dismissLoadingIndicator];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [JsBridge initForWebView:webView with:self];
    
}

#pragma maek -- Lazy load

- (UIWebView *)webView{

    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44)];
        _webView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
        _webView.scrollView.showsVerticalScrollIndicator = YES;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (UIButton *)commentBtn{

    if (_commentBtn == nil) {
        _commentBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - 44 - 64), SCREEN_WIDTH / 2, 44)];
        [_commentBtn setTitle:@"点评这家公司" forState:UIControlStateNormal];
        _commentBtn.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (UIButton *)writeCommentBtn{
    if (_writeCommentBtn == nil) {
        _writeCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.commentBtn.frame), SCREEN_HEIGHT - 44 - 64, SCREEN_WIDTH / 2, 44)];
        [_writeCommentBtn setTitle:@"写写评论" forState:UIControlStateNormal];
        _writeCommentBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_writeCommentBtn setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
        _writeCommentBtn.backgroundColor = [UIColor whiteColor];
        [_writeCommentBtn addTarget:self action:@selector(writeCommentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _writeCommentBtn;
}

- (UIButton *)answerCommentBtn{
    
    if (_answerCommentBtn == nil) {
        _answerCommentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 40 - 64, SCREEN_WIDTH, 40)];
        [_answerCommentBtn setTitle:@"对此评论进行回复" forState:UIControlStateNormal];
        [_answerCommentBtn addTarget:self action:@selector(answerBtn) forControlEvents:UIControlEventTouchUpInside];
        _answerCommentBtn.backgroundColor = [UIColor redColor];
    }
    return _answerCommentBtn;
}

#pragma mark -- 点评这家公司
- (void)commentBtnClick{
    UserCommentCompanyVC * userCommentVC = [[UserCommentCompanyVC alloc] init];
    userCommentVC.secondVC = self;
    [self.navigationController pushViewController:userCommentVC animated:YES];
}
#pragma mark -- 写写评论
- (void)writeCommentBtnClick{
    CompanyAnswerCommentVC * writeCommentVC = [[CompanyAnswerCommentVC alloc] init];
    writeCommentVC.title = @"写写评论";
    writeCommentVC.opinionEntity = self.opinionEntity;
    [self.navigationController pushViewController:writeCommentVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
