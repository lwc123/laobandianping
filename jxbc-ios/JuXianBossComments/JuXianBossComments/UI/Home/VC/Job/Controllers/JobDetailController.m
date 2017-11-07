//
//  JobDetailController.m
//  JuXianBossComments
//
//  Created by Jam on 17/1/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JobDetailController.h"
#import "JobEntity.h"
#import "WorkBenchJobRequest.h"
#import "JobPublicPositionViewController.h"
#import "JobPublicListViewController.h"
@interface JobDetailController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIButton *editButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) JobEntity *jobEntity;


@end

@implementation JobDetailController

- (instancetype)initWithJob:(JobEntity* )jobEntity
{
    self = [super init];
    if (self) {
        self.jobEntity = jobEntity;
        self.closeButton.selected = jobEntity.DisplayState;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:YES];

    [self.view addSubview:self.webView];
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.editButton];
    self.title = self.jobEntity.JobName;
    
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:API_getJob_detailHtml([UserAuthentication GetMyInformation].CompanyId,self.jobEntity.JobId)]];
    [_webView loadRequest:request];
    
}
#pragma mark -  开启关闭按钮点击
- (void)closeButtonClick:(UIButton*)sender{
    [self showLoadingIndicator];
    MJWeakSelf
    if (!sender.selected) {// 关闭
        [WorkBenchJobRequest postJob_closeJobWith:[UserAuthentication GetMyInformation].CompanyId and:self.jobEntity.JobId success:^(id result) {
            [weakSelf dismissLoadingIndicator];
            if ([result boolValue]) {
                sender.selected = !sender.selected;
                [PublicUseMethod showAlertView:@"关闭成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    if ([weakSelf.navigationController.viewControllers[1] isKindOfClass:[JobPublicListViewController class]]) {
                        
                        JobPublicListViewController * job = weakSelf.navigationController.viewControllers[1];
                        [job.jxTableView.mj_header beginRefreshing];
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            [weakSelf alertString:[NSString stringWithFormat:@"%@",error.description] duration:1];
        }];
    }else{// 开启
        [WorkBenchJobRequest postJob_openJobWith:[UserAuthentication GetMyInformation].CompanyId and:self.jobEntity.JobId success:^(id result) {
            [weakSelf dismissLoadingIndicator];
            if ([result boolValue]) {
                sender.selected = !sender.selected;
            }
        } fail:^(NSError *error) {
            [weakSelf dismissLoadingIndicator];
            [weakSelf alertString:[NSString stringWithFormat:@"%@",error.description] duration:1];
        }];
        
    }
}
#pragma mark - 编辑按钮
- (void)editButtonCilck{
    
    [WorkBenchJobRequest getJob_jodDetailWith:[UserAuthentication GetMyInformation].CompanyId and:self.jobEntity.JobId success:^(JobEntity* result) {
        
        if ([result isKindOfClass:[JobEntity class]]) {
            JobPublicPositionViewController* jobPublic = [[JobPublicPositionViewController alloc]initWithJobEntity:result];
            [self.navigationController pushViewController:jobPublic animated:YES];
        }
        
    } fail:^(NSError *error) {
        [self alertString:[NSString stringWithFormat:@"%@",error.localizedDescription] duration:1];
        
    }];
    
}

#pragma mark - webView Delegate

#pragma mark - View
- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64 - 44)];
        
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
    
}

// 关闭按钮
- (UIButton *)closeButton{
    
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight-44-64, ScreenWidth/2, 44)];
        [_closeButton setTitle:@"关闭职位" forState:UIControlStateNormal];
        [_closeButton setTitle:@"开启职位" forState:UIControlStateSelected];
        [_closeButton setBackgroundColor:ColorWithHex(KColor_Text_BlackColor)];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

// 编辑按钮
- (UIButton *)editButton{
    
    if (_editButton == nil) {
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2, ScreenHeight-44-64, ScreenWidth/2, 44)];
        [_editButton setTitle:@"编辑职位" forState:UIControlStateNormal];
        [_editButton setBackgroundColor:ColorWithHex(KColor_GoldColor)];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_editButton addTarget:self action:@selector(editButtonCilck) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [JsBridge initForWebView:webView with:self];

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [JsBridge initForWebView:webView with:self];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [JsBridge initForWebView:webView with:self];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.webView reload];
    });

}


@end
