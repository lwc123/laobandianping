//
//  WorkbenchViewController.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "WorkbenchViewController.h"
#import "FixCompanyVC.h"
//添加评价
#import "StaffListVC.h"
#import "ReportListVC.h"//添加离任报告
#import "InvitationRegistVC.h"
#import "CommentsListVC.h"
#import "JXMessageVC.h"
#import "ExamineBackdropVC.h"
#import "UserWorkbenchVC.h"
#import "JobQueryListViewController.h"
#import "JobPublicListViewController.h"
#import "SignOut.h"
#import "JXOpenServiceWebVC.h"
#import "BossCommentTabBarCtr.h"
@interface WorkbenchViewController ()

@property (nonatomic,strong)WorkHeaderView * workView;
@property (nonatomic,strong)WorkbentchView * bentchView;
@property (nonatomic,strong)WorkbentchView * twoBentchView;
@property (nonatomic,strong)WorkbentchView * threeBentchView;
@property (nonatomic,assign)long companyId;
@property (nonatomic,assign)long auditStatus;
@property (nonatomic,copy)NSString * alertStr;
@property (nonatomic,strong)UIButton * bigButtoon;
@property (nonatomic, assign) NSInteger days;
@property (nonatomic, strong) NSDate *serviceStopDate;
@property (nonatomic, strong) VersionEntity *version;
@end

@implementation WorkbenchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSString * companyIdStr = [[NSUserDefaults standardUserDefaults] valueForKey:CompanyChoiceKey];
    self.companyId = [companyIdStr longLongValue];
    [self initRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self isShowLeftButton:NO];
      AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
    if ([myaccount.MobilePhone isEqualToString:DemoPhone]) {//演示账号
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 65, 30)];
        button.contentMode = UIViewContentModeRight;
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        [button setTitle:@"退出演示" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [PublicUseMethod setColor:KColor_RedColor];
        [button addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    // 检查更新
    [self existeVersion];
    [self initUI];
}
#pragma maek -- 退出演示
- (void)rightButtonAction:(UIButton *)btn{

    btn.enabled = NO;
    btn.backgroundColor = [UIColor lightGrayColor];
    [self showLoadingIndicator];
    [SignOut signOutAccountWith:btn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissLoadingIndicator];
    });
}

- (void)initUI{
    _workView = [WorkHeaderView workHeaderView];
    _workView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 120);
    [self.view addSubview:_workView];
    
    CGFloat benchH = 97;
    _bentchView = [WorkbentchView workbentchView];
    _bentchView.frame = CGRectMake(0, CGRectGetMaxY(_workView.frame)+10, SCREEN_WIDTH, benchH);
    
    [_bentchView.oneBtn addTarget:self action:@selector(putArchivesClick) forControlEvents:UIControlEventTouchUpInside];
    [_bentchView.twoBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bentchView.threeBtn addTarget:self action:@selector(liZhiClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bentchView];
    
    _twoBentchView = [WorkbentchView workbentchView];
    _twoBentchView.frame = CGRectMake(0, CGRectGetMaxY(_bentchView.frame), SCREEN_WIDTH, benchH);
    
    
    _twoBentchView.recodeLabel.text = @"背景调查";
    _twoBentchView.fixUnreadMessage.hidden = YES;
    _twoBentchView.recodeImageView.image = [UIImage imageNamed:@"beijingdiaocha"];
    _twoBentchView.commentLabel.text = @"招聘";
    _twoBentchView.commentImageView.image = [UIImage imageNamed:@"xjhzhaop"];
    _twoBentchView.liZhiLabel.text = @"消息";
    _twoBentchView.liZhiImageView.image = [UIImage imageNamed:@"xiaoxi"];
    _twoBentchView.fixImageVIew.hidden = YES;
    _twoBentchView.unReadMassage.hidden = NO;

    //招聘隐藏
    [_twoBentchView.oneBtn addTarget:self action:@selector(checkCommentClick) forControlEvents:UIControlEventTouchUpInside];
    [_twoBentchView.twoBtn addTarget:self action:@selector(advertiseClick) forControlEvents:UIControlEventTouchUpInside];
    [_twoBentchView.threeBtn addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_twoBentchView];

    _threeBentchView = [WorkbentchView workbentchView];
    _threeBentchView.frame = CGRectMake(0, CGRectGetMaxY(_twoBentchView.frame), SCREEN_WIDTH, benchH);
    _threeBentchView.backgroundColor = [UIColor clearColor];
    _threeBentchView.lastLowView.hidden = NO;
    _threeBentchView.recodeLabel.text = @"邀请企业注册";
    
    //暂时放在这个人工作台
    _threeBentchView.twoLineView.hidden = YES;
    _threeBentchView.commentLabel.hidden = YES;
    _threeBentchView.twoLineView.hidden = YES;
    _threeBentchView.commentImageView.hidden = YES;
    
    _threeBentchView.liZhiLabel.hidden = YES;
    _threeBentchView.liZhiImageView.hidden = YES;
    _threeBentchView.recodeImageView.image = [UIImage imageNamed:@"yaoqingboss"];
    _threeBentchView.youJiangImageView.hidden = NO;
    [_threeBentchView.oneBtn addTarget:self action:@selector(invitationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_threeBentchView];
    
    UIButton * bigButtoon = [UIButton buttonWithType:UIButtonTypeCustom];
    bigButtoon.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bigButtoon.backgroundColor = [UIColor clearColor];
    [bigButtoon bringSubviewToFront:self.view];
    [self.view addSubview:bigButtoon];
    
    [bigButtoon addTarget:self action:@selector(alertViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    _bigButtoon.hidden = YES;
    _bigButtoon = bigButtoon;

}
- (void)initRequest{
     WEAKSELF(_workView);
    MJWeakSelf
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //[self showLoadingIndicator];
    });
    [WorkbenchRequest getWorkbenchInformiationWithCompanyId:self.companyId success:^(CompanySummary *summaryEntity) {
        [weakSelf dismissLoadingIndicator];
        [UserAuthentication SaveCompanySummary:summaryEntity];
        [UserAuthentication SaveBossInformation:summaryEntity.BossInformation];
        [UserAuthentication SaveMyInformation:summaryEntity.MyInformation];
        
        if (![summaryEntity isKindOfClass:[NSNull class]]) {
            weakSelf.days = [summaryEntity getServiceDays];
            
            [weak_workView.iconImageView sd_setImageWithURL:[NSURL URLWithString:summaryEntity.CompanyLogo] placeholderImage:Company_LOGO_Image];
            // 企业简称
            weak_workView.companyName.text = summaryEntity.CompanyAbbr;
            weak_workView.LegalName.text = summaryEntity.LegalName;
            weak_workView.EmployedNum.text = [NSString stringWithFormat:@"在职员工：%ld",summaryEntity.EmployedNum];
            weak_workView.DimissionNum.text = [NSString stringWithFormat:@"离任员工：%ld",summaryEntity.DimissionNum];
            
            weak_workView.stageEvaluationNum.text = [NSString stringWithFormat:@"阶段评价：%ld",(long)summaryEntity.StageEvaluationNum];
            
            weak_workView.reportNum.text = [NSString stringWithFormat:@"离任报告：%ld",(long)summaryEntity.DepartureReportNum];
            
            // 认证状态
            if (summaryEntity.AuditStatus == 1) {
                weak_workView.auditSatus.text = @"认证审核中";
            }
            if (summaryEntity.AuditStatus == 2) {
                weak_workView.auditSatus.text = @" ";
                weak_workView.auditImageView.hidden = NO;
            }
                        
            if (summaryEntity.UnreadMessageNum == 0) {
                _twoBentchView.unReadMassage.hidden = YES;
            }else if (summaryEntity.UnreadMessageNum < 100){
                _twoBentchView.unReadMassage.hidden = NO;
                _twoBentchView.unReadMassage.text = [NSString stringWithFormat:@"%ld",summaryEntity.UnreadMessageNum];
            }else{//大于100
                weakSelf.twoBentchView.unReadMassage.text = @"...";
            }
            _auditStatus = summaryEntity.AuditStatus;            
            if (summaryEntity.PromptInfo) {
                _alertStr = summaryEntity.PromptInfo;
                [(BossCommentTabBarCtr*)self.tabBarController setValue:_alertStr forKeyPath:@"alertString"];
            }
            if (_auditStatus == 1 || weakSelf.days < 0) {//服务到期 认证中不能进行任何操作
                _bigButtoon.hidden = NO;
            }else{
                _bigButtoon.hidden = YES;
            }
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)alertViewClick{
    if (_auditStatus == 1) {
        [self alertWithTitle:nil message:_alertStr cancelTitle:nil okTitle:@"我知道了"];
    }
    if (self.days < 0) {//服务到期
        NSString* string = @"此公司一个月的免费使用期已经结束，部分功能暂停使用，是否前往开通“老板点评”企业服务？";
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:string preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"稍后开通" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"开通服务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openService];
            
        }];
        [cancel setValue:ColorWithHex(KColor_Text_BlackColor) forKey:@"titleTextColor"];
        [okAction setValue:ColorWithHex(KColor_GoldColor) forKey:@"titleTextColor"];
        [alert addAction:cancel];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    if (cancelButtonTitle == nil) {

    }else{
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
        [alertController addAction:cancel];
    }
    
    
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([okTitle isEqualToString:@"我知道了"]) {
            [self initRequest];
        }else if ([okTitle isEqualToString:@"前往升级"]){
            
            NSString* urlStr = [self.version.DownloadUrl stringByReplacingOccurrencesOfString:@"http://" withString:@"itms-apps://"];
            NSURL* url = [NSURL URLWithString:urlStr];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }

        }else{//续费服务
            [self openService];
        }
    }];

    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -- 开通服务 目前是h5页面
- (void)openService{
    JXOpenServiceWebVC * webVC = [[JXOpenServiceWebVC alloc] init];
    webVC.companyId = self.companyId;
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark -- 所有员工
- (void)putArchivesClick{
    StaffListVC * staffVC = [[StaffListVC alloc] init];
    staffVC.secondVC = self;
    staffVC.companyId = self.companyId;
    staffVC.hidesBottomBarWhenPushed = YES;
    staffVC.superHeaderView = _workView;
    [self.navigationController pushViewController:staffVC animated:YES];
}

#pragma mark -- 添加评价
- (void)commentBtnClick{    
    CommentsListVC * commenstList = [[CommentsListVC alloc] init];
    commenstList.hidesBottomBarWhenPushed = YES;
    commenstList.companyId = self.companyId;
    [self.navigationController pushViewController:commenstList animated:YES];
}
#pragma mark -- 离任报告
- (void)liZhiClick{
    ReportListVC * listDepartVC = [[ReportListVC alloc] init];
    listDepartVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listDepartVC animated:YES];
}

#pragma mark -- 查询背景调查
- (void)checkCommentClick{
//
//    JXMessageVC *messageVC = [[JXMessageVC alloc] init];
//    messageVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:messageVC animated:YES];
    
    ExamineBackdropVC * checkStaffVC = [[ExamineBackdropVC alloc] init];
    checkStaffVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkStaffVC animated:YES];
}
#pragma mark -- 查询招聘
- (void)advertiseClick{

    JobPublicListViewController * jobVC = [[JobPublicListViewController alloc] init];
    [self.navigationController pushViewController:jobVC animated:YES];
}

#pragma mark -- 消息
- (void)messageClick{

//    InvitationRegistVC * invitationVC = [[InvitationRegistVC alloc] init];
//    invitationVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:invitationVC animated:YES];
    JXMessageVC *messageVC = [[JXMessageVC alloc] init];
    messageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageVC animated:YES];

}

#pragma mark -- 邀请企业注册
- (void)invitationClick{
    InvitationRegistVC * invitationVC = [[InvitationRegistVC alloc] init];
    invitationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:invitationVC animated:YES];
}

#pragma mark - 检查更新
- (void)existeVersion{
    // 取当前项目版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [WorkbenchRequest getExisteVersion:version success:^(VersionEntity *versionEntity) {
        
        self.version = versionEntity;
        Log(@"%@",versionEntity);
        if (versionEntity.UpgradeType == RecommendedUpdate) { // 建议更新  // 目前没有强制更新，所一样
            [self alertWithTitle:@"" message:[NSString stringWithFormat:@"%@",versionEntity.Description] cancelTitle:@"暂不升级" okTitle:@"前往升级"];
        }else if(versionEntity.UpgradeType == ForcedUpdate){ // 强制更新
            [self alertWithTitle:@"" message:[NSString stringWithFormat:@"%@",versionEntity.Description] cancelTitle:@"暂不升级" okTitle:@"前往升级"];
        }
    } fail:^(NSError *error) {
        Log(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
