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
#import "JobQueryListViewController.h"
#import "JobPublicListViewController.h"
#import "SignOut.h"
#import "JXOpenServiceWebVC.h"
#import "BossCommentTabBarCtr.h"
#import "CompanyWordMouthVC.h"


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
@property (nonatomic, strong) UIButton *outBtn;
@property (nonatomic, strong) CompanySummary *company;
@end

@implementation WorkbenchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSString * companyIdStr = [[NSUserDefaults standardUserDefaults] valueForKey:CompanyChoiceKey];
    self.companyId = [companyIdStr longLongValue];
    [self initRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 检查更新
    [self existeVersion];
    [self initUI];
}
#pragma maek -- 退出演示
- (void)outButton:(UIButton *)btn{

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
    _workView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 226);
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
    _threeBentchView.recodeLabel.text = @"公司口碑";
    _threeBentchView.fixUnreadMessage.hidden = YES;
    _threeBentchView.recodeImageView.image = [UIImage imageNamed:@"beijingdiaocha"];
    _threeBentchView.twoView.hidden = YES;
    _threeBentchView.threeView.hidden = YES;
    [self.view addSubview:_threeBentchView];
    [_threeBentchView.oneBtn addTarget:self action:@selector(wordMouthBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    AnonymousAccount *myaccount = [UserAuthentication GetCurrentAccount];
    if ([myaccount.MobilePhone isEqualToString:DemoPhone]) {//演示账号
        [self.view addSubview:self.outBtn];
    }
    UIButton * bigButtoon = [UIButton buttonWithType:UIButtonTypeCustom];
    bigButtoon.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bigButtoon.backgroundColor = [UIColor clearColor];
    [bigButtoon bringSubviewToFront:self.view];
//    [self.view addSubview:bigButtoon];
    
    [bigButtoon addTarget:self action:@selector(alertViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    _bigButtoon.hidden = YES;
    _bigButtoon = bigButtoon;

}



- (UIButton *)outBtn{

    if (_outBtn == nil) {
        _outBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _outBtn.frame = CGRectMake((SCREEN_WIDTH - 65) * 0.5, CGRectGetMaxY(_twoBentchView.frame) + 25, 65, 30);
        _outBtn.contentMode = UIViewContentModeRight;
        _outBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_outBtn setTitle:@"退出演示" forState:UIControlStateNormal];
        _outBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _outBtn.layer.masksToBounds = YES;
        _outBtn.layer.cornerRadius = 4;
        _outBtn.layer.borderWidth = 2;
        _outBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
        [_outBtn setTitleColor:[PublicUseMethod setColor:KColor_GoldColor] forState:UIControlStateNormal];
        [_outBtn addTarget:self action:@selector(outButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _outBtn;
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
        weakSelf.company = summaryEntity;
        if (![summaryEntity isKindOfClass:[NSNull class]]) {
            weakSelf.days = [summaryEntity getServiceDays];
            [weak_workView.iconImageView sd_setImageWithURL:[NSURL URLWithString:summaryEntity.CompanyLogo] placeholderImage:Company_LOGO_Image];
            // 企业简称
            weak_workView.companyName.text = summaryEntity.CompanyAbbr;
            weak_workView.LegalName.text = summaryEntity.LegalName;
            weak_workView.EmployedNum.text = [NSString stringWithFormat:@"%ld",summaryEntity.EmployedNum];
            weak_workView.DimissionNum.text = [NSString stringWithFormat:@"%ld",summaryEntity.DimissionNum];
            weak_workView.stageEvaluationNum.text = [NSString stringWithFormat:@"%ld",(long)summaryEntity.StageEvaluationNum];
            weak_workView.reportNum.text = [NSString stringWithFormat:@"%ld",(long)summaryEntity.DepartureReportNum];
            weak_workView.auditSatus.text = @" ";

            // 认证状态
            if (summaryEntity.AuditStatus == 1) {
                weak_workView.auditImageView.hidden = NO;
                weak_workView.auditImageView.image = [UIImage imageNamed:@"审核中"];
            }else  if (summaryEntity.AuditStatus == 2) {
                weak_workView.auditImageView.hidden = NO;
            }
            
            if (weakSelf.days < 0) {//过期了
                weak_workView.auditImageView.hidden = NO;
                weak_workView.auditImageView.image = [UIImage imageNamed:@"已到期"];
            }
//            else if (weakSelf.days <= 30 && weakSelf.days > 0){
//                weak_workView.auditImageView.hidden = NO;
//                weak_workView.auditImageView.image = [UIImage imageNamed:@"即将到期"];
//                weak_workView.daysLabel.text = [NSString stringWithFormat:@"剩余%ld天",weakSelf.days + 1];
//            }
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
        [self alertWithTitle:nil message:_alertStr cancelTitle:@"退出登录" okTitle:@"我知道了"];
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
    
    MJWeakSelf
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];

    if (cancelButtonTitle == nil) {

    }else{
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf showLoadingIndicator];
            [SignOut signOut];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf dismissLoadingIndicator];
            });
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
    staffVC.company = self.company;
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

#pragma mark -- 管理口碑
-(void)wordMouthBtn{
    
    CompanyWordMouthVC * wordVC = [[CompanyWordMouthVC alloc] init];
    wordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wordVC animated:YES];
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
