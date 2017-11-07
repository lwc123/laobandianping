//
//  JXAuthorizationManagerVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/10/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXAuthorizationManagerVC.h"
#import "JXAddAuthorizeVC.h"//添加新的授权人
#import "AuthorizationCell.h"
#import "JXBasedNavigationController.h"
#import "JuXianBossComments-Bridging-Header.h"


@interface JXAuthorizationManagerVC ()<AuthorizationCellDelegate,JXFooterViewDelegate>
@property (nonatomic,strong)CompanyMembeEntity *membeEntity;
@property (nonatomic,strong)NSMutableArray *modelArray;
@property (nonatomic, strong) NSArray * dataArray;


@end

@implementation JXAuthorizationManagerVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _membeEntity = [UserAuthentication GetMyInformation];
    [self initData];
    [self initRequest];
    [self.jxTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"授权管理";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"添加"];
    [self initUI];
}
- (void)initData{
    _modelArray = [NSMutableArray array];
    _dataArray = [NSArray array];
}
- (void)initUI{
    self.jxTableView.frame = CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -10);
    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"AuthorizationCell" bundle:nil] forCellReuseIdentifier:@"authorizationCell"];
    
    JXFooterView *footerView = [JXFooterView footerView];
    footerView.delegate = self;
    footerView.nextLabel.text = @"添加授权人";
    self.jxTableView.tableFooterView = footerView;
}

- (void)initRequest{

     MJWeakSelf
    [self showLoadingIndicator];
    [MineRequest getCompanyMemberListCompanyId:_membeEntity.CompanyId success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            [PublicUseMethod showAlertView:@"暂无数据"];
        }else{
            
            if (_modelArray) {
                [_modelArray removeAllObjects];
            }
            for (CompanyMembeEntity * model in array) {
                if ([model isKindOfClass:[CompanyMembeEntity class]]) {
                    
                    if (model.Role == Role_Boss) {
                        [_modelArray insertObject:model atIndex:0];
                    }else{
                        [_modelArray addObject:model];
                    }
                }
            }
            _dataArray = _modelArray;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        NSLog(@"error==%@",error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AuthorizationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"authorizationCell" forIndexPath:indexPath];
    CompanyMembeEntity * model = _dataArray[indexPath.row];
    cell.membeEntity = model;
    cell.indexPath = indexPath;
    
    if (_membeEntity.Role == Role_manager) {
        if (_membeEntity.PassportId == model.PassportId) {
            cell.fixBtn.hidden = NO;
            cell.delegateBtn.hidden = YES;
            cell.rightConstraintofFixBtn.constant = 15;
        }else if (_membeEntity.PassportId != model.PassportId && model.Role == Role_manager){
            cell.fixBtn.hidden = YES;
            cell.delegateBtn.hidden = YES;
        }else{
            cell.fixBtn.hidden = NO;
            cell.delegateBtn.hidden = NO;
        }
    }
    
    if (_membeEntity.Role == Role_Boss) {
        if (_membeEntity.PassportId == model.PassportId) {
            cell.fixBtn.hidden = YES;
            cell.delegateBtn.hidden = YES;

        }else{
            cell.fixBtn.hidden = NO;
            cell.delegateBtn.hidden = NO;

        }
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}
#pragma mark -- 修改授权人
- (void)authorizationCellClickedfixBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(AuthorizationCell *)authorizationCell{
    CompanyMembeEntity * model = _dataArray[indexPath.row];
    JXAddAuthorizeVC * addAuthorizeVC = [[JXAddAuthorizeVC alloc] init];
    addAuthorizeVC.title = @"修改授权人";
    addAuthorizeVC.allreaddyCompany = model;
    addAuthorizeVC.secondVC = self;
    [self.navigationController pushViewController:addAuthorizeVC animated:YES];
}

#pragma mark -- 删除授权人
- (void)authorizationCellClickedDelegateBtnWithIndexPath:(NSIndexPath *)indexPath WithCell:(AuthorizationCell *)authorizationCell{
    CompanyMembeEntity * model = _dataArray[indexPath.row];
    [self showLoadingIndicator];
    [MineRequest postDelegateCompanyMemberWith:model success:^(id result) {
        [self dismissLoadingIndicator];
        NSLog(@"result==%@",result);
        if (result) {
            [PublicUseMethod showAlertView:@"删除成功"];
            [self initRequest];
            [self.jxTableView reloadData];
        }
        
    } fail:^(NSError *error) {
        [self dismissLoadingIndicator];
        NSLog(@"error===%@",error);
    }];
}

//左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark -- 添加新的授权人
- (void)rightButtonAction:(UIButton *)button{
    JXAddAuthorizeVC * addAuthorizeVC = [[JXAddAuthorizeVC alloc] init];
    addAuthorizeVC.title = @"添加授权人";
    addAuthorizeVC.secondVC = self;
    [self.navigationController pushViewController:addAuthorizeVC animated:YES];
    
}


- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    JXAddAuthorizeVC * addAuthorizeVC = [[JXAddAuthorizeVC alloc] init];
    addAuthorizeVC.title = @"添加授权人";
    addAuthorizeVC.secondVC = self;
    [self.navigationController pushViewController:addAuthorizeVC animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
