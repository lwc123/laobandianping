//
//  MyCommentListVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "MyCommentListVC.h"
#import "CompanyReputationListCell.h"
#import "OpinionCompanyDetailVC.h"
#import "UserCommentDetailVC.h"
#define Size 15
@interface MyCommentListVC ()<CompanyReputationListCellDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NilView * nilview;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) ConsoleEntity *consoleEntity;
@end

@implementation MyCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的点评";
    [self isShowLeftButton:YES];
    [self initTotal];
    _page = 1;
    [self initCommentListRequest];
    [self initUI];
}

- (void)initUI{



}

- (void)initTotal{
    [self showLoadingIndicator];
    MJWeakSelf
    [UserOpinionRequest getConsoleIndexSuccess:^(ConsoleEntity *consoleEntity) {
        [weakSelf dismissLoadingIndicator];
        _consoleEntity = consoleEntity;
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];
    
}

- (void)initCommentListRequest{

    MJWeakSelf
    [self showLoadingIndicator];
    [UserOpinionRequest getOpinionMineListPage:weakSelf.page size:Size success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];

        if (array.count == 0) {
            if (weakSelf.page == 1) {
                [self.jxTableView addSubview:self.nilview];
            }else{
                //                [PublicUseMethod showAlertView:@"米有数据"];
            }
        }else{
            [self.nilview removeFromSuperview];
            
            if (weakSelf.page == 1) {
                // 清空数组
                weakSelf.dataArray = @[].mutableCopy;
            }
            
            //            weakSelf.page++;
            for (OpinionEntity * model in array) {
                if ([model isKindOfClass:[OpinionEntity class]]) {
                    [weakSelf.dataArray addObject:model];
                }
            }
        }
        [weakSelf.jxTableView endRefresh];
        [weakSelf.jxTableView reloadData];
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [weakSelf.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
    }];


}

#pragma mark -- tableView 的delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) return 38;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellId = @"companyReputationListCell";
    CompanyReputationListCell * listCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!listCell) {
        listCell = [[CompanyReputationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    OpinionEntity * opinionEntity = self.dataArray[indexPath.section];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    listCell.indexPath = indexPath;
    listCell.delegate = self;
    listCell.opinionModel = opinionEntity;
    self.cellHeight = listCell.cellHeight;
    return listCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return self.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        UILabel * label = [UILabel labelWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 38) title:@" " titleColor:[PublicUseMethod setColor:KColor_Text_EumeColor] fontSize:15.0 numberOfLines:1];
        label.text = [NSString stringWithFormat:@"   共%ld条点评",_consoleEntity.OpinionTotal];

        return label;
    }
    return nil;
}

#pragma mark -- 公司详情
- (void)ReputationListCellCompanydetail:(CompanyReputationListCell *)listCell indexPath:(NSIndexPath *)indexPath{
    
    OpinionEntity * opinionEntity = self.dataArray[indexPath.row];
    OpinionCompanyDetailVC * companyDetailVC = [[OpinionCompanyDetailVC alloc] init];
    companyDetailVC.title = opinionEntity.Company.CompanyName;
    companyDetailVC.companyEntity = opinionEntity.Company;
    companyDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:companyDetailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OpinionEntity * opinionEntity = self.dataArray[indexPath.row];
    UserCommentDetailVC * detailVC =[[UserCommentDetailVC alloc] init];
    detailVC.title = @"点评详情";
    detailVC.opinionEntity = opinionEntity;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (NilView *)nilview{
    
    if (_nilview == nil) {
        _nilview = [[NilView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 300)];
        _nilview.labelStr = @"暂时还没有评价";
        _nilview.isHiddenButton = YES;
    }
    return _nilview;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
