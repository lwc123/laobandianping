//
//  UserNoBindIDCardVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "UserNoBindIDCardVC.h"
#import "JHNilView.h"
#import "JXBindIDCardVC.h"

@interface UserNoBindIDCardVC ()<JXFooterViewDelegate>

@property (nonatomic,strong)JHNilView * jhView;
@property (nonatomic,strong)UIView * lookView;
@property (nonatomic,strong)UILabel * explainLabel;

@end

@implementation UserNoBindIDCardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的档案";
    [self isShowLeftButton:YES];
    [self initRequest];
}

- (void)initRequest{

    [UserWorkbenchRequest getPrivatenessArchiveSummarySuccess:^(PrivatenessArchiveSummary *archiveSummary) {
        
        if (archiveSummary.StageEvaluationNum != 0 || archiveSummary.DepartureReportNum != 0) {
            [self initLookView:archiveSummary];
        }else{
            [self initNoView];
        }
    } fail:^(NSError *error) {
        
        NSLog(@"error===%@",error);
        
    }];
}

- (void)initNoView{

    _jhView = [[JHNilView alloc] initWithFrame:self.view.bounds];
    _jhView.labelStr = @"暂无老板对您进行评价";
    _jhView.myStr = @"邀请老板对你点评，建立你的职业诚信标签，同时还可获得现金奖励！";
    [self.view addSubview:_jhView];

}

- (void)initLookView:(PrivatenessArchiveSummary *)archiveSummary{
    
    //第二种情况
    _lookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    _lookView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
    _explainLabel = [UILabel labelWithFrame:CGRectMake(40, 20, SCREEN_WIDTH - 80, 40) title:@" " titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:0];
    _explainLabel.text = [NSString stringWithFormat:@"通过手机号判定，发现您名下有来自%ld位老板的%ld条工作评价、%ld份离任报告",archiveSummary.ArchiveNum,archiveSummary.StageEvaluationNum,archiveSummary.DepartureReportNum];
    
    [_lookView addSubview:_explainLabel];
    
    JXFooterView * footerView = [JXFooterView footerView];
    footerView.frame = CGRectMake(0, CGRectGetMaxY(_explainLabel.frame) + 25, SCREEN_WIDTH, 44);
    footerView.delegate = self;
    footerView.nextLabel.text = @"马上查看";
    [_lookView addSubview:footerView];
    [self.view addSubview:_lookView];
    
}

#pragma mark -- 马上查看
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{
    
    JXBindIDCardVC * bindIDCardVC = [[JXBindIDCardVC alloc] init];
    [self.navigationController pushViewController:bindIDCardVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
