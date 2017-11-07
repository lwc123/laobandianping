//
//  AskforJobVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/23.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AskforJobVC.h"
#import "AskforJobCell.h"
#import "UserSearchJobVC.h"
#import "JobdetailVC.h"

const static int pageSize = 20;

@interface AskforJobVC ()<SeachViewDelegate>{

    NSMutableArray<JobEntity *> *_dataArray;

}

@property (nonatomic, strong) NilView * nilview;

// 记录数据页数
@property (nonatomic, assign) int pageNum ;


@end

@implementation AskforJobVC

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    /*
     @property (nonatomic, copy) NSString *jobName;
     @property (nonatomic, copy) NSString *jobCity;
     @property (nonatomic, copy) NSString *industry;
     @property (nonatomic, copy) NSString *salaryRange;
     */
    if (self.jobName == nil) {
        self.jobName = @"";
    }
    if (self.jobCity == nil) {
        self.jobCity = @"";
    }
    if (self.industry == nil) {
        self.industry = @"";
    }
    if (self.salaryRange == nil) {
        
        self.salaryRange = @"";
    }
    [self askforJobRequest];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"职位";
    [self isShowLeftButton:YES];
    self.pageNum = 1;
    [self initUI];
    self.dataArray = @[].mutableCopy;
    
    // 下拉刷新
    MJWeakSelf
    [self.jxTableView setDragDownRefreshWith:^{
        // 更新数据
        [weakSelf updateData];
        
    }];
    // 上拉加载更多
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf askforJobRequest];
    }];
}

// 重置数据
- (void)updateData{
    MJWeakSelf
    weakSelf.pageNum = 1;
    // 请求数据
    [weakSelf askforJobRequest];
}

- (void)askforJobRequest{

    MJWeakSelf
    [self showLoadingIndicator];
    [UserWorkbenchRequest getJobQuerySearchWithJobName:self.jobName jobCity:self.jobCity industry:self.industry salaryRange:self.salaryRange page:self.pageNum size:pageSize success:^(NSArray *array) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        if (array.count != 0) {
            if (weakSelf.pageNum == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }
            weakSelf.pageNum++;
            for (JobEntity * model in array) {
                if ([model isKindOfClass:[JobEntity class]]) {
                    [weakSelf.dataArray addObject:model];
                }
            }
            
            [weakSelf.jxTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}




- (void)initUI{

    SeachView * searchView = [SeachView seachView];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    searchView.placehoderText.placeholder = @" 请输入职位关键字";
    searchView.placehoderText.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    searchView.delegate = self;
    [self.view addSubview:searchView];

    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 64- 50);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"AskforJobCell" bundle:nil] forCellReuseIdentifier:@"askforJobCell"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AskforJobCell * askforCell = [tableView dequeueReusableCellWithIdentifier:@"askforJobCell" forIndexPath:indexPath];
    askforCell.selectionStyle = UITableViewCellSelectionStyleNone;
    JobEntity * jobModel = self.dataArray[indexPath.row];
    askforCell.jobModel = jobModel;
    return askforCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JobEntity * jobModel = self.dataArray[indexPath.row];
    JobdetailVC * detailVC= [[JobdetailVC alloc] init];
    detailVC.companyId = jobModel.CompanyId;
    detailVC.jobId = jobModel.JobId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)setDataArray:(NSMutableArray*)dataArray{
    _dataArray = dataArray;
    if (_dataArray.count == 0) {
        [self.jxTableView addSubview:self.nilview];
    }else{
        [self.nilview removeFromSuperview];
    }

}

- (NSMutableArray*)dataArray{
    
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    if (_dataArray.count == 0) {
        [self.jxTableView addSubview:self.nilview];
    }else{
        [self.nilview removeFromSuperview];
    }

    
    return _dataArray;
}

- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
        _nilview.labelStr = @"目前没有相关职位";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}

- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{

    UserSearchJobVC * userSearchVC = [[UserSearchJobVC alloc] init];
    [self.navigationController pushViewController:userSearchVC animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
