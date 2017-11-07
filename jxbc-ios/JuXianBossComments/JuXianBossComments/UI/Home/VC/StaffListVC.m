//
//  StaffListVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "StaffListVC.h"
#import "StaffListCell.h"
#import "AddStaffRecordVC.h"//添加员工档案
#import "StaffDetailVC.h"//员工详情
#import "NoStaffView.h"
#import "RecodeCheckVC.h"
#import "WorkbenchViewController.h"
#import "AddDepartureReportVC.h"//离任报告
#import "NoStaffView.h"
#import "DepartmentsEntity.h"//部门数组
#import "EmployeArchiveEntity.h"//档案
#import "SectionView.h"
#import "WorkCommentsVC.h"


@interface StaffListVC ()<SeachViewDelegate>{
    
    AddDepartureReportVC * _addDepartureVC;
}

@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,strong)NoStaffView * noView;
@property (nonatomic,strong)NSArray * departmentsModelArray;
@property (nonatomic,strong)NSArray * employeListModelArray;
//离任数组
@property (nonatomic,strong)NSMutableArray * outgoingArray;
@property (nonatomic,strong)NSMutableArray * onJobArray;
@property (nonatomic,strong)NSArray * workItemArray;

@property (nonatomic,strong)NSMutableArray * employeArray;

@property (nonatomic,strong)NSMutableArray * departmentsModelArrayTmp;
@property (nonatomic,strong)NSMutableArray * outgoingArrayTmp;
@property (nonatomic,strong)NSMutableArray * onJobArrayTmp;
@property (nonatomic,strong)NSMutableArray * employeArrayTmp;
@property (nonatomic,strong)NSMutableArray * employeListModelArrayTmp;

// 搜索框
@property (nonatomic, strong) SeachView *seachView;
// 头视图
@property (nonatomic, strong) WorkHeaderView *headerView;

@end

@implementation StaffListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"员工档案";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"新建  "];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.noView removeFromSuperview];
    [self initData];
    [self initRequest];
    
}

- (void)initData{

    _departmentsModelArray = [NSArray array];
    _employeListModelArray = [NSArray array];
    _outgoingArray = [NSMutableArray array];
    _onJobArray = [NSMutableArray array];
    _workItemArray = [NSArray array];
    _employeArray = [NSMutableArray array];
    
}

- (void)initUI{
    
    self.seachView = [SeachView seachView];
    self.seachView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.seachView.delegate = self;
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(self.seachView.frame) + 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
    
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"StaffListCell" bundle:nil] forCellReuseIdentifier:@"staffListCell"];
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    
    _noView = [NoStaffView noStaffView];
    _noView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 370);
    
    [_noView.zaiZhiBtn addTarget:self action:@selector(zaiZhiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_noView.liZhiBtn addTarget:self action:@selector(liZhiBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    
}
- (void)initRequest{

    [self showLoadingIndicator];
    MJWeakSelf
    [WorkbenchRequest getEmployeArchiveListWithCompanyId:self.companyId success:^(EmployeArchiveListEntity *archiveListEntity) {
        [weakSelf dismissLoadingIndicator];
        if ([archiveListEntity isKindOfClass:[NSNull class]]) {
            return ;
        }
//        archiveListEntity.ArchiveLists = @[];  //测试下面的if用的
//        archiveListEntity.Departments = @[];
        if (archiveListEntity.ArchiveLists.count == 0) {
            // 1.25 更新 添加头部试图
            [self.jxTableView addSubview:_noView];
//            [self.view addSubview:self.headerView];
            self.jxTableView.y =  0;
            [self.jxTableView reloadData];
            return;
        }else{
            self.jxTableView.y = 50;
            [self.noView removeFromSuperview];
            [self.headerView removeFromSuperview];
            [self.view addSubview:self.seachView];
        }
        // 档案数组
        _employeListModelArray  = archiveListEntity.ArchiveLists;
        // 部门数组
        _departmentsModelArray = archiveListEntity.Departments;
        
        for (int i = 0 ; i <_employeListModelArray.count ; i++) {
            
            NSDictionary * dic = _employeListModelArray[i];
            EmployeArchiveEntity * employeEntity = [[EmployeArchiveEntity alloc] initWithDictionary:dic error:nil];
            if (employeEntity.IsDimission == 1) {//属于离任
                [_outgoingArray addObject:employeEntity];
            }else{
                [_onJobArray addObject:employeEntity];
            }
        }
        
        
        for (int j = 0; j < _departmentsModelArray.count; j++) {
            NSDictionary * departDic = _departmentsModelArray[j];
            DepartmentsEntity * departMentEntity = [[DepartmentsEntity alloc] initWithDictionary:departDic error:nil];
            NSMutableArray *arrayTemp = [NSMutableArray array];
            
            for (int i = 0; i<_onJobArray.count; i++) {
                EmployeArchiveEntity * employeEntity = _onJobArray[i];
                if (departMentEntity.DeptId == employeEntity.DeptId) {
                    [arrayTemp addObject:employeEntity];
                }
            }
            [_employeArray insertObject:arrayTemp atIndex:j];
            
            NSLog(@"departMentEntity.DeptId==%ld,_employeArray[j]==%@",departMentEntity.DeptId,_employeArray[j]);
        }
        NSLog(@"_outgoingArray%lu",(unsigned long)_employeArray.count);
        [weakSelf.jxTableView reloadData];
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (!self.outgoingArray) {
        return _departmentsModelArray.count;
    }
    if (self.outgoingArray.count == 0) {
        return _departmentsModelArray.count;
    }
    return _departmentsModelArray.count +1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == _departmentsModelArray.count) {
        return _outgoingArray.count;
    }else{
        return [_employeArray[section] count];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 39;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    StaffListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"staffListCell" forIndexPath:indexPath];
    if (indexPath.section == _departmentsModelArray.count) {//离任
        EmployeArchiveEntity * outEmployeModel = _outgoingArray[indexPath.row];
        listCell.workItemMolde = outEmployeModel.WorkItem;
        listCell.employeModel = outEmployeModel;
        
    }else{//在职
        
        EmployeArchiveEntity * inEmployeModel = _employeArray[indexPath.section][indexPath.row];
        listCell.workItemMolde = inEmployeModel.WorkItem;
        listCell.employeModel =inEmployeModel;
    }
    return listCell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSInteger lastSection = _departmentsModelArray.count;
    
    if (section == lastSection ) {// 最后一组且有离任员工时
        
        SectionView * outgoingView = [SectionView sectionView];
        outgoingView.departmentLabel.text = @" 已离任";
        outgoingView.StaffNumberLabel.text = [NSString stringWithFormat:@"%lu人",(unsigned long)_outgoingArray.count];
        return outgoingView;
        
    }else{
    
        NSDictionary * dic = _departmentsModelArray[section];
        DepartmentsEntity * departmentModel = [[DepartmentsEntity alloc] initWithDictionary:dic error:nil];
        SectionView * senctionView = [SectionView sectionView];
        senctionView.departmentLabel.text = departmentModel.DeptName;
        senctionView.StaffNumberLabel.text = [NSString stringWithFormat:@"%ld人",(unsigned long)[_employeArray[section] count]];
        return senctionView;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.secondVC isKindOfClass:[WorkbenchViewController class]]) {
        //从工作台进入点击进入员工档案详情
        StaffDetailVC * staffDetail = [[StaffDetailVC alloc] init];
        if (indexPath.section == _departmentsModelArray.count) {//离任员工
            EmployeArchiveEntity * outEmployeModel = _outgoingArray[indexPath.row];
            staffDetail.archiveId = outEmployeModel.ArchiveId;
            staffDetail.companyId = outEmployeModel.CompanyId;
        }else{//在职
            EmployeArchiveEntity * inEmployeModel = _employeArray[indexPath.section][indexPath.row];
            staffDetail.archiveId = inEmployeModel.ArchiveId;
            staffDetail.companyId = inEmployeModel.CompanyId;
        }
        
        [self.navigationController pushViewController:staffDetail animated:YES];
    }
    if ([self.secondVC isKindOfClass:[AddDepartureReportVC class]]) {//离任评价
        //从离任报告 传值
        [_addDepartureVC.jxTableView.mj_header beginRefreshing];

        if (indexPath.section ==  [_departmentsModelArray count]) {//离任
            
            EmployeArchiveEntity * outEmployeModel = _outgoingArray[indexPath.row];
            
            if ([outEmployeModel.DepartureReportNum integerValue] > 0) {//代表已经有离任报告了 不能添加
                [PublicUseMethod showAlertView:@"该员工已有离任报告"];
                
            }else{
            
                if (self.departBlock) {
                    self.departBlock(outEmployeModel);
                }
            }
        }else{//在职
            
            EmployeArchiveEntity * archiveEntity = _employeArray[indexPath.section][indexPath.row];
            if (self.departBlock) {
                
                self.departBlock(archiveEntity);
            }
        }        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([self.secondVC isKindOfClass:[WorkCommentsVC class]]) {//阶段评价
        if (indexPath.section ==  [_departmentsModelArray count]) {
            
            EmployeArchiveEntity * outEmployeModel = _outgoingArray[indexPath.row];
            if (self.block) {
                self.block(outEmployeModel.RealName,outEmployeModel.Picture,outEmployeModel.ArchiveId);
            }
        }else{//在职
            EmployeArchiveEntity * archiveEntity = _employeArray[indexPath.section][indexPath.row];
            if (self.block) {
                self.block(archiveEntity.RealName,archiveEntity.Picture,archiveEntity.ArchiveId);
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -- 建立在职员工档案
- (void)zaiZhiBtnClick{
    AddStaffRecordVC * addStaffVC = [[AddStaffRecordVC alloc] init];
    addStaffVC.companyId = self.companyId;
    addStaffVC.jobstatus = 1;
    [self.navigationController pushViewController:addStaffVC animated:YES];
}
#pragma mark -- 建立离任员工档案
- (void)liZhiBtnClick{
    
    AddStaffRecordVC * addStaffVC = [[AddStaffRecordVC alloc] init];
    addStaffVC.companyId = self.companyId;
    addStaffVC.jobstatus = 2;
    [self.navigationController pushViewController:addStaffVC animated:YES];
    
}
#pragma mark -- 查询员工
- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{
    RecodeCheckVC * recodeVC = [[RecodeCheckVC alloc] init];
    
    //从添加阶段评价 选择员工 查询
    if ([_secondVC isKindOfClass:[WorkCommentsVC class]]) {
        recodeVC.secondVC = _secondVC;
    }else{
        recodeVC.secondVC = self;
    }
    
    [UIView animateWithDuration:.35 animations:^{
        [self.navigationController pushViewController:recodeVC animated:YES];
    }];
}

- (void)rightButtonAction:(UIButton *)button{
    AddStaffRecordVC * addStaffVC = [[AddStaffRecordVC alloc] init];
    addStaffVC.companyId = self.companyId;
    addStaffVC.secondVC = self.secondVC;
    addStaffVC.title = @"建立员工档案";
    addStaffVC.jobstatus = 0;
    [self.navigationController pushViewController:addStaffVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (WorkHeaderView *)headerView{

    if (!_headerView) {
        
        _headerView = [WorkHeaderView workHeaderView];
        _headerView.companyName.text = self.company.CompanyAbbr;
        // 企业简称
        _headerView.LegalName.text = self.company.LegalName;
        // 认证状态
        if (self.company.AuditStatus == 1) {
            _headerView.auditImageView.image = [UIImage imageNamed:@"审核中"];
        }else  if (self.company.AuditStatus == 2) {
            _headerView.auditImageView.hidden = NO;
        }
        if ([self.company getServiceDays] < 0) {//过期了
            _headerView.auditImageView.image = [UIImage imageNamed:@"已到期"];
        }else if ([self.company getServiceDays] <= 30 && [self.company getServiceDays] > 0){
            _headerView.auditImageView.image = [UIImage imageNamed:@"即将到期"];
            _headerView.daysLabel.text = [NSString stringWithFormat:@"剩余%ld天",[self.company getServiceDays] + 1];
        }
//        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:_superHeaderView];
//        return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        
    }
    return _headerView;
}



@end
