//
//  SeachRecodeListVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachRecodeListVC.h"
#import "StaffListCell.h"
#import "AddStaffRecordVC.h"
#import "WorkCommentsVC.h"
#import "AddDepartureReportVC.h"
#import "StaffListVC.h"
#import "StaffDetailVC.h"

@interface SeachRecodeListVC ()<SeachViewDelegate>

@property (nonatomic,strong)UIButton * searchBtn;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)CompanyMembeEntity * bossInformation;
@property (nonatomic, assign)int pageIndex;
@property (nonatomic, assign)int size;

@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
@end

@implementation SeachRecodeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加评价查询员工档案列表
    self.title = @"查询员工";
    [self isShowLeftButton:YES];
    [self initData];
//    [self initRequest];
    [self initUI];
    [self.jxTableView.mj_header beginRefreshing];

}

- (void)initData{

    _bossInformation = [UserAuthentication GetBossInformation];
//    _dataArray = [NSArray array];
    _tmpArray = [NSMutableArray array];
//    _pageIndex = 1;
//    _size = 10;
}

- (NSArray *)dataArray{

    if (_dataArray == nil) {
        
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


- (void)initRequest{

    MJWeakSelf
    [self showLoadingIndicator];
    [WorkbenchRequest getArchiveSearchCompanyId:_bossInformation.CompanyId realName:self.realName page:_pageIndex size:_size success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            if (_pageIndex == 1) {
                
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                    _nilView.labelStr = @"没有找到你查询的员工";
                    _nilView.isHiddenButton = YES;
                    UIButton * btn = [[UIButton alloc] init];
                    btn = [_nilView viewWithTag:2000];
                    [btn setTitle:@"建立员工档案" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.jxTableView addSubview:_nilView];
                [self.jxTableView reloadData];
            }else{
                
            }
        }else{
            [_nilView removeFromSuperview];
            
            for (ArchiveCommentEntity *model in array) {
                [_tmpArray addObject:model];
            }
            weakSelf.dataArray = _tmpArray;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
            self.pageIndex++;
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
}

- (void)initUI{
    SeachView * searchView = [SeachView seachView];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    searchView.delegate = self;
    searchView.placehoderText.text = self.realName;
    [self.view addSubview:searchView];
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 10);
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    [self.jxTableView registerNib:[UINib nibWithNibName:@"StaffListCell" bundle:nil] forCellReuseIdentifier:@"staffListCell"];
    __weak typeof(self) weakSelf = self;
    //下拉
    [self.jxTableView setDragDownRefreshWith:^{
        weakSelf.pageIndex = 1;
        weakSelf.size = 10;
        [weakSelf initRequest];
    }];
    //上啦
    [self.jxTableView setDragUpLoadMoreWith:^{
        weakSelf.size = 10;
        [weakSelf initRequest];
    }];

}

- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StaffListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"staffListCell" forIndexPath:indexPath];
    EmployeArchiveEntity * model = self.dataArray[indexPath.row];
    listCell.workItemMolde = model.WorkItem;
    listCell.employeModel =  model;
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.navigationController.viewControllers[2] isKindOfClass:[WorkCommentsVC class]]) {//阶段评价
        EmployeArchiveEntity * archiveEntity = self.dataArray[indexPath.row];
        WorkCommentsVC * commentVC = self.navigationController.viewControllers[2];
        commentVC.nameStr = archiveEntity.RealName;
        commentVC.imageStr = archiveEntity.Picture;
        commentVC.archiveId = archiveEntity.ArchiveId;
        [commentVC.jxTableView reloadData];
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    }

    if ([self.navigationController.viewControllers[2] isKindOfClass:[AddDepartureReportVC class]]) {//离任评价
        EmployeArchiveEntity * archiveEntity = self.dataArray[indexPath.row];
        
        AddDepartureReportVC * reportVC = self.navigationController.viewControllers[2];
        reportVC.nameStr = archiveEntity.RealName;
        reportVC.imageStr = archiveEntity.Picture;
        reportVC.archiveId = archiveEntity.ArchiveId;
        reportVC.departmenStr = archiveEntity.WorkItem.Department;
        reportVC.postTitleStr = archiveEntity.WorkItem.PostTitle;
        [reportVC.jxTableView reloadData];
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    }
    
    if ([self.navigationController.viewControllers[1] isKindOfClass:[StaffListVC class]]) {//所有员工档案
        EmployeArchiveEntity * archiveEntity = self.dataArray[indexPath.row];
        StaffDetailVC * staffDetail = [[StaffDetailVC alloc] init];
        staffDetail.archiveId = archiveEntity.ArchiveId;
        staffDetail.companyId = archiveEntity.CompanyId;
        staffDetail.secondVC = self;
        [self.navigationController pushViewController:staffDetail animated:YES];
    }
}

#pragma mark -- 添加员工档案
- (void)rightButtonAction:(UIButton *)button{
    
    AddStaffRecordVC * addStaffVC = [[AddStaffRecordVC alloc] init];
    addStaffVC.secondVC = self;
    [self.navigationController pushViewController:addStaffVC animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    
    if ([self.navigationController.viewControllers[2] isKindOfClass:[AddDepartureReportVC class]]) {//如果是离任
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([self.navigationController.viewControllers[2] isKindOfClass:[WorkCommentsVC class]]){//阶段评价
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
