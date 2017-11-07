//
//  SectionManagerVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SectionManagerVC.h"
#import "JHPutVC.h"
#import "DepaartmentCell.h"

@interface SectionManagerVC ()<DepaartmentCelllDelegate>
@property (nonatomic,strong)CompanyMembeEntity *bossEntity;

@property (nonatomic,strong)NSMutableArray *modelArray;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic,strong)NilView * nilView;


@end

@implementation SectionManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"部门管理";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"添加"];
    [self initData];
    [self initUI];
    [self.jxTableView beginRefresh];

}

- (void)initData{

    _modelArray = [NSMutableArray array];
    _dataArray = [NSArray array];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _bossEntity = [UserAuthentication GetBossInformation];
    [self initRequest];
}

- (void)initUI{

    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64- 10);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"DepaartmentCell" bundle:nil] forCellReuseIdentifier:@"depaartmentCell"];
    
    __weak typeof(self) weakSelf = self;
    //下拉加载
    [self.jxTableView setDragDownRefreshWith:^{
        
        [weakSelf initRequest];
    }];
    //上啦加载更多
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf initRequest];
    }];
    
}
- (void)initRequest{

    [self showLoadingIndicator];
    MJWeakSelf
    [MineRequest getDepartmentWithCompanyId:_bossEntity.CompanyId success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            if (!_nilView) {
                _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                _nilView.labelStr = @"还没有部门";
                _nilView.buttonTitle = @"添加";
                WEAKSELF(self)
                _nilView.block = ^{
                    [weakself rightButtonAction:nil];
                };
            }
            [weakSelf.jxTableView addSubview:_nilView];
            [weakSelf.jxTableView endRefresh];
            [weakSelf.jxTableView reloadData];
        }else{
            
            [_nilView removeFromSuperview];
            if (_modelArray.count!=0) {
                [_modelArray removeAllObjects];
            }
            for (DepartmentsEntity * model in array) {
                [_modelArray addObject:model];
            }
            _dataArray = _modelArray;
            [weakSelf.jxTableView endRefresh];
            [weakSelf.jxTableView reloadData];
        }
        
    } fail:^(NSError *error) {
         [weakSelf.jxTableView endRefresh];
        [weakSelf dismissLoadingIndicator];
//        [PublicUseMethod showAlertView:@""];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    DepaartmentCell * departmentCell = [tableView dequeueReusableCellWithIdentifier:@"depaartmentCell" forIndexPath:indexPath];
    departmentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    departmentCell.delegate = self;
    DepartmentsEntity * model = _dataArray[indexPath.row];
    departmentCell.departmentEntity = model;
    departmentCell.indexPath = indexPath;
    return departmentCell;
}

#pragma mark -- 修改
- (void)DepaartmentCellClickedfixBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(DepaartmentCell *)authorizationCell{
    DepartmentsEntity * model = _dataArray[indexPath.row];
    JHPutVC * put = [[JHPutVC alloc]init];
    put.secondVC = self;
    put.title = @"修改部门";
    put.jhTextField.text = model.DeptName;
    put.departmentsEntity = model;
    [self.navigationController pushViewController:put animated:YES];
}

#pragma mark -- 删除
- (void)DepaartmentCelldDelegateBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(DepaartmentCell *)authorizationCell{
    DepartmentsEntity * model = _dataArray[indexPath.row];
    
    if (model.StaffNumber  == 0) {//该部门没有人 可以删除
        [self alertWithTitle:nil message:@"确定要删除" cancelTitle:@"关闭" okTitle:@"确定" with:model];
        
    }else{//部门有人不能删除
        [PublicUseMethod showAlertView:@"该部门下有员工档案，暂不能删除"];
    }
}

- (void)delegateWith:(DepartmentsEntity *)model{

    [self showLoadingIndicator];
    MJWeakSelf
    [MineRequest postDeleteDepartmentWith:model success:^(id result) {
        [weakSelf dismissLoadingIndicator];
        
        NSInteger dic = [result[@"Success"] integerValue];
        if (dic > 0) {
            [PublicUseMethod showAlertView:@"删除成功"];
            [self.jxTableView.mj_header beginRefreshing];
        }else{
            
            NSString * messageError = result[@"ErrorMessage"];
            [PublicUseMethod showAlertView:messageError];
        }
        
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:[NSString stringWithFormat:@"删除失败：%@",error.localizedDescription]];
    }];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelButtonTitle okTitle:(NSString *)okTitle with:(DepartmentsEntity *)departmentsEntity{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [cancel setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [alertController addAction:cancel];
    //确定
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self delegateWith:departmentsEntity];
    }];
    
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)rightButtonAction:(UIButton *)button{
    
    JHPutVC * put = [[JHPutVC alloc]init];
    put.secondVC = self;
    put.title = @"添加部门";
    put.textStr = @" 请输入部门名称";
    [self.navigationController pushViewController:put animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
