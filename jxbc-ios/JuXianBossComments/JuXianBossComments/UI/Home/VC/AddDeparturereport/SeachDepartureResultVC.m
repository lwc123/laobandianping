//
//  SeachDepartureResultVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "SeachDepartureResultVC.h"
#import "DepartureListCell.h"
#import "DepartureDetail.h"
#import "AddDepartureReportVC.h"

@interface SeachDepartureResultVC ()<SeachViewDelegate>
@property (nonatomic, assign)int pageIndex;
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)CompanyMembeEntity * bossInformation;

@end

@implementation SeachDepartureResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询离任报告";
    [self isShowLeftButton:YES];
    [self initData];
    [self initUI];
    [self.jxTableView.mj_header beginRefreshing];
}

- (void)initData{
    _bossInformation = [UserAuthentication GetBossInformation];
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)tmpArray{
    if (_tmpArray == nil) {
        _tmpArray = [NSMutableArray array];
    }
    return _tmpArray;
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
    [self.jxTableView registerNib:[UINib nibWithNibName:@"DepartureListCell" bundle:nil] forCellReuseIdentifier:@"departureListCell"];
    
    __weak typeof(self) weakSelf = self;
    //下拉
    [self.jxTableView setDragDownRefreshWith:^{
        weakSelf.pageIndex = 1;
        [weakSelf initRequest];
    }];
    //上啦
    [self.jxTableView setDragUpLoadMoreWith:^{
        [weakSelf initRequest];
    }];

}


-(void)initRequest{
    //0代表阶段评价 1 代表离任评价
    __weak typeof(self) weakSelf = self;
    [self showLoadingIndicator];
    [WorkbenchRequest getCommentSearchListWithCompanyId:_bossInformation.CompanyId commentType:1 name:self.realName page:1 size:10 success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            if (_pageIndex == 1) {
                
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                    _nilView.labelStr = @"没有找到员工的离任报告";
                    _nilView.isHiddenButton = YES;
                }
                [self.jxTableView addSubview:_nilView];
                [self.jxTableView reloadData];
            }else{
                [PublicUseMethod showAlertView:@"添加离任报告"];
            }
        }else{
            [_nilView removeFromSuperview];
            
            for (ArchiveCommentEntity *model in array) {
                [self.tmpArray addObject:model];
            }
            self.dataArray = self.tmpArray;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
            self.pageIndex++;
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [self.jxTableView endRefresh];
        [PublicUseMethod showAlertView:error.localizedDescription];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DepartureListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"departureListCell" forIndexPath:indexPath];
    ArchiveCommentEntity * model = self.dataArray[indexPath.row];
    listCell.archiveModel = model;
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArchiveCommentEntity * model = self.dataArray[indexPath.row];
    DepartureDetail * commentDetail = [[DepartureDetail alloc] init];
    commentDetail.commentId = model.CommentId;
    [self.navigationController pushViewController:commentDetail animated:YES];
}


//搜索代理
- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
