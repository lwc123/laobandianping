//
//  ReportListVC.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ReportListVC.h"
#import "DepartureListCell.h"
#import "DepartureDetail.h"
#import "AddDepartureReportVC.h"
#import "SearchDepartureVC.h"
#
@interface ReportListVC ()<SeachViewDelegate>
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)NSMutableArray *tmpArray;
@property (nonatomic,strong)NilView * nilView;
@property (nonatomic,strong)CompanyMembeEntity * bossInformation;
@property (nonatomic,copy)NSString * realName;

@property (nonatomic, assign) int page;

@property (nonatomic, assign) int size;

@end
@implementation ReportListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"离任报告";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"添加"];
    [self initData];
    [self initUI];
    [self.jxTableView.mj_header beginRefreshing];
}

- (void)initData{
    
    _bossInformation = [UserAuthentication GetBossInformation];
    _dataArray = [NSArray array];
    _tmpArray = [NSMutableArray array];
    
    self.page = 1;
    self.size = 20;
}

- (void)initUI{
    SeachView * searchView = [SeachView seachView];
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    searchView.delegate = self;
    [self.view addSubview:searchView];
    
//    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - 30 - 10);
    self.jxTableView.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), SCREEN_WIDTH, SCREEN_HEIGHT -64 - 50);

    self.jxTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.jxTableView.separatorColor = KColor_CellColor;
    self.jxTableView.tableFooterView = [[UIView alloc] init];
    [self.jxTableView registerNib:[UINib nibWithNibName:@"DepartureListCell" bundle:nil] forCellReuseIdentifier:@"departureListCell"];
    
    __weak typeof(self) weakSelf = self;
    //下拉
    [self.jxTableView setDragDownRefreshWith:^{
        weakSelf.page = 1;
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
    [WorkbenchRequest getCommentSearchListWithCompanyId:_bossInformation.CompanyId commentType:1 name:_realName page:weakSelf.page size:weakSelf.size success:^(JSONModelArray *array) {
        [weakSelf dismissLoadingIndicator];
        NSLog(@"array===%@",array);
        
        if (array.count == 0) {
            [self.jxTableView endRefresh];
            if (_page == 1) {
                
                if (!_nilView) {
                    _nilView = [[NilView alloc] initWithFrame:self.view.bounds];
                    _nilView.labelStr = @"还没有离任报告";
                    _nilView.isHiddenButton = NO;
                    UIButton * btn = [[UIButton alloc] init];
                    btn = [_nilView viewWithTag:2000];
                    [btn setTitle:@"添加离任报告" forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                }
                [self.jxTableView addSubview:_nilView];
                [self.jxTableView reloadData];
            }else{
                //                [PublicUseMethod showAlertView:@"添加阶段评价"];
            }
        }else{
            [_nilView removeFromSuperview];
            if (weakSelf.page == 1) {
                weakSelf.dataArray = @[];
            }
            weakSelf.page++;
            weakSelf.tmpArray = weakSelf.dataArray.mutableCopy;
            
            for (ArchiveCommentEntity *model in array) {
                [_tmpArray addObject:model];
            }
            _dataArray = _tmpArray.copy;
            [self.jxTableView endRefresh];
            [self.jxTableView reloadData];
            
        }
    } fail:^(NSError *error) {
        [weakSelf dismissLoadingIndicator];
        [self.jxTableView endRefresh];
        NSLog(@"error===%@",error);
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DepartureListCell * listCell = [tableView dequeueReusableCellWithIdentifier:@"departureListCell" forIndexPath:indexPath];
    ArchiveCommentEntity * model = _dataArray[indexPath.row];
    listCell.archiveModel = model;
    return listCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ArchiveCommentEntity * model = _dataArray[indexPath.row];
    DepartureDetail * commentDetail = [[DepartureDetail alloc] init];
    commentDetail.commentId = model.CommentId;
    commentDetail.archiveId = model.ArchiveId;
    [self.navigationController pushViewController:commentDetail animated:YES];
}

- (void)rightButtonAction:(UIButton *)button{
    AddDepartureReportVC * aepartureVC = [[AddDepartureReportVC alloc] init];
    aepartureVC.title = @"添加离任报告";
    [self.navigationController pushViewController:aepartureVC animated:YES];
}

//搜索代理
- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView{
    SearchDepartureVC * searchVC = [[SearchDepartureVC alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
