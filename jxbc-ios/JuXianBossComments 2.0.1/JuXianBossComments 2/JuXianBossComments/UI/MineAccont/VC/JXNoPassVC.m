//
//  JXNoPassVC.m
//  JuXianBossComments
//
//  Created by wy on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXNoPassVC.h"
#import "IWTextView.h"
#import "JXJudgeListVC.h"
#import "JXMessageVC.h"

@interface JXNoPassVC ()<UITextViewDelegate,UITextViewDelegate,JXFooterViewDelegate>

@property(nonatomic,strong)IWTextView *iwTextView;
@property (nonatomic,strong)CompanyMembeEntity * myEntity;

@end

@implementation JXNoPassVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"审核不通过";
    [self isShowLeftButton:YES];
    _myEntity = [UserAuthentication GetMyInformation];
    [self initUI];
}

- (void)initUI{

    UILabel * bgtLabel = [UILabel labelWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 44) title:@"您希望提交人怎么调整？" titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:1];
    bgtLabel.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    bgtLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:bgtLabel];
    
    _iwTextView = [[IWTextView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 150)];
    _iwTextView.placeholder = @"  请输入不通过的理由，最多200个字";
    _iwTextView.delegate = self;
    [self.view addSubview:_iwTextView];
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.y = CGRectGetMaxY(_iwTextView.frame);
    footerView.delegate = self;
    footerView.x = (SCREEN_WIDTH - footerView.width) * 0.5;
    footerView.nextLabel.text = @"审核不通过";
    [self.view addSubview:footerView];
}

- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    if (_iwTextView.text.length == 0) {
        [SVProgressHUD showSuccessWithStatus:@"请输入评价内容"];
        return;
    }
    if (_iwTextView.text.length > 200) {
        [SVProgressHUD showSuccessWithStatus:@"评价理由超过了200字"];
        return;
    }
    
    
    NSInteger num = self.ArchiveModel.CompanyId;
    self.ArchiveModel.RejectReason = _iwTextView.text;
    
    [self showLoadingIndicator];
    MJWeakSelf
    [MineRequest PostArchiveCommentAuditReject:self.ArchiveModel withCompanyId:num success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        if ([result integerValue] > 0) {
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            
            if ([self.navigationController.viewControllers[1] isKindOfClass:[JXMessageVC class]]) {
                
                JXMessageVC * messageVC = self.navigationController.viewControllers[1];
                [messageVC.jxTableView.mj_header beginRefreshing];

            }
            if ([self.navigationController.viewControllers[1] isKindOfClass:[JXJudgeListVC class]]) {
                JXJudgeListVC * judge = self.navigationController.viewControllers[1];
                [judge.jxCollectionView.mj_header beginRefreshing];
                
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            });
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
